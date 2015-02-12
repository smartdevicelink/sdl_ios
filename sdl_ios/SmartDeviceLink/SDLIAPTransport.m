//  SDLIAPTransport.h
//  SyncProxy
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import "SDLIAPSession.h"
#import "SDLDebugTool.h"
#import "SDLSiphonServer.h"
#import "SDLIAPConfig.h"
#import "SDLIAPTransport.h"
#import "SDLStreamDelegate.h"
#import "EAAccessoryManager+SDLProtocols.h"
#import "SDLTimer.h"
#import <CommonCrypto/CommonDigest.h>

@interface SDLIAPTransport () {
    dispatch_queue_t _transmit_queue;
    BOOL _alreadyDestructed;
}

@property (assign) int retryCounter;
@property (assign) BOOL sessionSetupInProgress;
@property (strong) SDLTimer *protocolIndexTimer;

- (void)startEventListening;
- (void)stopEventListening;

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
        _transmit_queue = dispatch_queue_create("com.smartdevicelink.transport.transmit", DISPATCH_QUEUE_SERIAL);

        [self startEventListening];
        [SDLSiphonServer init];
    }

    [SDLDebugTool logInfo:@"SDLIAPTransport Init"];

    return self;
}

- (void)startEventListening {
    [SDLDebugTool logInfo:@"SDLIAPTransport Listening For Events"];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(accessoryConnected:)
                                                 name:EAAccessoryDidConnectNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(accessoryDisconnected:)
                                                 name:EAAccessoryDidDisconnectNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillEnterForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidEnterBackground:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];

}

- (void)stopEventListening {
    [SDLDebugTool logInfo:@"SDLIAPTransport Stopped Listening For Events"];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:EAAccessoryDidConnectNotification
                                                  object:nil];

    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:EAAccessoryDidDisconnectNotification
                                                  object:nil];

    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidEnterBackgroundNotification
                                                  object:nil];

    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationWillEnterForegroundNotification
                                                  object:nil];

}

#pragma mark - EAAccessory Notifications

- (void)accessoryConnected:(NSNotification*) notification {
    NSMutableString *logMessage = [NSMutableString stringWithFormat:@"Accessory Connected, Opening in %0.03fs", self.retryDelay];
    [SDLDebugTool logInfo:logMessage withType:SDLDebugType_Transport_iAP toOutput:SDLDebugOutput_All toGroup:self.debugConsoleGroupName];

    self.retryCounter = 0;
    [self performSelector:@selector(connect) withObject:nil afterDelay:self.retryDelay];

}

- (void)accessoryDisconnected:(NSNotification*) notification {
    [SDLDebugTool logInfo:@"Accessory Disconnected Event" withType:SDLDebugType_Transport_iAP toOutput:SDLDebugOutput_All toGroup:self.debugConsoleGroupName];

    EAAccessory* accessory = [notification.userInfo objectForKey:EAAccessoryKey];
    if (accessory.connectionID == self.session.accessory.connectionID) {
        self.sessionSetupInProgress = NO;
        [self disconnect];
        [self.delegate onTransportDisconnected];
    }
}

-(void)applicationWillEnterForeground:(NSNotification *)notification {
    [SDLDebugTool logInfo:@"App Foregrounded Event" withType:SDLDebugType_Transport_iAP toOutput:SDLDebugOutput_All toGroup:self.debugConsoleGroupName];
    self.retryCounter = 0;
    [self connect];
}

-(void)applicationDidEnterBackground:(NSNotification *)notification {
    __block UIBackgroundTaskIdentifier taskID;

    taskID = [[UIApplication sharedApplication] beginBackgroundTaskWithName:@"backgroundTaskName" expirationHandler:^{
        [SDLDebugTool logInfo:@"Warning: Background Task Expiring"];
        [[UIApplication sharedApplication] endBackgroundTask:taskID];
    }];

    [SDLDebugTool logInfo:@"App Backgrounded Event" withType:SDLDebugType_Transport_iAP toOutput:SDLDebugOutput_All toGroup:self.debugConsoleGroupName];
}

