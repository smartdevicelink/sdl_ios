//  SDLIAPTransport.h
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "EAAccessory+SDLProtocols.h"
#import "EAAccessoryManager+SDLProtocols.h"
#import "SDLDebugTool.h"
#import "SDLGlobals.h"
#import "SDLIAPSession.h"
#import "SDLIAPTransport.h"
#import "SDLSiphonServer.h"
#import "SDLStreamDelegate.h"
#import "SDLTimer.h"
#import <CommonCrypto/CommonDigest.h>


NSString *const legacyProtocolString = @"com.ford.sync.prot0";
NSString *const controlProtocolString = @"com.smartdevicelink.prot0";
NSString *const indexedProtocolStringPrefix = @"com.smartdevicelink.prot";
NSString *const multiSessionProtocolString = @"com.smartdevicelink.multisession";
NSString *const backgroundTaskName = @"com.sdl.transport.iap.backgroundTask";

int const createSessionRetries = 3;
int const protocolIndexTimeoutSeconds = 10;
int const streamOpenTimeoutSeconds = 2;


@interface SDLIAPTransport () {
    BOOL _alreadyDestructed;
}

@property (assign) int retryCounter;
@property (strong) SDLTimer *protocolIndexTimer;
@property (nonatomic, assign) UIBackgroundTaskIdentifier backgroundTaskId;
@property (nonatomic, assign) BOOL sessionSetupInProgress;

@end


@implementation SDLIAPTransport

- (instancetype)init {
    if (self = [super init]) {
        _alreadyDestructed = NO;
        _sessionSetupInProgress = NO;
        _session = nil;
        _controlSession = nil;
        _retryCounter = 0;
        _protocolIndexTimer = nil;
        
        [self sdl_startEventListening];
        [SDLSiphonServer init];
    }
    
    [SDLDebugTool logInfo:@"SDLIAPTransport Init"];
    
    return self;
}

/**
 *  Starts a background task that allows the app to search for accessories and while the app is in the background.
 */
- (void)sdl_backgroundTaskStart {
    if (self.backgroundTaskId != UIBackgroundTaskInvalid) {
        return;
    }
    
    self.backgroundTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithName:backgroundTaskName expirationHandler:^{
        [self sdl_backgroundTaskEnd];
    }];
}

/**
 *  Cleans up a background task when it is stopped.
 */
- (void)sdl_backgroundTaskEnd {
    if (self.backgroundTaskId == UIBackgroundTaskInvalid) {
        return;
    }
    
    [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTaskId];
    self.backgroundTaskId = UIBackgroundTaskInvalid;
}

#pragma mark - Notifications

#pragma mark Subscription

/**
 *  Registers for system notifications about connected accessories and the app life cycle.
 */

