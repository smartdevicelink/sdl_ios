//  SDLIAPTransport.h
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "EAAccessoryManager+SDLProtocols.h"
#import "SDLLogMacros.h"
#import "SDLGlobals.h"
#import "SDLIAPSession.h"
#import "SDLIAPTransport.h"
#import "SDLIAPTransport.h"
#import "SDLStreamDelegate.h"
#import "SDLTimer.h"
#import <CommonCrypto/CommonDigest.h>

NS_ASSUME_NONNULL_BEGIN

NSString *const legacyProtocolString = @"com.ford.sync.prot0";
NSString *const controlProtocolString = @"com.smartdevicelink.prot0";
NSString *const indexedProtocolStringPrefix = @"com.smartdevicelink.prot";

int const createSessionRetries = 1;
int const protocolIndexTimeoutSeconds = 20;
int const streamOpenTimeoutSeconds = 2;


@interface SDLIAPTransport () {
    dispatch_queue_t _transmit_queue;
}

@property (assign, nonatomic) int retryCounter;
@property (assign, nonatomic) BOOL sessionSetupInProgress;
@property (nullable, strong, nonatomic) SDLTimer *protocolIndexTimer;

@end


@implementation SDLIAPTransport

- (instancetype)init {
    if (self = [super init]) {
        _retryCounter = 0;
        _sessionSetupInProgress = NO;
        _transmit_queue = dispatch_queue_create("com.sdl.transport.iap.transmit", DISPATCH_QUEUE_SERIAL);

        [self sdl_startEventListening];
    }

    SDLLogV(@"SDLIAPTransport Init");

    return self;
}


- (void)dealloc {
    [self disconnect];
    [self sdl_stopEventListening];
    SDLLogD(@"SDLIAPTransport Dealloc");
}

#pragma mark - Notification Subscriptions

- (void)sdl_startEventListening {
    SDLLogV(@"SDLIAPTransport Listening For Events");
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
}

