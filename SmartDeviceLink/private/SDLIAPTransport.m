//  SDLIAPTransport.h


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "SDLIAPTransport.h"

#import "EAAccessory+SDLProtocols.h"
#import "EAAccessoryManager+SDLProtocols.h"
#import "SDLGlobals.h"
#import "SDLIAPConstants.h"
#import "SDLIAPControlSession.h"
#import "SDLIAPControlSessionDelegate.h"
#import "SDLIAPDataSession.h"
#import "SDLIAPDataSessionDelegate.h"
#import "SDLLogMacros.h"
#import <CommonCrypto/CommonDigest.h>

NS_ASSUME_NONNULL_BEGIN

int const CreateSessionRetries = 3;

@interface SDLIAPTransport () <SDLIAPControlSessionDelegate, SDLIAPDataSessionDelegate>

@property (nullable, strong, nonatomic) SDLIAPControlSession *controlSession;
@property (nullable, strong, nonatomic) SDLIAPDataSession *dataSession;
@property (assign, nonatomic) int retryCounter;
@property (assign, nonatomic) BOOL sessionSetupInProgress;
@property (assign, nonatomic) BOOL transportDestroyed;
@property (assign, nonatomic) BOOL accessoryConnectDuringActiveSession;

@end


@implementation SDLIAPTransport

- (instancetype)init {
    SDLLogV(@"SDLIAPTransport init");
    self = [super init];
    if (!self) {
        return nil;
    }

    _sessionSetupInProgress = NO;
    _transportDestroyed = NO;
    _dataSession = nil;
    _controlSession = nil;
    _retryCounter = 0;
    _accessoryConnectDuringActiveSession = NO;

    // Get notifications if an accessory connects in future
    [self sdl_startEventListening];

    // Wait for setup to complete before scanning for accessories

    return self;
}

#pragma mark - Notifications

/**
 *  Registers for system notifications about connected accessories and the app life cycle.
 */
- (void)sdl_startEventListening {
    SDLLogV(@"SDLIAPTransport started listening for events");
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(sdl_accessoryConnected:)
                                                 name:EAAccessoryDidConnectNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(sdl_accessoryDisconnected:)
                                                 name:EAAccessoryDidDisconnectNotification
                                               object:nil];
    [[EAAccessoryManager sharedAccessoryManager] registerForLocalNotifications];
}

/**
 *  Unsubscribes to notifications.
 */