- (void)connect {
    // Make sure we don't have a session setup or already in progress
    if (!self.session && !self.sessionSetupInProgress) {
        self.sessionSetupInProgress = YES;
        [self establishSession];
    }
    else if (self.session) {
        [SDLDebugTool logInfo:@"Session already established."];
    }
    else {
        [SDLDebugTool logInfo:@"Session setup already in progress."];
    }
}

- (void)establishSession {
    [SDLDebugTool logInfo:@"Attempting To Connect"];
    if (self.retryCounter < CREATE_SESSION_RETRIES) {
        self.retryCounter++;
        EAAccessory *accessory = nil;
        // Multiapp session
        if ((accessory = [EAAccessoryManager findAccessoryForProtocol:CONTROL_PROTOCOL_STRING])) {
            [self createIAPControlSessionWithAccessory:accessory];
        }
        // Legacy session
        else if ((accessory = [EAAccessoryManager findAccessoryForProtocol:LEGACY_PROTOCOL_STRING])) {
            [self createIAPDataSessionWithAccessory:accessory forProtocol:LEGACY_PROTOCOL_STRING];
        }
        // No compatible accessory
        else {
            [SDLDebugTool logInfo:@"No accessory supporting a required sync protocol was found."];
            self.sessionSetupInProgress = NO;
        }
    }
    else if (self.retryCounter == CREATE_SESSION_RETRIES) {
        self.retryCounter++;
        [SDLDebugTool logInfo:@"Create session retries exhausted."];
        self.sessionSetupInProgress = NO;
    }
    else {
        [SDLDebugTool logInfo:@"Session attempts exhausted - Debug remove me"];
    }
}

- (void)createIAPControlSessionWithAccessory:(EAAccessory *)accessory {

    [SDLDebugTool logInfo:@"Starting MultiApp Session"];
    self.controlSession = [[SDLIAPSession alloc] initWithAccessory:accessory forProtocol:CONTROL_PROTOCOL_STRING];
    if (self.controlSession) {
        self.controlSession.delegate = self;

        // Create Protocol Index Timer
        if (self.protocolIndexTimer == nil) {
            self.protocolIndexTimer = [[SDLTimer alloc] initWithDuration:PROTOCOL_INDEX_TIMEOUT_SECONDS];
        }

        __weak typeof(self) weakSelf = self;

        // Protocol index timeout handler
        void (^elapsedBlock)(void) = ^{
            [SDLDebugTool logInfo:@"Protocol Index Timeout"];
            [weakSelf.controlSession stop];
            weakSelf.controlSession.streamDelegate = nil;
            weakSelf.controlSession = nil;
            [weakSelf retryEstablishSession];
        };
        self.protocolIndexTimer.elapsedBlock = elapsedBlock;

        // Configure Streams Delegate
        SDLStreamDelegate *controlStreamDelegate = [SDLStreamDelegate new];
        self.controlSession.streamDelegate = controlStreamDelegate;

        // Control Session Has Bytes Handler
        controlStreamDelegate.streamHasBytesHandler = ^(NSInputStream *istream) {
            [SDLDebugTool logInfo:@"Control Stream Received Data"];

            // Grab a single byte from the stream
            uint8_t buf[1];
            NSUInteger len = [istream read:buf maxLength:1];
            if(len > 0)
            {
                NSString *logMessage = [NSString stringWithFormat:@"Switching to protocol %@", [[NSNumber numberWithChar:buf[0]] stringValue]];
                [SDLDebugTool logInfo:logMessage];
                // Done with control protocol session, destroy it.
                [weakSelf.protocolIndexTimer cancel];
                [weakSelf.controlSession stop];
                weakSelf.controlSession.streamDelegate = nil;
                weakSelf.controlSession = nil;

                // Create session with indexed protocol
                NSString *indexedProtocolString = [NSString stringWithFormat:@"%@%@",
                                                   INDEXED_PROTOCOL_STRING_PREFIX,
                                                   [[NSNumber numberWithChar:buf[0]] stringValue]];


                // Create Data Session
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [weakSelf createIAPDataSessionWithAccessory:accessory forProtocol:indexedProtocolString];
                });

            }
        };

        // Control Session Stream End Handler
        controlStreamDelegate.streamEndHandler = ^(NSStream *stream) {
            [SDLDebugTool logInfo:@"Control Stream Event End"];
            if (weakSelf.controlSession != nil) { // End events come in pairs, only perform this once per set.
                [weakSelf.protocolIndexTimer cancel];
                [weakSelf.controlSession stop];
                weakSelf.controlSession.streamDelegate = nil;
                weakSelf.controlSession = nil;
                [weakSelf retryEstablishSession];
            }
        };

        // Control Session Stream Error Handler
        controlStreamDelegate.streamErrorHandler = ^(NSStream *stream) {
            [SDLDebugTool logInfo:@"Stream Error"];
            [weakSelf.protocolIndexTimer cancel];
            [weakSelf.controlSession stop];
            weakSelf.controlSession.streamDelegate = nil;
            weakSelf.controlSession = nil;
            [weakSelf retryEstablishSession];
        };



        if (![self.controlSession start]) {
            [SDLDebugTool logInfo:@"Control Session Failed"];
            self.controlSession.streamDelegate = nil;
            self.controlSession = nil;
            [self retryEstablishSession];
        }

    } else {
        [SDLDebugTool logInfo:@"Failed MultiApp Control SDLIAPSession Initialization"];
        [self retryEstablishSession];
    }
}