- (void)sdl_stopEventListening {
    SDLLogV(@"SDLIAPTransport Stopped Listening For Events");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - EAAccessory Notifications

- (void)sdl_accessoryConnected:(NSNotification *)notification {
    SDLLogD(@"Accessory Connected (%@), Opening in %0.03fs", notification.userInfo[EAAccessoryKey], self.retryDelay);

    self.retryCounter = 0;
    [self performSelector:@selector(connect) withObject:nil afterDelay:self.retryDelay];
}

- (void)sdl_accessoryDisconnected:(NSNotification *)notification {
    // Only check for the data session, the control session is handled separately
    EAAccessory *accessory = notification.userInfo[EAAccessoryKey];
    SDLLogD(@"Accessory Disconnected Event (%@)", accessory);
    if (accessory.connectionID == self.session.accessory.connectionID) {
        self.sessionSetupInProgress = NO;
        [self disconnect];
        [self.delegate onTransportDisconnected];
    }
}

- (void)sdl_applicationWillEnterForeground:(NSNotification *)notification {
    SDLLogV(@"App foregrounded, attempting connection");
    self.retryCounter = 0;
    [self connect];
}


#pragma mark - Stream Lifecycle

- (void)connect {
    if (!self.session && !self.sessionSetupInProgress) {
        // We don't have a session are not attempting to set one up, attempt to connect
        SDLLogV(@"Session not setup, starting setup");
        self.sessionSetupInProgress = YES;
        [self sdl_establishSession];
    } else if (self.session) {
        // Session already established
        SDLLogV(@"Session already established");
    } else {
        // Session attempting to be established
        SDLLogV(@"Session setup already in progress");
    }
}

- (void)disconnect {
    SDLLogD(@"IAP disconnecting data session");

    // Only disconnect the data session, the control session does not stay open and is handled separately
    if (self.session != nil) {
        [self.session stop];
        self.session = nil;
    }
}


#pragma mark - Creating Session Streams

- (void)sdl_establishSession {
    SDLLogD(@"Attempting to connect");
    if (self.retryCounter < createSessionRetries) {
        // We should be attempting to connect
        self.retryCounter++;
        EAAccessory *accessory = nil;

        // Determine if we can start a multi-app session or a legacy (single-app) session
        if ((accessory = [EAAccessoryManager findAccessoryForProtocol:controlProtocolString])) {
            [self sdl_createIAPControlSessionWithAccessory:accessory];
        } else if ((accessory = [EAAccessoryManager findAccessoryForProtocol:legacyProtocolString])) {
            [self sdl_createIAPDataSessionWithAccessory:accessory forProtocol:legacyProtocolString];
        } else {
            // No compatible accessory
            SDLLogV(@"No accessory supporting SDL was found, dismissing setup");
            self.sessionSetupInProgress = NO;
        }
    } else {
        // We are beyond the number of retries allowed
        SDLLogW(@"Surpassed allowed retry attempts");
        self.sessionSetupInProgress = NO;
    }
}

- (void)sdl_createIAPControlSessionWithAccessory:(EAAccessory *)accessory {
    SDLLogD(@"Starting IAP control session (%@)", accessory);
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

            SDLLogW(@"Control session timeout");
            [strongSelf.controlSession stop];
            strongSelf.controlSession.streamDelegate = nil;
            strongSelf.controlSession = nil;
            [strongSelf sdl_retryEstablishSession];
        };
        self.protocolIndexTimer.elapsedBlock = elapsedBlock;

        SDLStreamDelegate *controlStreamDelegate = [SDLStreamDelegate new];
        self.controlSession.streamDelegate = controlStreamDelegate;
        controlStreamDelegate.streamHasBytesHandler = [self sdl_controlStreamHasBytesHandlerForAccessory:accessory];
        controlStreamDelegate.streamEndHandler = [self sdl_controlStreamEndedHandler];
        controlStreamDelegate.streamErrorHandler = [self sdl_controlStreamErroredHandler];

        if (![self.controlSession start]) {
            SDLLogW(@"Control session failed to setup (%@)", accessory);
            self.controlSession.streamDelegate = nil;
            self.controlSession = nil;
            [self sdl_retryEstablishSession];
        }
    } else {
        SDLLogW(@"Failed to setup control session (%@)", accessory);
        [self sdl_retryEstablishSession];
    }
}

- (void)sdl_createIAPDataSessionWithAccessory:(EAAccessory *)accessory forProtocol:(NSString *)protocol {
    SDLLogD(@"Starting data session (%@:%@)", protocol, accessory);
    self.session = [[SDLIAPSession alloc] initWithAccessory:accessory forProtocol:protocol];
    if (self.session) {
        self.session.delegate = self;

        SDLStreamDelegate *ioStreamDelegate = [[SDLStreamDelegate alloc] init];
        self.session.streamDelegate = ioStreamDelegate;
        ioStreamDelegate.streamHasBytesHandler = [self sdl_dataStreamHasBytesHandler];
        ioStreamDelegate.streamEndHandler = [self sdl_dataStreamEndedHandler];
        ioStreamDelegate.streamErrorHandler = [self sdl_dataStreamErroredHandler];

        if (![self.session start]) {
            SDLLogW(@"Data session failed to setup (%@)", accessory);
            self.session.streamDelegate = nil;
            self.session = nil;
            [self sdl_retryEstablishSession];
        }
    } else {
        SDLLogW(@"Failed to setup data session (%@)", accessory);
        [self sdl_retryEstablishSession];
    }
}

- (void)sdl_retryEstablishSession {
    // Current strategy disallows automatic retries.
    self.sessionSetupInProgress = NO;
}

// This gets called after both I/O streams of the session have opened.
- (void)onSessionInitializationCompleteForSession:(SDLIAPSession *)session {
    // Control Session Opened
    if ([controlProtocolString isEqualToString:session.protocol]) {
        SDLLogD(@"Control Session Established");
        [self.protocolIndexTimer start];
    }

    // Data Session Opened
    if (![controlProtocolString isEqualToString:session.protocol]) {
        self.sessionSetupInProgress = NO;
        SDLLogD(@"Data Session Established");
        [self.delegate onTransportConnected];
    }
}