- (void)sdl_startEventListening {
    [SDLDebugTool logInfo:@"SDLIAPTransport Listening For Events"];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(sdl_accessoryConnected:)
                                                 name:EAAccessoryDidConnectNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(sdl_accessoryDisconnected:)
                                                 name:EAAccessoryDidDisconnectNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(sdl_applicationWillEnterForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(sdl_applicationDidEnterBackground:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
    [[EAAccessoryManager sharedAccessoryManager] registerForLocalNotifications];
}

/**
 *  Unsubscribes to notifications.
 */
- (void)sdl_stopEventListening {
    [SDLDebugTool logInfo:@"SDLIAPTransport Stopped Listening For Events"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark EAAccessory Notifications

/**
 *  Handles a notification sent by the system when a new accessory has been detected by attempting to connect to the new accessory.
 *
 *  @param notification Contains information about the connected accessory
 */
- (void)sdl_accessoryConnected:(NSNotification *)notification {
    EAAccessory *accessory = notification.userInfo[EAAccessoryKey];
    double retryDelay = self.retryDelay;
    NSMutableString *logMessage = [NSMutableString stringWithFormat:@"Accessory Connected, Opening in %0.03fs", self.retryDelay];
    [SDLDebugTool logInfo:logMessage withType:SDLDebugType_Transport_iAP toOutput:SDLDebugOutput_All toGroup:self.debugConsoleGroupName];
    
    if ([[UIApplication sharedApplication] applicationState] != UIApplicationStateActive) {
        [SDLDebugTool logInfo:@"Accessory connected while app is in background. Starting background task." withType:SDLDebugType_Transport_iAP toOutput:SDLDebugOutput_All toGroup:self.debugConsoleGroupName];
        [self sdl_backgroundTaskStart];
    }
    
    [self performSelector:@selector(sdl_connect:) withObject:accessory afterDelay:retryDelay];
}

/**
 *  Handles a notification sent by the system when an accessory has been disconnected by cleaning up after the disconnected device. Only check for the data session, the control session is handled separately
 *
 *  @param notification Contains information about the connected accessory
 */
- (void)sdl_accessoryDisconnected:(NSNotification *)notification {
    [SDLDebugTool logInfo:@"Accessory Disconnected Event" withType:SDLDebugType_Transport_iAP toOutput:SDLDebugOutput_All toGroup:self.debugConsoleGroupName];
    
    EAAccessory *accessory = [notification.userInfo objectForKey:EAAccessoryKey];
    if (accessory.connectionID != self.session.accessory.connectionID) {
        // Disconnected during a control session
        self.retryCounter = 0;
        [SDLDebugTool logInfo:@"Accessory connection ID mismatch!!!" withType:SDLDebugType_Transport_iAP toOutput:SDLDebugOutput_All toGroup:self.debugConsoleGroupName];
    }
    if ([accessory.serialNumber isEqualToString:self.session.accessory.serialNumber]) {
        // Disconnected during a data session
        self.retryCounter = 0;
        self.sessionSetupInProgress = NO;
        [self disconnect];
        [self.delegate onTransportDisconnected];
    }
}

#pragma mark App Lifecycle Notifications

/**
 *  Handles a notification sent by the system when the app enters the foreground.
 *
 *  If the app is still searching for an accessory, a background task will be started so the app can still search for and/or connect with an accessory while it is in the background.
 *
 *  @param notification Notification
 */
- (void)sdl_applicationWillEnterForeground:(NSNotification *)notification {
    [SDLDebugTool logInfo:@"App Foregrounded Event" withType:SDLDebugType_Transport_iAP toOutput:SDLDebugOutput_All toGroup:self.debugConsoleGroupName];
    [self sdl_backgroundTaskEnd];
    [self connect];
}

/**
 *  Handles a notification sent by the system when the app enters the background.
 *
 *  @param notification Notification
 */
- (void)sdl_applicationDidEnterBackground:(NSNotification *)notification {
    [SDLDebugTool logInfo:@"App backgrounded, starting background task" withType:SDLDebugType_Transport_iAP toOutput:SDLDebugOutput_All toGroup:self.debugConsoleGroupName];
    [self sdl_backgroundTaskStart];
}

#pragma mark - Stream Lifecycle

- (void)connect {
    [self sdl_connect:nil];
}

/**
 *  Starts the process to connect to an accessory. If no accessory specified, scans for a valid accessory.
 *
 *  @param accessory The accessory to attempt connection with or nil to scan for accessories.
 */
- (void)sdl_connect:(EAAccessory *)accessory {
    if (!self.session && !self.sessionSetupInProgress) {
        self.sessionSetupInProgress = YES;
        [self sdl_establishSessionWithAccessory:accessory];
    } else if (self.session) {
        [SDLDebugTool logInfo:@"Session already established."];
    } else {
        [SDLDebugTool logInfo:@"Session setup already in progress."];
    }
}

/**
 *  Cleans up after a disconnected accessory by closing any open input streams.
 */
- (void)disconnect {
    [SDLDebugTool logInfo:@"IAP Disconnecting" withType:SDLDebugType_Transport_iAP toOutput:SDLDebugOutput_All toGroup:self.debugConsoleGroupName];
    // Stop event listening here so that even if the transport is disconnected by the proxy we unregister for accessory local notifications
    [self sdl_stopEventListening];
    if (self.controlSession != nil) {
        [self.controlSession stop];
        self.controlSession.streamDelegate = nil;
        self.controlSession = nil;
    } else if (self.session != nil) {
        [self.session stop];
        self.session.streamDelegate = nil;
        self.session = nil;
    }
}


#pragma mark - Creating Session Streams

- (BOOL)sdl_connectAccessory:(EAAccessory *)accessory {
    BOOL connecting = NO;

    if ([self.class sdl_supportsRequiredProtocolStrings] != nil) {
        NSString *failedString = [self.class sdl_supportsRequiredProtocolStrings];
        NSAssert(NO, @"Some SDL protocol strings are not supported, check the README for all strings that must be included in your info.plist file. Missing string: %@", failedString);
        return connecting;
    }

    if ([accessory supportsProtocol:multiSessionProtocolString] && SDL_SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9")) {
        [self sdl_createIAPDataSessionWithAccessory:accessory forProtocol:multiSessionProtocolString];
        connecting = YES;
    } else if ([accessory supportsProtocol:controlProtocolString]) {
        [self sdl_createIAPControlSessionWithAccessory:accessory];
        connecting = YES;
    } else if ([accessory supportsProtocol:legacyProtocolString]) {
        [self sdl_createIAPDataSessionWithAccessory:accessory forProtocol:legacyProtocolString];
        connecting = YES;
    }
    
    return connecting;
}

/**
 Check all required protocol strings in the info.plist dictionary.

 @return A missing protocol string or nil if all strings are supported.
 */
+ (nullable NSString *)sdl_supportsRequiredProtocolStrings {
    NSArray<NSString *> *protocolStrings = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"UISupportedExternalAccessoryProtocols"];

    if (![protocolStrings containsObject:multiSessionProtocolString]) {
        return multiSessionProtocolString;
    }

    if (![protocolStrings containsObject:legacyProtocolString]) {
        return legacyProtocolString;
    }

    for (int i = 0; i < 30; i++) {
        NSString *indexedProtocolString = [NSString stringWithFormat:@"%@%i", indexedProtocolStringPrefix, i];
        if (![protocolStrings containsObject:indexedProtocolString]) {
            return indexedProtocolString;
        }
    }

    return nil;
}

- (void)sdl_establishSessionWithAccessory:(EAAccessory *)accessory {
    [SDLDebugTool logInfo:@"Attempting To Connect"];
    if (self.retryCounter < createSessionRetries) {
        // We should be attempting to connect
        self.retryCounter++;
        EAAccessory *sdlAccessory = accessory;
        // If we are being called from sdl_connectAccessory, the EAAccessoryDidConnectNotification will contain the SDL accessory to connect to and we can connect without searching the accessory manager's connected accessory list. Otherwise, we fall through to a search.
        if (sdlAccessory != nil && [self sdl_connectAccessory:sdlAccessory]) {
            // Connection underway, exit
            return;
        }

        if ([self.class sdl_supportsRequiredProtocolStrings] != nil) {
            NSString *failedString = [self.class sdl_supportsRequiredProtocolStrings];
            NSAssert(NO, @"Some SDL protocol strings are not supported, check the README for all strings that must be included in your info.plist file. Missing string: %@", failedString);
            return;
        }

        // Determine if we can start a multi-app session or a legacy (single-app) session
        if ((sdlAccessory = [EAAccessoryManager findAccessoryForProtocol:multiSessionProtocolString]) && SDL_SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9")) {
            [self sdl_createIAPDataSessionWithAccessory:sdlAccessory forProtocol:multiSessionProtocolString];
        } else if ((sdlAccessory = [EAAccessoryManager findAccessoryForProtocol:controlProtocolString])) {
            [self sdl_createIAPControlSessionWithAccessory:sdlAccessory];
        } else if ((sdlAccessory = [EAAccessoryManager findAccessoryForProtocol:legacyProtocolString])) {
            [self sdl_createIAPDataSessionWithAccessory:sdlAccessory forProtocol:legacyProtocolString];
        } else {
            // No compatible accessory
            [SDLDebugTool logInfo:@"No accessory supporting a required sync protocol was found."];
            self.sessionSetupInProgress = NO;
        }
    } else {
        // We are beyond the number of retries allowed
        [SDLDebugTool logInfo:@"Create session retries exhausted."];
        self.sessionSetupInProgress = NO;
    }
}

- (void)sdl_createIAPControlSessionWithAccessory:(EAAccessory *)accessory {
    [SDLDebugTool logInfo:@"Starting MultiApp Session"];
    self.controlSession = [[SDLIAPSession alloc] initWithAccessory:accessory forProtocol:controlProtocolString];
    
    if (self.controlSession) {
        self.controlSession.delegate = self;
        
        if (self.protocolIndexTimer == nil) {
            self.protocolIndexTimer = [[SDLTimer alloc] initWithDuration:protocolIndexTimeoutSeconds repeat:NO];
        } else {
            [self.protocolIndexTimer cancel];
        }
        
        __weak typeof(self) weakSelf = self;
        void (^elapsedBlock)(void) = ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [SDLDebugTool logInfo:@"Protocol Index Timeout"];
            [strongSelf.controlSession stop];
            strongSelf.controlSession.streamDelegate = nil;
            strongSelf.controlSession = nil;
            [strongSelf sdl_retryEstablishSession];
        };
        self.protocolIndexTimer.elapsedBlock = elapsedBlock;
        
        SDLStreamDelegate *controlStreamDelegate = [[SDLStreamDelegate alloc] init];
        self.controlSession.streamDelegate = controlStreamDelegate;
        controlStreamDelegate.streamHasBytesHandler = [self sdl_controlStreamHasBytesHandlerForAccessory:accessory];
        controlStreamDelegate.streamEndHandler = [self sdl_controlStreamEndedHandler];
        controlStreamDelegate.streamErrorHandler = [self sdl_controlStreamErroredHandler];
        
        if (![self.controlSession start]) {
            [SDLDebugTool logInfo:@"Control Session Failed"];
            self.controlSession.streamDelegate = nil;
            self.controlSession = nil;
            [self sdl_retryEstablishSession];
        }
    } else {
        [SDLDebugTool logInfo:@"Failed MultiApp Control SDLIAPSession Initialization"];
        [self sdl_retryEstablishSession];
    }
}

- (void)sdl_createIAPDataSessionWithAccessory:(EAAccessory *)accessory forProtocol:(NSString *)protocol {
    [SDLDebugTool logInfo:@"Starting Data Session"];
    self.session = [[SDLIAPSession alloc] initWithAccessory:accessory forProtocol:protocol];
    if (self.session) {
        self.session.delegate = self;
        
        SDLStreamDelegate *ioStreamDelegate = [[SDLStreamDelegate alloc] init];
        self.session.streamDelegate = ioStreamDelegate;
        ioStreamDelegate.streamHasBytesHandler = [self sdl_dataStreamHasBytesHandler];
        ioStreamDelegate.streamEndHandler = [self sdl_dataStreamEndedHandler];
        ioStreamDelegate.streamErrorHandler = [self sdl_dataStreamErroredHandler];
        
        if (![self.session start]) {
            [SDLDebugTool logInfo:@"Data Session Failed"];
            self.session.streamDelegate = nil;
            self.session = nil;
            [self sdl_retryEstablishSession];
        }
    } else {
        [SDLDebugTool logInfo:@"Failed MultiApp Data SDLIAPSession Initialization"];
        [self sdl_retryEstablishSession];
    }
}

- (void)sdl_retryEstablishSession {
    // Current strategy disallows automatic retries.
    self.sessionSetupInProgress = NO;
    if (self.session != nil) {
        [self.session stop];
        self.session.delegate = nil;
        self.session = nil;
    }
    // No accessory to use this time, search connected accessories
    [self sdl_connect:nil];
}

// This gets called after both I/O streams of the session have opened.
- (void)onSessionInitializationCompleteForSession:(SDLIAPSession *)session {
    // Control Session Opened
    if ([controlProtocolString isEqualToString:session.protocol]) {
        [SDLDebugTool logInfo:@"Control Session Established"];
        [self.protocolIndexTimer start];
    }
    
    // Data Session Opened
    if (![controlProtocolString isEqualToString:session.protocol]) {
        self.sessionSetupInProgress = NO;
        [SDLDebugTool logInfo:@"Data Session Established"];
        [self.delegate onTransportConnected];
    }
}


#pragma mark - Session End

// Retry establishSession on Stream End events only if it was the control session and we haven't already connected on non-control protocol
- (void)onSessionStreamsEnded:(SDLIAPSession *)session {
    if (!self.session && [controlProtocolString isEqualToString:session.protocol]) {
        [SDLDebugTool logInfo:@"onSessionStreamsEnded"];
        [session stop];
        [self sdl_retryEstablishSession];
    }
}


#pragma mark - Data Transmission

- (void)sendData:(NSData *)data {
    if (self.session == nil || !self.session.accessory.connected) {
        return;
    }
    
    [self.session sendData:data];
}


#pragma mark - Stream Handlers
#pragma mark Control Stream

- (SDLStreamEndHandler)sdl_controlStreamEndedHandler {
    __weak typeof(self) weakSelf = self;
    
    return ^(NSStream *stream) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        [SDLDebugTool logInfo:@"Control Stream Event End"];
        
        // End events come in pairs, only perform this once per set.
        if (strongSelf.controlSession != nil) {
            [strongSelf.protocolIndexTimer cancel];
            [strongSelf.controlSession stop];
            strongSelf.controlSession.streamDelegate = nil;
            strongSelf.controlSession = nil;
            [strongSelf sdl_retryEstablishSession];
        }
    };
}

- (SDLStreamHasBytesHandler)sdl_controlStreamHasBytesHandlerForAccessory:(EAAccessory *)accessory {
    __weak typeof(self) weakSelf = self;
    
    return ^(NSInputStream *istream) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        [SDLDebugTool logInfo:@"Control Stream Received Data"];
        
        // Read in the stream a single byte at a time
        uint8_t buf[1];
        NSUInteger len = [istream read:buf maxLength:1];
        if (len > 0) {
            NSString *logMessage = [NSString stringWithFormat:@"Switching to protocol %@", [@(buf[0]) stringValue]];
            [SDLDebugTool logInfo:logMessage];
            
            // Destroy the control session
            [strongSelf.protocolIndexTimer cancel];
            dispatch_sync(dispatch_get_main_queue(), ^{
                [strongSelf.controlSession stop];
                strongSelf.controlSession.streamDelegate = nil;
                strongSelf.controlSession = nil;
            });
            
            // Determine protocol string of the data session, then create that data session
            NSString *indexedProtocolString = [NSString stringWithFormat:@"%@%@", indexedProtocolStringPrefix, @(buf[0])];
            if (accessory.isConnected) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [strongSelf sdl_createIAPDataSessionWithAccessory:accessory forProtocol:indexedProtocolString];
                });
            }
        }
    };
}

