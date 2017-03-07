//  SDLIAPTransport.h
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "EAAccessoryManager+SDLProtocols.h"
#import "SDLDebugTool.h"
#import "SDLGlobals.h"
#import "SDLIAPSession.h"
#import "SDLIAPTransport.h"
#import "SDLIAPTransport.h"
#import "SDLSiphonServer.h"
#import "SDLStreamDelegate.h"
#import "SDLTimer.h"
#import <CommonCrypto/CommonDigest.h>


NSString *const legacyProtocolString = @"com.ford.sync.prot0";
NSString *const controlProtocolString = @"com.smartdevicelink.prot0";
NSString *const indexedProtocolStringPrefix = @"com.smartdevicelink.prot";

int const createSessionRetries = 1;
int const protocolIndexTimeoutSeconds = 20;
int const streamOpenTimeoutSeconds = 2;


@interface SDLIAPTransport () {
    dispatch_queue_t _transmit_queue;
    BOOL _alreadyDestructed;
}

@property (assign) int retryCounter;
@property (assign) BOOL sessionSetupInProgress;
@property (strong) SDLTimer *protocolIndexTimer;

@end


@implementation SDLIAPTransport

- (instancetype)init {
    if (self = [super init]) {
        _alreadyDestructed = NO;
        _session = nil;
        _controlSession = nil;
        _retryCounter = 0;
        _sessionSetupInProgress = NO;
        _protocolIndexTimer = nil;
        _transmit_queue = dispatch_queue_create("com.sdl.transport.iap.transmit", DISPATCH_QUEUE_SERIAL);

        [self sdl_startEventListening];
        [SDLSiphonServer init];
    }

    [SDLDebugTool logInfo:@"SDLIAPTransport Init"];

    return self;
}


#pragma mark - Notification Subscriptions

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
}

- (void)sdl_stopEventListening {
    [SDLDebugTool logInfo:@"SDLIAPTransport Stopped Listening For Events"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - EAAccessory Notifications

- (void)sdl_accessoryConnected:(NSNotification *)notification {
    NSMutableString *logMessage = [NSMutableString stringWithFormat:@"Accessory Connected, Opening in %0.03fs", self.retryDelay];
    [SDLDebugTool logInfo:logMessage withType:SDLDebugType_Transport_iAP toOutput:SDLDebugOutput_All toGroup:self.debugConsoleGroupName];

    self.retryCounter = 0;
    [self performSelector:@selector(connect) withObject:nil afterDelay:self.retryDelay];
}

- (void)sdl_accessoryDisconnected:(NSNotification *)notification {
    [SDLDebugTool logInfo:@"Accessory Disconnected Event" withType:SDLDebugType_Transport_iAP toOutput:SDLDebugOutput_All toGroup:self.debugConsoleGroupName];

    // Only check for the data session, the control session is handled separately
    EAAccessory *accessory = [notification.userInfo objectForKey:EAAccessoryKey];
    if (accessory.connectionID == self.session.accessory.connectionID) {
        self.sessionSetupInProgress = NO;
        [self disconnect];
        [self.delegate onTransportDisconnected];
    }
}

- (void)sdl_applicationWillEnterForeground:(NSNotification *)notification {
    [SDLDebugTool logInfo:@"App Foregrounded Event" withType:SDLDebugType_Transport_iAP toOutput:SDLDebugOutput_All toGroup:self.debugConsoleGroupName];
    self.retryCounter = 0;
    [self connect];
}


#pragma mark - Stream Lifecycle

- (void)connect {
    if (!self.session && !self.sessionSetupInProgress) {
        self.sessionSetupInProgress = YES;
        [self sdl_establishSession];
    } else if (self.session) {
        [SDLDebugTool logInfo:@"Session already established."];
    } else {
        [SDLDebugTool logInfo:@"Session setup already in progress."];
    }
}

- (void)disconnect {
    [SDLDebugTool logInfo:@"IAP Disconnecting" withType:SDLDebugType_Transport_iAP toOutput:SDLDebugOutput_All toGroup:self.debugConsoleGroupName];

    // Only disconnect the data session, the control session does not stay open and is handled separately
    if (self.session != nil) {
        [self.session stop];
        self.session = nil;
    }
}


#pragma mark - Creating Session Streams

- (void)sdl_establishSession {
    [SDLDebugTool logInfo:@"Attempting To Connect"];
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

        SDLStreamDelegate *controlStreamDelegate = [SDLStreamDelegate new];
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
    dispatch_async(_transmit_queue, ^{
        NSOutputStream *ostream = self.session.easession.outputStream;
        NSMutableData *remainder = data.mutableCopy;

        while (ostream.streamStatus == NSStreamStatusOpen && remainder.length != 0) {
            if (ostream.hasSpaceAvailable){
                NSInteger bytesWritten = [ostream write:remainder.bytes maxLength:remainder.length];

                if (bytesWritten == -1) {
                    [SDLDebugTool logInfo:[NSString stringWithFormat:@"Error: %@", [ostream streamError]] withType:SDLDebugType_Transport_iAP toOutput:SDLDebugOutput_All];
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
            [strongSelf.controlSession stop];
            strongSelf.controlSession.streamDelegate = nil;
            strongSelf.controlSession = nil;

            // Determine protocol string of the data session, then create that data session
            NSString *indexedProtocolString = [NSString stringWithFormat:@"%@%@", indexedProtocolStringPrefix, @(buf[0])];
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

        uint8_t buf[[SDLGlobals globals].maxMTUSize];
        while ([istream hasBytesAvailable]) {
            NSInteger bytesRead = [istream read:buf maxLength:[SDLGlobals globals].maxMTUSize];
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


#pragma mark - Lifecycle Destruction

- (void)sdl_destructObjects {
    if (!_alreadyDestructed) {
        _alreadyDestructed = YES;
        [self sdl_stopEventListening];
        self.controlSession = nil;
        self.session = nil;
        self.delegate = nil;
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