#pragma mark - Session End

// Retry establishSession on Stream End events only if it was the control session and we haven't already connected on non-control protocol
- (void)onSessionStreamsEnded:(SDLIAPSession *)session {
    SDLLogV(@"Session streams ended (%@)", session.protocol);
    if (!self.session && [controlProtocolString isEqualToString:session.protocol]) {
        [session stop];
        [self sdl_retryEstablishSession];
    }
}


#pragma mark - Data Transmission

- (void)sendData:(NSData *)data {
    dispatch_async(_transmit_queue, ^{
        NSOutputStream *ostream = self.session.easession.outputStream;
        NSMutableData *remainder = data.mutableCopy;

        while (ostream.streamStatus == NSStreamStatusOpen && remainder.length != 0) {
            if (ostream.hasSpaceAvailable){
                NSInteger bytesWritten = [ostream write:remainder.bytes maxLength:remainder.length];

                if (bytesWritten == -1) {
                    SDLLogE(@"Error writing bytes: %@", [ostream streamError]);
                    break;
                }

                [remainder replaceBytesInRange:NSMakeRange(0, bytesWritten) withBytes:NULL length:0];
            }
        }
    });
}


#pragma mark - Stream Handlers
#pragma mark Control Stream

- (SDLStreamEndHandler)sdl_controlStreamEndedHandler {
    __weak typeof(self) weakSelf = self;

    return ^(NSStream *stream) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        SDLLogD(@"Control stream ended");

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
        SDLLogV(@"Control stream received data");

        // Read in the stream a single byte at a time
        uint8_t buf[1];
        NSUInteger len = [istream read:buf maxLength:1];
        if (len > 0) {
            NSString *indexedProtocolString = [NSString stringWithFormat:@"%@%@", indexedProtocolStringPrefix, @(buf[0])];
            SDLLogD(@"Control Stream will switch to protocol %@", indexedProtocolString);

            // Destroy the control session
            [strongSelf.protocolIndexTimer cancel];
            [strongSelf.controlSession stop];
            strongSelf.controlSession.streamDelegate = nil;
            strongSelf.controlSession = nil;

            // Determine protocol string of the data session, then create that data session
            dispatch_sync(dispatch_get_main_queue(), ^{
                [strongSelf sdl_createIAPDataSessionWithAccessory:accessory forProtocol:indexedProtocolString];
            });
        }
    };
}

- (SDLStreamErrorHandler)sdl_controlStreamErroredHandler {
    __weak typeof(self) weakSelf = self;

    return ^(NSStream *stream) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        SDLLogE(@"Control stream error");

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
        SDLLogD(@"Data stream ended");

        [strongSelf.session stop];
        strongSelf.session.streamDelegate = nil;

        if (![legacyProtocolString isEqualToString:strongSelf.session.protocol]) {
            [strongSelf sdl_retryEstablishSession];
        }

        strongSelf.session = nil;
    };
}

- (SDLStreamHasBytesHandler)sdl_dataStreamHasBytesHandler {
    __weak typeof(self) weakSelf = self;

    return ^(NSInputStream *istream) {
        __strong typeof(weakSelf) strongSelf = weakSelf;

        uint8_t buf[[SDLGlobals sharedGlobals].maxMTUSize];
        while ([istream hasBytesAvailable]) {
            NSInteger bytesRead = [istream read:buf maxLength:[SDLGlobals sharedGlobals].maxMTUSize];
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
        SDLLogE(@"Data stream error");

        [strongSelf.session stop];
        strongSelf.session.streamDelegate = nil;

        if (![legacyProtocolString isEqualToString:strongSelf.session.protocol]) {
            [strongSelf sdl_retryEstablishSession];
        }

        strongSelf.session = nil;
    };
}

- (double)retryDelay {
    const double min_value = 0.0;
    const double max_value = 10.0;
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

@end

NS_ASSUME_NONNULL_END