- (SDLStreamErrorHandler)sdl_controlStreamErroredHandler {
    __weak typeof(self) weakSelf = self;
    
    return ^(NSStream *stream) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        [SDLDebugTool logInfo:@"Stream Error"];
        [strongSelf.protocolIndexTimer cancel];
        [strongSelf.controlSession stop];
        strongSelf.controlSession.streamDelegate = nil;
        strongSelf.controlSession = nil;
        [strongSelf sdl_retryEstablishSession];
    };
}


#pragma mark Data Stream

- (SDLStreamEndHandler)sdl_dataStreamEndedHandler {
    __weak typeof(self) weakSelf = self;
    
    return ^(NSStream *stream) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        [SDLDebugTool logInfo:@"Data Stream Event End"];
        if (strongSelf.session != nil) {
            // The handler will be called on the IO thread, but the session stop method must be called on the main thread and we need to wait for the session to stop before nil'ing it out. To do this, we use dispatch_sync() on the main thread.
            dispatch_sync(dispatch_get_main_queue(), ^{
                [strongSelf.session stop];
            });
            strongSelf.session.streamDelegate = nil;
            strongSelf.session = nil;
        }
        
        // We don't call sdl_retryEstablishSession here because the stream end event usually fires when the accessory is disconnected
    };
}