- (void)retryEstablishSession {
    // Current strategy disallows automatic retries.
    self.sessionSetupInProgress = NO;
    return;
}

- (void)createIAPDataSessionWithAccessory:(EAAccessory *)accessory forProtocol:(NSString *)protocol {

    [SDLDebugTool logInfo:@"Starting Data Session"];
    self.session = [[SDLIAPSession alloc] initWithAccessory:accessory forProtocol:protocol];
    if (self.session) {
        self.session.delegate = self;

        __weak typeof(self) weakSelf = self;

        // Configure Streams Delegate
        SDLStreamDelegate *ioStreamDelegate = [SDLStreamDelegate new];
        self.session.streamDelegate = ioStreamDelegate;

        // Data Session Has Bytes Handler
        ioStreamDelegate.streamHasBytesHandler = ^(NSInputStream *istream){
            [SDLDebugTool logInfo:@"Receiving Data"];
            uint8_t buf[IAP_INPUT_BUFFER_SIZE];

            while ([istream hasBytesAvailable])
            {
                // Read bytes
                NSInteger bytesRead = [istream read:buf maxLength:IAP_INPUT_BUFFER_SIZE];
                NSData *dataIn = [NSData dataWithBytes:buf length:bytesRead];

                // If we read some bytes, pass on to delegate
                // If no bytes, quit reading.
                if (bytesRead > 0) {
                    [weakSelf.delegate onDataReceived:dataIn];
                } else {
                    //[SDLDebugTool logInfo:@"No bytes read."];
                    break;
                }
            }

        };

        // Data Session Stream End Handler
        ioStreamDelegate.streamEndHandler = ^(NSStream *stream) {
            [SDLDebugTool logInfo:@"Data Stream Event End"];
            [weakSelf.session stop];
            weakSelf.session.streamDelegate = nil;
            if (![LEGACY_PROTOCOL_STRING isEqualToString:weakSelf.session.protocol]) {
                [weakSelf retryEstablishSession];
            }
            weakSelf.session = nil;
        };

        // Data Session Stream Error Handler
        ioStreamDelegate.streamErrorHandler = ^(NSStream *stream) {
            [SDLDebugTool logInfo:@"Data Stream Error"];
            [weakSelf.session stop];
            weakSelf.session.streamDelegate = nil;
            if (![LEGACY_PROTOCOL_STRING isEqualToString:weakSelf.session.protocol]) {
                [weakSelf retryEstablishSession];
            }
            weakSelf.session = nil;
        };


        if (![self.session start]) {
            [SDLDebugTool logInfo:@"Data Session Failed"];
            self.session.streamDelegate = nil;
            self.session = nil;
            [self retryEstablishSession];
        }

    }
    else {
        [SDLDebugTool logInfo:@"Failed MultiApp Data SDLIAPSession Initialization"];
        [self retryEstablishSession];
    }

}