- (void)sdl_stopEventListening {
    SDLLogV(@"SDLIAPTransport stopped listening for events");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark EAAccessory Notifications

/**
 *  Handles a notification sent by the system when a new accessory has been detected by attempting to connect to the new accessory.
 *
 *  @param notification Contains information about the connected accessory
 */
- (void)sdl_accessoryConnected:(NSNotification *)notification {
    EAAccessory *newAccessory = notification.userInfo[EAAccessoryKey];

    if ([self sdl_isDataSessionActive:self.dataSession newAccessory:newAccessory]) {
        self.accessoryConnectDuringActiveSession = YES;
        return;
    }

    double retryDelay = self.sdl_retryDelay;
    SDLLogD(@"Accessory Connected (%@), Opening in %0.03fs", notification.userInfo[EAAccessoryKey], retryDelay);

    self.retryCounter = 0;
    [self performSelector:@selector(sdl_connect:) withObject:nil afterDelay:retryDelay];
}

/**
 *  Checks if the newly connected accessory connected while a data session is already opened. This can happen when a session is established over bluetooth and then the user connects to the same head unit with a USB cord.
 *
 *  @param dataSession  The current data session
 *  @param newAccessory The newly connected accessory
 *  @return             True if the accessory connected while a data session is already in progress; false if not
 */
- (BOOL)sdl_isDataSessionActive:(nullable SDLIAPDataSession *)dataSession newAccessory:(EAAccessory *)newAccessory {
    if (dataSession == nil || !dataSession.isSessionInProgress) {
        return NO;
    }

    if (dataSession.isSessionInProgress && (dataSession.connectionID != newAccessory.connectionID)) {
        SDLLogD(@"Switching transports from Bluetooth to USB. Waiting for disconnect notification.");
        return YES;
    }

    return NO;
}

/**
 *  Handles a notification sent by the system when an accessory has been disconnected by cleaning up after the disconnected device.
 *
 *  @param notification Contains information about the connected accessory
 */
- (void)sdl_accessoryDisconnected:(NSNotification *)notification {
    EAAccessory *accessory = [notification.userInfo objectForKey:EAAccessoryKey];
    SDLLogD(@"Accessory with serial number: %@, and connectionID: %lu disconnecting.", accessory.serialNumber, (unsigned long)accessory.connectionID);

    if (self.accessoryConnectDuringActiveSession == YES) {
        SDLLogD(@"Switching transports from Bluetooth to USB. Will reconnect over Bluetooth after disconnecting the USB session.");
        self.accessoryConnectDuringActiveSession = NO;
    }

    if (!self.controlSession.isSessionInProgress && !self.dataSession.isSessionInProgress) {
        SDLLogV(@"Accessory (%@, %@), disconnected, but no session is in progress.", accessory.name, accessory.serialNumber);
        [self sdl_closeSessions];
    } else if (self.dataSession.isSessionInProgress) {
        if (self.dataSession.connectionID != accessory.connectionID) {
            SDLLogD(@"Accessory's connectionID, %lu, does not match the connectionID of the current data session, %lu. Another phone disconnected from the head unit. The session will not be closed.", accessory.connectionID, self.dataSession.connectionID);
            return;
        }
        // The data session has been established. Tell the delegate that the transport has disconnected. The lifecycle manager will destroy and create a new transport object.
        SDLLogV(@"Accessory (%@, %@) disconnected during a data session", accessory.name, accessory.serialNumber);
        [self sdl_destroyTransport];
    } else if (self.controlSession.isSessionInProgress) {
        if (self.controlSession.connectionID != accessory.connectionID) {
            SDLLogD(@"Accessory's connectionID, %lu, does not match the connectionID of the current control session, %lu. Another phone disconnected from the head unit. The session will not be closed.", accessory.connectionID, self.controlSession.connectionID);
            return;
        }
        // The data session has yet to be established so the transport has not yet connected. DO NOT unregister for notifications from the accessory.
        SDLLogV(@"Accessory (%@, %@) disconnected during a control session", accessory.name, accessory.serialNumber);
        [self sdl_closeSessions];
    } else {
        SDLLogV(@"Accessory (%@, %@) disconnecting during an unknown session", accessory.name, accessory.serialNumber);
        [self sdl_closeSessions];
    }
}

/**
 *  Closes and cleans up the sessions after a control session has been closed. Since a data session has not been established, the lifecycle manager has not transitioned to state started. Do not unregister for notifications from accessory connections/disconnections otherwise the library will not be able to connect to an accessory again.
 */
- (void)sdl_closeSessions {
    self.retryCounter = 0;
    self.sessionSetupInProgress = NO;

    [self sdl_closeSessionsWithCompletionHandler:nil];
}

/**
 *  Tells the lifecycle manager that the data session has been closed. The lifecycle manager will destroy it's `SDLIAPTransport` object and then create a new one to listen for a new connection to the accessory.
 */
- (void)sdl_destroyTransport {
    self.retryCounter = 0;
    self.sessionSetupInProgress = NO;
    self.transportDestroyed = YES;
    __weak typeof(self) weakSelf = self;
    [self disconnectWithCompletionHandler:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.delegate onTransportDisconnected];
    }];
}

#pragma mark - Stream Lifecycle

#pragma mark SDLTransportTypeProtocol

/**
 *  Sends data to Core
 *
 *  @param data The data to be sent to Core
 */
- (void)sendData:(NSData *)data {
    if (!self.dataSession.sessionInProgress) {
        SDLLogW(@"Attempting to send data to Core but there is no data session in progress");
        return;
    }
    [self.dataSession sendData:data];
}

/**
 *  Attempts to connect to an accessory.
 */
- (void)connect {
    [self sdl_connect:nil];
}

/**
 *  Cleans up after a disconnected accessory by closing any open I/O streams.
 */
- (void)disconnectWithCompletionHandler:(void (^)(void))disconnectCompletionHandler {
    SDLLogD(@"Disconnecting IAP transport");
    // Stop event listening here so that even if the transport is disconnected by `SDLProxy` when there is a start session timeout, the class unregisters for accessory notifications
    [self sdl_stopEventListening];

    self.retryCounter = 0;
    self.sessionSetupInProgress = NO;
    self.transportDestroyed = YES;

    [self sdl_closeSessionsWithCompletionHandler:disconnectCompletionHandler];
}