- (SDLStreamHasBytesHandler)sdl_dataStreamHasBytesHandler {
    __weak typeof(self) weakSelf = self;
    
    return ^(NSInputStream *istream) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        uint8_t buf[[[SDLGlobals globals] mtuSizeForServiceType:SDLServiceType_RPC]];
        while (istream.streamStatus == NSStreamStatusOpen && istream.hasBytesAvailable) {
            // It is necessary to check the stream status and whether there are bytes available because the dataStreamHasBytesHandler is executed on the IO thread and the accessory disconnect notification arrives on the main thread, causing data to be passed to the delegate while the main thread is tearing down the transport.
            
            NSInteger bytesRead = [istream read:buf maxLength:[[SDLGlobals globals] mtuSizeForServiceType:SDLServiceType_RPC]];
            NSData *dataIn = [NSData dataWithBytes:buf length:bytesRead];
            
            if (bytesRead > 0) {
                [strongSelf.delegate onDataReceived:dataIn];
            } else {
                break;
            }
        }
    };
}

- (SDLStreamErrorHandler)sdl_dataStreamErroredHandler {
    __weak typeof(self) weakSelf = self;
    
    return ^(NSStream *stream) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        [SDLDebugTool logInfo:@"Data Stream Error"];
        dispatch_sync(dispatch_get_main_queue(), ^{
            [strongSelf.session stop];
        });
        strongSelf.session.streamDelegate = nil;
        strongSelf.session = nil;
        if (![legacyProtocolString isEqualToString:strongSelf.session.protocol]) {
            [strongSelf sdl_retryEstablishSession];
        }
    };
}

- (double)retryDelay {
    const double min_value = 1.5;
    const double max_value = 9.5;
    double range_length = max_value - min_value;
    
    static double delay = 0;
    
    // HAX: This pull the app name and hashes it in an attempt to provide a more even distribution of retry delays. The evidence that this does so is anecdotal. A more ideal solution would be to use a list of known, installed SDL apps on the phone to try and deterministically generate an even delay.
    if (delay == 0) {
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
        delay = ((range_length * hashBasedValueInRange0to1) + min_value);
    }
    
    return delay;
}


#pragma mark - Lifecycle Destruction

- (void)sdl_destructObjects {
    if (!_alreadyDestructed) {
        _alreadyDestructed = YES;
        self.controlSession = nil;
        self.session = nil;
        self.delegate = nil;
        self.sessionSetupInProgress = NO;
    }
}

- (void)dispose {
    [self sdl_destructObjects];
}

- (void)dealloc {
    [self sdl_destructObjects];
    [SDLDebugTool logInfo:@"SDLIAPTransport Dealloc" withType:SDLDebugType_Transport_iAP toOutput:SDLDebugOutput_All toGroup:self.debugConsoleGroupName];
}

@end