// This gets called after both I/O streams of the session have opened.
- (void)onSessionInitializationCompleteForSession:(SDLIAPSession *)session {

    // Control Session Opened
    if ([CONTROL_PROTOCOL_STRING isEqualToString:session.protocol]) {
        [SDLDebugTool logInfo:@"Control Session Established"];
        [self.protocolIndexTimer start];
    }

    // Data Session Opened
    if (![CONTROL_PROTOCOL_STRING isEqualToString:session.protocol]) {
        self.sessionSetupInProgress = NO;
        [SDLDebugTool logInfo:@"Data Session Established"];
        [self.delegate onTransportConnected];
    }
}

// Retry establishSession on Stream End events only if it was the control session and we haven't already connected on non-control protocol
- (void)onSessionStreamsEnded:(SDLIAPSession *)session {
    if (!self.session && [CONTROL_PROTOCOL_STRING isEqualToString:session.protocol]) {
        [SDLDebugTool logInfo:@"onSessionStreamsEnded"];
        [session stop];
        [self retryEstablishSession];
    }
}

- (void)disconnect {
    [SDLDebugTool logInfo:@"IAP Disconnecting" withType:SDLDebugType_Transport_iAP toOutput:SDLDebugOutput_All toGroup:self.debugConsoleGroupName];
    if (self.session != nil) {
        [self.session stop];
        self.session = nil;
    }
}

- (void)sendData:(NSData *)data {

    dispatch_async(_transmit_queue, ^{
        NSOutputStream *ostream = self.session.easession.outputStream;
        NSMutableData *remainder = data.mutableCopy;

        while (1) {
            if (remainder.length == 0)
                break;

            if (ostream.streamStatus == NSStreamStatusOpen && ostream.hasSpaceAvailable) {

                NSInteger bytesWritten = [ostream write:remainder.bytes maxLength:remainder.length];
                if (bytesWritten == -1) {
                    NSLog(@"Error: %@", [ostream streamError]);
                    break;
                }

                [remainder replaceBytesInRange:NSMakeRange(0, bytesWritten) withBytes:NULL length:0];
            }
        }
    });

}

- (void)destructObjects {
    if(!_alreadyDestructed) {
        _alreadyDestructed = YES;
        [self stopEventListening];
        self.controlSession = nil;
        self.session = nil;
        self.delegate = nil;
    }
}

- (void)dispose {
    [self destructObjects];
}

- (void)dealloc {
    [self destructObjects];
    [SDLDebugTool logInfo:@"SDLIAPTransport Dealloc" withType:SDLDebugType_Transport_iAP toOutput:SDLDebugOutput_All toGroup:self.debugConsoleGroupName];
}

- (double)retryDelay {

    const double min_value = 0.0;
    const double max_value = 10.0;
    double range_length = max_value - min_value;

    static double delay = 0;

    if (delay == 0) {
        NSString *appName = [[NSProcessInfo processInfo] processName];
        if (appName == nil) {
            appName = @"noname";
        }
        const char *ptr = [appName UTF8String];
        unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
        CC_MD5(ptr, (unsigned int)strlen(ptr), md5Buffer);
        NSMutableString *output = [NSMutableString stringWithString:@"0x"];
        for(int i = 0; i < 8; i++)
            [output appendFormat:@"%02X",md5Buffer[i]];
        unsigned long long firstHalf;
        NSScanner* pScanner = [NSScanner scannerWithString: output];
        [pScanner scanHexLongLong:&firstHalf];
        double hashBasedValueInRange0to1 = ((double)firstHalf)/0xffffffffffffffff;
        delay = range_length * hashBasedValueInRange0to1 + min_value;
        
    }
    
    return delay;
}

@end