#pragma mark Helpers

/**
 *  Starts the process to connect to an accessory. If no accessory specified, scans for a valid accessory.
 *
 *  @param accessory The accessory to attempt connection with or nil to scan for accessories.
 */
- (void)sdl_connect:(nullable EAAccessory *)accessory {
    if (self.transportDestroyed) {
        SDLLogV(@"Will not attempt to connect to an accessory because the data session disconnected. Waiting for lifecycle manager to create a new transport object.");
        return;
    }

    if ((self.dataSession == nil || !self.dataSession.isSessionInProgress) && !self.sessionSetupInProgress) {
        // No data session has been established are not attempting to set one up, attempt to connect
        SDLLogV(@"No data session in progress. Starting setup.");
        self.sessionSetupInProgress = YES;
        [self sdl_establishSessionWithAccessory:accessory];
    } else if (self.dataSession.isSessionInProgress) {
        SDLLogW(@"Data session I/O streams already opened. Ignoring attempt to create session.");
    } else {
        SDLLogW(@"Data session I/O streams are currently being opened. Ignoring attempt to create session.");
    }
}

/**
 *  Attempts to establish a session with the passed accessory. If nil is passed the accessory manager is checked for connected SDL enabled accessories.
 *
 *  @param accessory The accessory to try to establish a session with, or nil to scan all connected accessories.
 */
- (void)sdl_establishSessionWithAccessory:(nullable EAAccessory *)accessory {
    SDLLogD(@"Attempting to connect accessory named: %@, with connectionID: %lu", accessory.name, (unsigned long)accessory.connectionID);
    if (self.retryCounter < CreateSessionRetries) {
        self.retryCounter++;

        // If the accessory is not `nil` attempt to create a session with the accessory.
        if (accessory != nil && [self sdl_establishSessionWithConnectedAccessory:accessory]) {
            // Session was created successfully with the accessory
            return;
        }

        // Search through the EAAccessoryManager's connected accessory list for an SDL enabled accessory and attempt to create a session with the accessory.
        BOOL sessionEstablished = [self sdl_establishSessionWithAccessory];
        if (!sessionEstablished) {
            SDLLogV(@"No accessory supporting SDL was found, dismissing setup. Available connected accessories: %@", EAAccessoryManager.sharedAccessoryManager.connectedAccessories);
            self.sessionSetupInProgress = NO;
        }
    } else {
        // We have surpassed the number of retries allowed
        SDLLogW(@"Surpassed allowed retry attempts (%d), dismissing setup", CreateSessionRetries);
        self.sessionSetupInProgress = NO;
    }
}

/**
 *  Stops any ongoing sessions if necessary and tries to find an accessory which which to create a session.
 */
- (void)sdl_retryEstablishSession {
    // Current strategy disallows automatic retries.
    self.sessionSetupInProgress = NO;

    __weak typeof(self) weakSelf = self;
    [self sdl_closeSessionsWithCompletionHandler:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        // Search connected accessories
        [strongSelf sdl_connect:nil];
    }];
}

/// Helper method for closing both the data and control sessions.
/// @param disconnectCompletionHandler Handler called when both the data and control sessions have been disconnected successfully
- (void)sdl_closeSessionsWithCompletionHandler:(nullable void (^)(void))disconnectCompletionHandler {
    dispatch_group_t endSessionsTask = dispatch_group_create();
    dispatch_group_enter(endSessionsTask);

    if (self.controlSession != nil) {
        dispatch_group_enter(endSessionsTask);
        [self.controlSession destroySessionWithCompletionHandler:^{
            SDLLogV(@"Control session destroyed");
            dispatch_group_leave(endSessionsTask);
        }];
    }

    if (self.dataSession != nil) {
        dispatch_group_enter(endSessionsTask);
        [self.dataSession destroySessionWithCompletionHandler:^{
            SDLLogV(@"Data session destroyed");
            dispatch_group_leave(endSessionsTask);
        }];
    }

    dispatch_group_leave(endSessionsTask);

    // This will always run after all `leave` calls
    dispatch_group_notify(endSessionsTask, [SDLGlobals sharedGlobals].sdlProcessingQueue, ^{
        SDLLogV(@"Both the data and control sessions are closed");
        if (disconnectCompletionHandler != nil) {
            disconnectCompletionHandler();
        }
    });
}


#pragma mark - Session Delegates

#pragma mark Control Session

/**
 *  Called when the control session should be retried.
 */
- (void)controlSessionShouldRetry {
    SDLLogV(@"Retrying the control session");
    [self sdl_retryEstablishSession];
}

/**
 *  Called when the control session got the protocol string successfully and the data session can be opened with the protocol string.
 *
 *  @param controlSession   The control session
 *  @param protocolString   The protocol string to be used to open the data session
 */
- (void)controlSession:(nonnull SDLIAPControlSession *)controlSession didReceiveProtocolString:(nonnull NSString *)protocolString {
    SDLLogD(@"Control transport session received data session number: %@", protocolString);
    self.dataSession = [[SDLIAPDataSession alloc] initWithAccessory:controlSession.accessory delegate:self forProtocol:protocolString];
    [self.dataSession startSession];
}


#pragma mark Data Session

/**
 *  Called when the data session receives data from Core
 *
 *  @param data The received data
 */
- (void)dataSessionDidReceiveData:(nonnull NSData *)data {
    [self.delegate onDataReceived:data];
}

/**
 *  Called when the data session should be retried.
 */
- (void)dataSessionShouldRetry {
    SDLLogV(@"Retrying the data session");
    [self sdl_retryEstablishSession];
}

/**
 *  Called when the data session has been established. Notify the delegate that the transport has been connected.
 */
- (void)dataSessionDidConnect {
    self.sessionSetupInProgress = NO;
    [self.delegate onTransportConnected];
}


#pragma mark - Helpers

#pragma mark Protocol Strings

/**
 *  Checks if the app's info.plist contains all the required protocol strings.
 *
 *  @return True if the app's info.plist has all required protocol strings; false if not.
 */
+ (BOOL)sdl_plistContainsAllSupportedProtocolStrings {
    if ([self.class sdl_supportsRequiredProtocolStrings] != nil) {
        NSString *failedString = [self.class sdl_supportsRequiredProtocolStrings];
        SDLLogE(@"A required External Accessory protocol string is missing from the info.plist: %@", failedString);
        NSAssert(NO, @"Some SDL protocol strings are not supported, check the README for all strings that must be included in your info.plist file. Missing string: %@", failedString);
        return NO;
    }
    return YES;
}

/**
 *  Compares all required protocol strings against the protocol strings in the info.plist dictionary.
 *
 *  @return A missing protocol string or nil if all strings are supported.
 */
+ (nullable NSString *)sdl_supportsRequiredProtocolStrings {
    NSArray<NSString *> *protocolStrings = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"UISupportedExternalAccessoryProtocols"];

    if (![protocolStrings containsObject:MultiSessionProtocolString]) {
        return MultiSessionProtocolString;
    }

    if (![protocolStrings containsObject:LegacyProtocolString]) {
        return LegacyProtocolString;
    }

    for (int i = 0; i < 30; i++) {
        NSString *indexedProtocolString = [NSString stringWithFormat:@"%@%i", IndexedProtocolStringPrefix, i];
        if (![protocolStrings containsObject:indexedProtocolString]) {
            return indexedProtocolString;
        }
    }

    return nil;
}

#pragma mark Retry Delay

/**
 *  Generates a random number of seconds between 1.5 and 9.5 used to delay the retry control and data session attempts.
 *
 *  @return A random number of seconds.
 */
- (double)sdl_retryDelay {
    const double MinRetrySeconds = 1.5;
    const double MaxRetrySeconds = 9.5;
    double RetryRangeSeconds = MaxRetrySeconds - MinRetrySeconds;

    static double appDelaySeconds = 0;

    // HAX: This pull the app name and hashes it in an attempt to provide a more even distribution of retry delays. The evidence that this does so is anecdotal. A more ideal solution would be to use a list of known, installed SDL apps on the phone to try and deterministically generate an even delay.
    if (appDelaySeconds == 0) {
        NSString *appName = [[NSProcessInfo processInfo] processName];
        if (appName == nil) {
            appName = @"noname";
        }

        // Run the app name through an md5 hasher
        const char *ptr = [appName UTF8String];
        unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
        CC_MD5(ptr, (unsigned int)strlen(ptr), md5Buffer);

        // Generate a string of the hex hash
        NSMutableString *output = [NSMutableString stringWithString:@"0x"];
        for (int i = 0; i < 8; i++) {
            [output appendFormat:@"%02X", md5Buffer[i]];
        }

        // Transform the string into a number between 0 and 1
        unsigned long long firstHalf;
        NSScanner *pScanner = [NSScanner scannerWithString:output];
        [pScanner scanHexLongLong:&firstHalf];
        double hashBasedValueInRange0to1 = ((double)firstHalf) / 0xffffffffffffffff;

        // Transform the number into a number between min and max
        appDelaySeconds = ((RetryRangeSeconds * hashBasedValueInRange0to1) + MinRetrySeconds);
    }

    return appDelaySeconds;
}

#pragma mark Create Sessions

/**
 *  List of protocol strings supported by SDL enabled head units. Newer head units use the multisession protocol string which allows multiple apps to connect over 1 protocol string. Legacy head units use the control or legacy protocol string which only allows 1 app to connect over 1 protocol string.
 *
 *  @return A list of SDL accessory supported protocol strings ordered from most recently supported to least preferred.
 */
+ (NSArray<NSString *> *)protocolStrings {
    // Order of the protocol strings is important!!
    return @[MultiSessionProtocolString, ControlProtocolString, LegacyProtocolString];
}

/**
 *  Attempts to create a session with a connected accessory.
 *
 *  @param connectedAccessory  The connected accessory
 *  @return                    True if a session was started with the connected accessory, false if not
 */
- (BOOL)sdl_establishSessionWithConnectedAccessory:(EAAccessory *)connectedAccessory {
    for (NSString *protocolString in [self.class protocolStrings]) {
        if (![connectedAccessory supportsProtocol:protocolString]) {
            continue;
        }

        BOOL connecting = [self createSessionWithAccessory:connectedAccessory protocolString:protocolString];
        if (connecting) {
            return connecting;
        }
    }

    return NO;
}

/**
 *  Searches through the EAAccessoryManager's list of connected accessories for an SDL enabled accessory. If an accessory is found a session is attempted with the accessory.
 *
 *  @return True if a session was started with the connected accessory, false if no session could be created or if no SDL enabled accessory was found.
 */
- (BOOL)sdl_establishSessionWithAccessory {
    for (NSString *protocolString in [self.class protocolStrings]) {
        EAAccessory *sdlAccessory = [EAAccessoryManager findAccessoryForProtocol:protocolString];
        if (sdlAccessory == nil) {
            continue;
        }

        BOOL connecting = [self createSessionWithAccessory:sdlAccessory protocolString:protocolString];
        if (connecting) {
            return connecting;
        }
    }

    return NO;
}

/**
 *  Creates a session with a passed accessory and protocol string. If the accessory supports the multisession protocol string, a data session can be created right away with the accessory. If the accessory does not support the multisession protocol string, but does support the control protocol string, two sessions must be created. First, a control session is created to get the new protocol string needed to create a data session with the accessory. Then, the control session is destroyed and the data session created with the new protocol string.
 *
 *  @param accessory       The connected accessory
 *  @param protocolString  The unique protocol string used to create the session with the accessory
 *  @return                True if a session was started with the connected accessory, false if no session could be created or if no SDL enabled accessory was found.
 */
- (BOOL)createSessionWithAccessory:(EAAccessory *)accessory protocolString:(NSString *)protocolString {
    if (![self.class sdl_plistContainsAllSupportedProtocolStrings]) {
        return NO;
    }

    if ([protocolString isEqualToString:MultiSessionProtocolString] && SDL_SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9")) {
        self.dataSession = [[SDLIAPDataSession alloc] initWithAccessory:accessory delegate:self forProtocol:protocolString];
        [self.dataSession startSession];
        return YES;
    } else if ([protocolString isEqualToString:ControlProtocolString]) {
        self.controlSession = [[SDLIAPControlSession alloc] initWithAccessory:accessory delegate:self];
        [self.controlSession startSession];
        return YES;
    } else if ([protocolString isEqualToString:LegacyProtocolString]) {
        self.dataSession = [[SDLIAPDataSession alloc] initWithAccessory:accessory delegate:self forProtocol:protocolString];
        [self.dataSession startSession];
        return YES;
    }

    return NO;
}

@end

NS_ASSUME_NONNULL_END
