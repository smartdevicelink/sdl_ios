//
//  SDLSecondaryTransportManager.m
//  SmartDeviceLink
//
//  Created by Sho Amano on 2018/02/28.
//  Copyright © 2018 Xevo Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "SDLSecondaryTransportManager.h"

#import "SDLBackgroundTaskManager.h"
#import "SDLControlFramePayloadConstants.h"
#import "SDLControlFramePayloadRPCStartServiceAck.h"
#import "SDLControlFramePayloadTransportEventUpdate.h"
#import "SDLIAPTransport.h"
#import "SDLLogMacros.h"
#import "SDLOnHMIStatus.h"
#import "SDLProtocol.h"
#import "SDLProtocolHeader.h"
#import "SDLProtocolMessage.h"
#import "SDLNotificationConstants.h"
#import "SDLRPCNotificationNotification.h"
#import "SDLStateMachine.h"
#import "SDLTCPTransport.h"
#import "SDLTimer.h"

NS_ASSUME_NONNULL_BEGIN

// same as SDLProtocol.m
typedef NSNumber SDLServiceTypeBox;

typedef NS_ENUM(NSInteger, SDLTransportClass) {
    SDLTransportClassInvalid = 0,
    SDLTransportClassPrimary = 1,
    SDLTransportClassSecondary = 2,
};
typedef NSNumber SDLTransportClassBox;

typedef NS_ENUM(NSInteger, SDLSecondaryTransportType) {
    SDLSecondaryTransportTypeDisabled,  // only for Secondary Transport
    SDLSecondaryTransportTypeIAP,
    SDLSecondaryTransportTypeTCP
};
typedef NSNumber SDLSecondaryTransportTypeBox;

SDLSecondaryTransportState *const SDLSecondaryTransportStateStopped = @"Stopped";
SDLSecondaryTransportState *const SDLSecondaryTransportStateStarted = @"Started";
SDLSecondaryTransportState *const SDLSecondaryTransportStateConfigured = @"Configured";
SDLSecondaryTransportState *const SDLSecondaryTransportStateConnecting = @"Connecting";
SDLSecondaryTransportState *const SDLSecondaryTransportStateRegistered = @"Registered";
SDLSecondaryTransportState *const SDLSecondaryTransportStateReconnecting = @"Reconnecting";

/// Name for the background task started when the device app is backgrounded.
NSString *const BackgroundTaskSecondaryTransportName = @"com.sdl.transport.secondaryTransportBackgroundTask";

// Timeout for receiving Register Secondary Transport ACK frame
static const float RegisterTransportTime = 10.0;

// Delay to retry connection after secondary transport is disconnected or registration is failed
static const float RetryConnectionDelay = 5.0;

// Indicates that a TCP port is not specified (unconfigured).
static const int TCPPortUnspecified = -1;

/// The old and new protocols being used when the transport switches. If the old protocol is `nil`, the transport is not yet started; newProtocol is `nil` the transport will be stopped.
struct TransportProtocolUpdated {
   SDLProtocol * _Nullable oldProtocol;
   SDLProtocol * _Nullable newProtocol;
} transportUpdated;

@interface SDLSecondaryTransportManager ()

/// State of this manager.
@property (strong, nonatomic) SDLStateMachine *stateMachine;
// Dedicated queue that the state machine will run on.
@property (copy, nonatomic) dispatch_queue_t stateMachineQueue;

// Instance of the protocol that runs on primary transport.
@property (strong, nonatomic) SDLProtocol *primaryProtocol;
/// The header of the Start Service ACK frame received on primary transport
@property (copy, nonatomic) SDLProtocolHeader *primaryRPCHeader;

// Selected type of secondary transport. If 'SDLSecondaryTransportTypeDisabled' then secondary transport is disabled.
@property (assign, nonatomic) SDLSecondaryTransportType secondaryTransportType;
// Instance of the transport for secondary transport.
@property (strong, nonatomic, nullable) id<SDLTransportType> secondaryTransport;
// Instance of the protocol that runs on secondary transport.
@property (strong, nonatomic, nullable) SDLProtocol *secondaryProtocol;
// Timer to check Register Secondary Transport ACK response on secondary transport.
@property (strong, nonatomic, nullable) SDLTimer *registerTransportTimer;

// A delegate to notify protocol change.
@property (weak, nonatomic) id<SDLStreamingProtocolDelegate> streamingProtocolDelegate;

// Configuration sent by system; list of transports that are allowed to carry audio service
@property (strong, nonatomic) NSArray<SDLTransportClassBox *> *transportsForAudioService;
// Configuration sent by system; list of transports that are allowed to carry video service
@property (strong, nonatomic) NSArray<SDLTransportClassBox *> *transportsForVideoService;
// A map to remember which service is currently running on which transport
@property (strong, nonatomic) NSMutableDictionary<SDLServiceTypeBox *, SDLTransportClassBox *> *streamingServiceTransportMap;

// IP address of SDL Core (either IPv4 or IPv6 address)
@property (strong, nonatomic, nullable) NSString *ipAddress;
// TCP port number of SDL Core. If the information isn't available then TCPPortUnspecified is stored.
@property (assign, nonatomic) int tcpPort;

/// The current hmi level of the SDL app.
@property (strong, nonatomic, nullable) SDLHMILevel currentHMILevel;

/// A background task used to close the secondary transport before the app is suspended.
@property (strong, nonatomic) SDLBackgroundTaskManager *backgroundTaskManager;

@end

@implementation SDLSecondaryTransportManager

#pragma mark - Public

- (instancetype)initWithStreamingProtocolDelegate:(id<SDLStreamingProtocolDelegate>)streamingProtocolDelegate
                                      serialQueue:(dispatch_queue_t)queue {
    self = [super init];
    if (!self) {
        return nil;
    }

    _stateMachine = [[SDLStateMachine alloc] initWithTarget:self initialState:SDLSecondaryTransportStateStopped states:[self.class sdl_stateTransitionDictionary]];
    _stateMachineQueue = queue;
    _streamingProtocolDelegate = streamingProtocolDelegate;

    _secondaryTransportType = SDLSecondaryTransportTypeDisabled;
    _transportsForAudioService = @[];
    _transportsForVideoService = @[];
    _streamingServiceTransportMap = [@{@(SDLServiceTypeAudio):@(SDLTransportClassInvalid),
                            @(SDLServiceTypeVideo):@(SDLTransportClassInvalid)} mutableCopy];
    _tcpPort = TCPPortUnspecified;

    _backgroundTaskManager = [[SDLBackgroundTaskManager alloc] initWithBackgroundTaskName:BackgroundTaskSecondaryTransportName];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_hmiStatusDidChange:) name:SDLDidChangeHMIStatusNotification object:nil];

    return self;
}

- (void)startWithPrimaryProtocol:(SDLProtocol *)primaryProtocol {
    SDLLogD(@"SDLSecondaryTransportManager start");

    // this method must be called in SDLLifecycleManager's state machine queue
    if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(self.stateMachineQueue)) != 0) {
        SDLLogE(@"startWithPrimaryProtocol: must be called in SDLLifecycleManager's state machine queue!");
    }

    if (![self.stateMachine isCurrentState:SDLSecondaryTransportStateStopped]) {
        SDLLogW(@"Secondary transport manager is already started!");
        return;
    }

    self.primaryProtocol = primaryProtocol;

    @synchronized(self.primaryProtocol.protocolDelegateTable) {
        [self.primaryProtocol.protocolDelegateTable addObject:self];
    }

    [self.stateMachine transitionToState:SDLSecondaryTransportStateStarted];
}

- (void)stop {
    SDLLogD(@"Stopping manager");

    // this method must be called in SDLLifecycleManager's state machine queue
    if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(self.stateMachineQueue)) != 0) {
        SDLLogE(@"stop must be called in SDLLifecycleManager's state machine queue!");
    }

    // stop all services, including those running on primary transport
    SDLLogD(@"Stopping audio / video services on both transports");
    [self sdl_handleTransportUpdateWithPrimaryAvailable:NO secondaryAvailable:NO];

    [self.stateMachine transitionToState:SDLSecondaryTransportStateStopped];
}

#pragma mark - Manager Lifecycle

- (void)sdl_startManager {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_onAppStateUpdated:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_onAppStateUpdated:) name:UIApplicationWillResignActiveNotification object:nil];
}

- (void)sdl_stopManager {
    SDLLogD(@"SDLSecondaryTransportManager stop");

    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];

    self.streamingServiceTransportMap = [@{@(SDLServiceTypeAudio):@(SDLTransportClassInvalid),
                                @(SDLServiceTypeVideo):@(SDLTransportClassInvalid)} mutableCopy];
    self.secondaryTransportType = SDLSecondaryTransportTypeDisabled;
    self.transportsForAudioService = @[];
    self.transportsForVideoService = @[];

    self.ipAddress = nil;
    self.tcpPort = TCPPortUnspecified;
    self.currentHMILevel = nil;
}

- (void)sdl_configureManager:(nullable NSArray<SDLSecondaryTransportTypeBox *> *)availableSecondaryTransports
          availableTransportsForAudio:(nullable NSArray<SDLTransportClassBox *> *)availableTransportsForAudio
          availableTransportsForVideo:(nullable NSArray<SDLTransportClassBox *> *)availableTransportsForVideo {
    if (![self.stateMachine isCurrentState:SDLSecondaryTransportStateStarted]) {
        SDLLogW(@"SecondaryTransportManager ignores duplicate Start Service ACK frame");
        return;
    }

    // default values
    self.secondaryTransportType = SDLSecondaryTransportTypeDisabled;
    self.transportsForAudioService = @[@(SDLTransportClassPrimary)]; // If SDL Core did not send a transport list for the service, start it on Primary Transport.
    self.transportsForVideoService = @[@(SDLTransportClassPrimary)];
    BOOL validConfig = YES;

    if (availableSecondaryTransports.count > 0) {
        // current proposal says the list should contain only one element
        SDLSecondaryTransportTypeBox *transportType = availableSecondaryTransports[0];
        self.secondaryTransportType = [transportType integerValue];
    } else {
        SDLLogW(@"Did not receive secondary transport type from system. Secondary transport is disabled.");
    }

    SDLSecondaryTransportType primaryTransportType = [self sdl_getTransportTypeFromProtocol:self.primaryProtocol];
    if (self.secondaryTransportType == primaryTransportType) {
        SDLLogW(@"Same transport is specified for both primary and secondary transport. Secondary transport is disabled.");
        self.secondaryTransportType = SDLSecondaryTransportTypeDisabled;
        validConfig = NO; // let audio and video services start on primary transport
    } else if (self.secondaryTransportType == SDLSecondaryTransportTypeIAP) {
        SDLLogW(@"Starting IAP as secondary transport, which does not usually happen");
    }

    if (availableTransportsForAudio != nil && validConfig) {
        self.transportsForAudioService = availableTransportsForAudio;
    }
    if (availableTransportsForVideo != nil && validConfig) {
        self.transportsForVideoService = availableTransportsForVideo;
    }

    // this will trigger audio / video streaming if they are allowed on primary transport
    [self sdl_handleTransportUpdateWithPrimaryAvailable:YES secondaryAvailable:NO];

    [self.stateMachine transitionToState:SDLSecondaryTransportStateConfigured];
}

#pragma mark - State machine

+ (NSDictionary<SDLState *, SDLAllowableStateTransitions *> *)sdl_stateTransitionDictionary {
    return @{
             SDLSecondaryTransportStateStopped: @[SDLSecondaryTransportStateStarted],
             SDLSecondaryTransportStateStarted: @[SDLSecondaryTransportStateConfigured, SDLSecondaryTransportStateStopped],
             SDLSecondaryTransportStateConfigured: @[SDLSecondaryTransportStateConnecting, SDLSecondaryTransportStateStopped],
             SDLSecondaryTransportStateConnecting: @[SDLSecondaryTransportStateRegistered, SDLSecondaryTransportStateConfigured, SDLSecondaryTransportStateReconnecting, SDLSecondaryTransportStateStopped],
             SDLSecondaryTransportStateRegistered: @[SDLSecondaryTransportStateReconnecting, SDLSecondaryTransportStateConfigured, SDLSecondaryTransportStateStopped],
             SDLSecondaryTransportStateReconnecting: @[SDLSecondaryTransportStateConfigured, SDLSecondaryTransportStateStopped]
             };
}

- (void)didEnterStateStopped {
    SDLLogD(@"Secondary transport manager stopped");
    [self sdl_stopManager];
}

- (void)didEnterStateStarted {
    SDLLogD(@"Secondary transport manager started");
    [self sdl_startManager];
}

- (void)didEnterStateConfigured {
    SDLLogD(@"Secondary transport manager is configured");
    // If this is a TCP transport, check if it's ready. If it's IAP, we can just continue. In both cases, check if HMI level is Non-NONE
    // https://github.com/smartdevicelink/sdl_evolution/blob/master/proposals/0214-secondary-transport-optimization.md
    if (((self.secondaryTransportType == SDLSecondaryTransportTypeTCP && self.sdl_isTCPReady)
         || self.secondaryTransportType == SDLSecondaryTransportTypeIAP)
        && self.sdl_isHMILevelNonNone) {
        [self.stateMachine transitionToState:SDLSecondaryTransportStateConnecting];
    }
}

- (void)didEnterStateConnecting {
    SDLLogD(@"Secondary transport is connecting");
    [self sdl_connectSecondaryTransport];
}

- (void)willLeaveStateConnecting {
    // make sure to terminate the timer, which is only used in Connecting state
    [self.registerTransportTimer cancel];
    self.registerTransportTimer = nil;
}

- (void)didEnterStateRegistered {
    SDLLogD(@"Secondary transport is registered");
    [self sdl_handleTransportUpdateWithPrimaryAvailable:YES secondaryAvailable:YES];
}

- (void)willTransitionFromStateRegisteredToStateConfigured {
    SDLLogD(@"Manger is closing transport but is configured to resume the secondary transport. Stopping services on secondary transport");
    [self sdl_handleTransportUpdateWithPrimaryAvailable:YES secondaryAvailable:NO];
}

- (void)willTransitionFromStateRegisteredToStateReconnecting {
    SDLLogD(@"Manger is closing transport but will try to reconnect if configured correctly. Stopping services on secondary transport");
    [self sdl_handleTransportUpdateWithPrimaryAvailable:YES secondaryAvailable:NO];
}

- (void)didEnterStateReconnecting {
    SDLLogD(@"Secondary transport is reconnecting");
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(RetryConnectionDelay * NSEC_PER_SEC)), _stateMachineQueue, ^{
        if ([weakSelf.stateMachine isCurrentState:SDLSecondaryTransportStateReconnecting]) {
            SDLLogD(@"Attempting reconnection");
            [weakSelf.stateMachine transitionToState:SDLSecondaryTransportStateConfigured];
        }
    });
}


#pragma mark - Starting / Stopping / Restarting services

- (void)sdl_handleTransportUpdateWithPrimaryAvailable:(BOOL)primaryAvailable secondaryAvailable:(BOOL)secondaryAvailable {
    struct TransportProtocolUpdated audioTransportUpdated = [self sdl_updateService:SDLServiceTypeAudio allowedTransports:self.transportsForAudioService primaryAvailable:primaryAvailable secondaryAvailable:secondaryAvailable];
    struct TransportProtocolUpdated videoTransportUpdated = [self sdl_updateService:SDLServiceTypeVideo allowedTransports:self.transportsForVideoService primaryAvailable:primaryAvailable secondaryAvailable:secondaryAvailable];

    if (audioTransportUpdated.newProtocol == audioTransportUpdated.oldProtocol && videoTransportUpdated.newProtocol == videoTransportUpdated.oldProtocol) { return; }

    [self.streamingProtocolDelegate didUpdateFromOldVideoProtocol:videoTransportUpdated.oldProtocol toNewVideoProtocol:videoTransportUpdated.newProtocol fromOldAudioProtocol:audioTransportUpdated.oldProtocol toNewAudioProtocol:audioTransportUpdated.newProtocol];
}

- (struct TransportProtocolUpdated)sdl_updateService:(SDLServiceType)service allowedTransports:(nonnull NSArray<SDLTransportClassBox *> *)transportList primaryAvailable:(BOOL)primaryTransportAvailable secondaryAvailable:(BOOL)secondaryTransportAvailable {
    SDLTransportClass newTransport = SDLTransportClassInvalid;
    // the list is in preferred order, so take a look from the beginning
    for (SDLTransportClassBox *transport in transportList) {
        if ([transport intValue] == SDLTransportClassSecondary && secondaryTransportAvailable) {
            newTransport = SDLTransportClassSecondary;
            break;
        } else if ([transport intValue] == SDLTransportClassPrimary && primaryTransportAvailable) {
            newTransport = SDLTransportClassPrimary;
            break;
        }
    }

    SDLTransportClass oldTransport = [self.streamingServiceTransportMap[@(service)] intValue];

    // update transport, and notify the change to start/stop/restart service
    self.streamingServiceTransportMap[@(service)] = @(newTransport);

    if (oldTransport != newTransport) {
        if (oldTransport != SDLTransportClassInvalid && newTransport != SDLTransportClassInvalid) {
            SDLLogD(@"Restarting service 0x%X from %@ to %@ transport", service, [self sdl_getTransportClassName:oldTransport], [self sdl_getTransportClassName:newTransport]);
        } else if (oldTransport != SDLTransportClassInvalid) {
            SDLLogD(@"Stopping service 0x%X on %@ transport", service, [self sdl_getTransportClassName:oldTransport]);
        } else if (newTransport != SDLTransportClassInvalid) {
            SDLLogD(@"Starting service 0x%X on %@ transport", service, [self sdl_getTransportClassName:newTransport]);
        }
    } else {
        SDLLogV(@"Transport was not updated");
    }

    struct TransportProtocolUpdated transportUpdated;
    transportUpdated.oldProtocol = [self sdl_getProtocolFromTransportClass:oldTransport];
    transportUpdated.newProtocol = [self sdl_getProtocolFromTransportClass:newTransport];
    return transportUpdated;
}

- (nullable SDLProtocol *)sdl_getProtocolFromTransportClass:(SDLTransportClass)transportClass {
    switch (transportClass) {
        case SDLTransportClassPrimary: return self.primaryProtocol;
        case SDLTransportClassSecondary: return self.secondaryProtocol;
        default: return nil;
    }
}

- (nullable NSString *)sdl_getTransportClassName:(SDLTransportClass)transportClass {
    switch (transportClass) {
        case SDLTransportClassPrimary: return @"primary";
        case SDLTransportClassSecondary: return @"secondary";
        default: return nil;
    }
}


#pragma mark - Transport management

#pragma mark Primary transport
- (void)handleProtocolStartServiceACKMessage:(SDLProtocolMessage *)startServiceACK {
    if (startServiceACK.header.serviceType != SDLServiceTypeRPC) { return; }
    SDLLogV(@"Received Start Service ACK header of RPC service on primary transport");

    // Keep header to acquire Session ID
    self.primaryRPCHeader = startServiceACK.header;

    SDLControlFramePayloadRPCStartServiceAck *payload = [[SDLControlFramePayloadRPCStartServiceAck alloc] initWithData:startServiceACK.payload];

    [self sdl_onStartServiceAckReceived:payload];
}

- (void)handleTransportEventUpdateMessage:(SDLProtocolMessage *)transportEventUpdate {
    SDLControlFramePayloadTransportEventUpdate *payload = [[SDLControlFramePayloadTransportEventUpdate alloc] initWithData:transportEventUpdate.payload];
    SDLLogV(@"Recieved transport event update on primary transport: %@", payload);

    [self sdl_onTransportEventUpdateReceived:payload];
}

#pragma mark Secondary transport

// try establishing secondary transport. Returns NO if failed
- (BOOL)sdl_connectSecondaryTransport {
    if (self.secondaryTransport != nil) {
        SDLLogW(@"Attempting to connect secondary transport, but it's already started.");
        return NO;
    }

    switch (self.secondaryTransportType) {
        case SDLSecondaryTransportTypeTCP:
            return [self sdl_startTCPSecondaryTransport];
        case SDLSecondaryTransportTypeIAP:
            return [self sdl_startIAPSecondaryTransport];
        default:
            SDLLogW(@"Unknown transport type for secondary transport: %ld", (long)self.secondaryTransportType);
            return NO;
    }
}

- (BOOL)disconnectSecondaryTransport {
    if (self.secondaryTransport == nil) {
        SDLLogW(@"Attempted to disconnect secondary transport but it's already stopped.");
        return NO;
    }

    SDLLogD(@"Disconnecting secondary transport");
    [self.secondaryTransport disconnect];
    self.secondaryTransport = nil;
    self.secondaryProtocol = nil;

    [self.backgroundTaskManager expiredTaskCleanupFinished];

    return YES;
}

- (BOOL)sdl_startTCPSecondaryTransport {
    if (![self sdl_isTCPReady]) {
        SDLLogD(@"TCP secondary transport is not ready.");
        return NO;
    }

    SDLLogD(@"Starting TCP Secondary Transport (IP address = \"%@\", port = \"%d\")", self.ipAddress, self.tcpPort);

    SDLTCPTransport *transport = [[SDLTCPTransport alloc] init];
    transport.hostName = self.ipAddress;
    transport.portNumber = [NSString stringWithFormat:@"%d", self.tcpPort];
    SDLProtocol *protocol = [[SDLProtocol alloc] init];
    transport.delegate = protocol;
    protocol.transport = transport;
    protocol.securityManager = self.primaryProtocol.securityManager;
    self.secondaryProtocol = protocol;
    self.secondaryTransport = transport;

    @synchronized(self.secondaryProtocol.protocolDelegateTable) {
        [self.secondaryProtocol.protocolDelegateTable addObject:self];
    }

    // we reuse Session ID acquired from primary transport's protocol
    // this is for Register Secondary Transport frame
    [self.secondaryProtocol storeHeader:self.primaryRPCHeader forServiceType:SDLServiceTypeControl];
    // this is for video and audio services
    [self.secondaryProtocol storeHeader:self.primaryRPCHeader forServiceType:SDLServiceTypeRPC];

    [self.secondaryTransport connect];
    return YES;
}

- (BOOL)sdl_startIAPSecondaryTransport {
    SDLLogD(@"Starting Secondary Transport: iAP");

    SDLIAPTransport *transport = [[SDLIAPTransport alloc] init];
    SDLProtocol *protocol = [[SDLProtocol alloc] init];
    transport.delegate = protocol;
    protocol.transport = transport;
    protocol.securityManager = self.primaryProtocol.securityManager;
    self.secondaryProtocol = protocol;
    self.secondaryTransport = transport;

    @synchronized(self.secondaryProtocol.protocolDelegateTable) {
        [self.secondaryProtocol.protocolDelegateTable addObject:self];
    }

    // we reuse Session ID acquired from primary transport's protocol
    // this is for Register Secondary Transport frame
    [self.secondaryProtocol storeHeader:self.primaryRPCHeader forServiceType:SDLServiceTypeControl];
    // this is for video and audio services
    [self.secondaryProtocol storeHeader:self.primaryRPCHeader forServiceType:SDLServiceTypeRPC];

    [self.secondaryTransport connect];
    return YES;
}

- (BOOL)sdl_isTCPReady {
    if ([self.ipAddress length] == 0) {
        SDLLogD(@"IP address is empty");
        return NO;
    }
    if (self.tcpPort == TCPPortUnspecified) {
        SDLLogD(@"TCP port number is not available");
        return NO;
    }
    if (!(self.tcpPort > 0 && self.tcpPort <= 65535)) {
        SDLLogW(@"Invalid TCP port number for secondary transport: %d", self.tcpPort);
        return NO;
    }

    if (self.sdl_getAppState != UIApplicationStateActive) {
        SDLLogD(@"App state is not Active, TCP transport is not ready");
        return NO;
    }

    return YES;
}

- (UIApplicationState)sdl_getAppState {
    if ([NSThread isMainThread]) {
        return [UIApplication sharedApplication].applicationState;
    } else {
        __block UIApplicationState appState;
        dispatch_sync(dispatch_get_main_queue(), ^{
            appState = [UIApplication sharedApplication].applicationState;
        });
        return appState;
    }
}


#pragma mark - SDLProtocolListener Implementation

// called on transport's thread, notifying that the transport is established
- (void)onProtocolOpened {
    SDLLogD(@"Secondary transport connected");

    self.registerTransportTimer = [[SDLTimer alloc] initWithDuration:RegisterTransportTime repeat:NO];
    __weak typeof(self) weakSelf = self;
    self.registerTransportTimer.elapsedBlock = ^{
        SDLLogW(@"Timeout for registration of secondary transport");
        dispatch_async(weakSelf.stateMachineQueue, ^{
            __strong typeof(self) strongSelf = weakSelf;
            if (!strongSelf) {
                return;
            }

            // if the state is still Connecting, go back to Configured state and retry immediately
            if ([strongSelf.stateMachine isCurrentState:SDLSecondaryTransportStateConnecting]) {
                SDLLogD(@"Retry secondary transport connection after registration timeout");
                [strongSelf.stateMachine transitionToState:SDLSecondaryTransportStateConfigured];
            } else {
                SDLLogD(@"Will not retry secondary transport connection because current state is: %@", strongSelf.stateMachine.currentState);
            }
        });
    };
    [self.registerTransportTimer start];

    [self.secondaryProtocol registerSecondaryTransport];
}

- (void)onTransportError:(NSError *)error {
    SDLLogE(@"The transport errored. Disconnecting the transport");
    [self disconnectSecondaryTransport];
}

// called on transport's thread, notifying that the transport is disconnected
// (Note: when transport's disconnect method is called, this method will not be called)
- (void)onProtocolClosed {
    SDLLogD(@"secondary transport disconnected");

    dispatch_async(self.stateMachineQueue, ^{
        if ([self sdl_isTransportOpened]) {
            [self.stateMachine transitionToState:SDLSecondaryTransportStateReconnecting];
        }
    });
}

// called from SDLProtocol's _receiveQueue of secondary transport
- (void)handleProtocolRegisterSecondaryTransportACKMessage:(SDLProtocolMessage *)registerSecondaryTransportACK {
    SDLLogD(@"Received Register Secondary Transport ACK frame");

    dispatch_async(self.stateMachineQueue, ^{
        // secondary transport is now ready
        [self.stateMachine transitionToState:SDLSecondaryTransportStateRegistered];
    });
}

// called from SDLProtocol's _receiveQueue of secondary transport
- (void)handleProtocolRegisterSecondaryTransportNAKMessage:(SDLProtocolMessage *)registerSecondaryTransportNAK {
    SDLLogW(@"Received Register Secondary Transport NAK frame");

    dispatch_async(self.stateMachineQueue, ^{
        [self.stateMachine transitionToState:SDLSecondaryTransportStateReconnecting];
    });
}

/// Called when a Start Service ACK control frame is received on the primary transport.
/// @param payload The payload of Start Service ACK frame received on the primary transport.
- (void)sdl_onStartServiceAckReceived:(SDLControlFramePayloadRPCStartServiceAck *)payload {
    NSMutableArray<SDLSecondaryTransportTypeBox *> *secondaryTransports = nil;
    if (payload.secondaryTransports != nil) {
        secondaryTransports = [NSMutableArray array];
        for (NSString *transportString in payload.secondaryTransports) {
            SDLSecondaryTransportType transport = [self sdl_convertTransportType:transportString];
            [secondaryTransports addObject:@(transport)];
        }
    }

    NSArray<SDLTransportClassBox *> *transportsForAudio = [self sdl_convertServiceTransports:payload.audioServiceTransports];
    NSArray<SDLTransportClassBox *> *transportsForVideo = [self sdl_convertServiceTransports:payload.videoServiceTransports];

    SDLLogV(@"Secondary transports: %@, transports for audio: %@, transports for video: %@", secondaryTransports, transportsForAudio, transportsForVideo);

    dispatch_async(_stateMachineQueue, ^{
        [self sdl_configureManager:secondaryTransports availableTransportsForAudio:transportsForAudio availableTransportsForVideo:transportsForVideo];
    });
}

/// Called when a Transport Event Update control frame is received on the primary transport.
/// @param payload the payload of Transport Event Update frame
- (void)sdl_onTransportEventUpdateReceived:(SDLControlFramePayloadTransportEventUpdate *)payload {
    dispatch_async(_stateMachineQueue, ^{
        BOOL updated = NO;

        if (payload.tcpIpAddress != nil) {
            if (![self.ipAddress isEqualToString:payload.tcpIpAddress]) {
                self.ipAddress = payload.tcpIpAddress;
                updated = YES;
                SDLLogD(@"TCP transport IP address updated: %@", self.ipAddress);
            }
        }
        if (payload.tcpPort != SDLControlFrameInt32NotFound) {
            if (self.tcpPort != payload.tcpPort) {
                self.tcpPort = payload.tcpPort;
                updated = YES;
                SDLLogD(@"TCP transport port number updated: %d", self.tcpPort);
            }
        }

        if (updated) {
            [self sdl_handleTransportEventUpdate];
        }
    });
}

- (void)sdl_handleTransportEventUpdate {
    if ([self.stateMachine isCurrentState:SDLSecondaryTransportStateStarted]) {
        // The system sent Transport Event Update frame prior to Start Service ACK. Just keep the information and do nothing here.
        SDLLogV(@"Received TCP transport information prior to Start Service ACK");
        return;
    }
    if (self.secondaryTransportType != SDLSecondaryTransportTypeTCP) {
        SDLLogV(@"Received TCP transport information while the transport is not TCP");
        return;
    }

    if ([self.stateMachine isCurrentState:SDLSecondaryTransportStateConfigured] && self.sdl_isTCPReady && self.sdl_isHMILevelNonNone) {
        [self.stateMachine transitionToState:SDLSecondaryTransportStateConnecting];
    } else if ([self sdl_isTransportOpened]) {
        // Disconnect current transport. If the IP address is available then we will reconnect immediately.
        SDLLogD(@"TCP transport information updated, disconnecting current transport");
        [self.stateMachine transitionToState:SDLSecondaryTransportStateConfigured];
    } else if ([self.stateMachine isCurrentState:SDLSecondaryTransportStateReconnecting]) {
        SDLLogD(@"TCP transport information updated, aborting reconnection timer");
        [self.stateMachine transitionToState:SDLSecondaryTransportStateConfigured];
    }
}

#pragma mark - App state handling

/// Closes and re-opens the the secondary transport when the app is backgrounded and foregrounded on the device respectively. This is done because sockets can be reclaimed by the system at anytime when the app is not in the foreground.
/// @param notification Notification from the OS that the app's life-cycle state has changed
- (void)sdl_onAppStateUpdated:(NSNotification *)notification {
    __weak typeof(self) weakSelf = self;
    dispatch_async(self.stateMachineQueue, ^{
        __strong typeof(self) strongSelf = weakSelf;
        if (notification.name == UIApplicationWillResignActiveNotification) {
            SDLLogD(@"App will enter the background");
            if ([strongSelf sdl_isTransportOpened] && strongSelf.secondaryTransportType == SDLSecondaryTransportTypeTCP) {
                SDLLogD(@"Starting background task to keep TCP transport alive");
                strongSelf.backgroundTaskManager.taskExpiringHandler = [strongSelf sdl_backgroundTaskEndedHandler];
                [strongSelf.backgroundTaskManager startBackgroundTask];
            } else {
                SDLLogD(@"TCP transport already disconnected, will not start a background task.");
            }
        } else if (notification.name == UIApplicationDidBecomeActiveNotification) {
            SDLLogD(@"App entered the foreground");
            if ([strongSelf.stateMachine isCurrentState:SDLSecondaryTransportStateRegistered]) {
                SDLLogD(@"In the registered state; TCP transport has not yet been shutdown. Ending the background task.");
                [strongSelf.backgroundTaskManager endBackgroundTask];
            } else if ([strongSelf.stateMachine isCurrentState:SDLSecondaryTransportStateConfigured]
                && strongSelf.secondaryTransportType == SDLSecondaryTransportTypeTCP
                && [strongSelf sdl_isTCPReady]
                && [strongSelf sdl_isHMILevelNonNone]) {
                SDLLogD(@"In the configured state; restarting the TCP transport. Ending the background task.");
                [strongSelf.backgroundTaskManager endBackgroundTask];
                [strongSelf.stateMachine transitionToState:SDLSecondaryTransportStateConnecting];
            } else {
                SDLLogD(@"TCP transport not ready to start, our current state is: %@", strongSelf.stateMachine.currentState);
            }
        }
    });
}

/// Handles a notification that the background task has ended. If the app is still in the background, the TCP transport disconnects. If the app has re-entered the foreground or the manager has shutdown then the notification is ignored.
/// @return A background task ended handler
- (nullable BOOL (^)(void))sdl_backgroundTaskEndedHandler {
    __weak typeof(self) weakSelf = self;
    return ^{
        __strong typeof(self) strongSelf = weakSelf;
        if (strongSelf.sdl_getAppState == UIApplicationStateActive || [strongSelf.stateMachine isCurrentState:SDLSecondaryTransportStateStopped]) {
            SDLLogV(@"No cleanup needed since app has been foregrounded.");
            return NO;
        } else if ([strongSelf.stateMachine isCurrentState:SDLSecondaryTransportStateStopped]) {
            SDLLogV(@"No cleanup needed since manager has been stopped.");
            return NO;
        } else {
            SDLLogD(@"Performing cleanup due to the background task expiring: disconnecting the TCP transport.");
            [strongSelf.stateMachine transitionToState:SDLSecondaryTransportStateConfigured];
            return YES;
        }
    };
}

#pragma mark - Utility methods

- (SDLSecondaryTransportType)sdl_convertTransportType:(NSString *)transportString {
    if ([transportString isEqualToString:@"TCP_WIFI"]) {
        return SDLSecondaryTransportTypeTCP;
    } else if ([transportString isEqualToString:@"IAP_BLUETOOTH"] ||
               [transportString isEqualToString:@"IAP_USB"] ||
               [transportString isEqualToString:@"IAP_USB_HOST_MODE"] ||
               [transportString isEqualToString:@"IAP_USB_DEVICE_MODE"] ||
               [transportString isEqualToString:@"IAP_CARPLAY"]) {
        return SDLSecondaryTransportTypeIAP;
    } else {
        // "SPP_BLUETOOTH" and "AOA_USB" are not used
        return SDLSecondaryTransportTypeDisabled;
    }
}

- (nullable NSArray<SDLTransportClassBox *> *)sdl_convertServiceTransports:(nullable NSArray<NSNumber *> *)transports {
    if (transports == nil) {
        return nil;
    }

    // Actually there is nothing to "convert" here. We just check the range and recreate an array.
    NSMutableArray<SDLTransportClassBox *> *array = [[NSMutableArray alloc] init];
    for (NSNumber *num in transports) {
        int transport = [num intValue];
        if (transport == 1) {
            [array addObject:@(SDLTransportClassPrimary)];
        } else if (transport == 2) {
            [array addObject:@(SDLTransportClassSecondary)];
        } else {
            SDLLogE(@"Unknown transport class received: %d", transport);
        }
    }

    return [array copy];
}

- (SDLSecondaryTransportType)sdl_getTransportTypeFromProtocol:(SDLProtocol *)protocol {
    if ([protocol.transport isMemberOfClass:[SDLIAPTransport class]]) {
        return SDLSecondaryTransportTypeIAP;
    } else if ([protocol.transport isMemberOfClass:[SDLTCPTransport class]]) {
        return SDLSecondaryTransportTypeTCP;
    } else {
        SDLLogE(@"Unknown type of primary transport");
        return SDLSecondaryTransportTypeDisabled;
    }
}

- (BOOL)sdl_isTransportOpened {
    return [self.stateMachine isCurrentState:SDLSecondaryTransportStateConnecting] || [self.stateMachine isCurrentState:SDLSecondaryTransportStateRegistered];
}

- (BOOL)sdl_isHMILevelNonNone {
    return (self.currentHMILevel != nil && ![self.currentHMILevel isEqualToEnum:SDLHMILevelNone]);
}

#pragma mark - RPC Notifications
/// Check and track the HMI status to ensure that the secondary transport only attempts a connection in non-NONE HMI states
///
/// See: https://github.com/smartdevicelink/sdl_evolution/blob/master/proposals/0214-secondary-transport-optimization.md
///
/// @param notification The NSNotification containing the OnHMIStatus
- (void)sdl_hmiStatusDidChange:(SDLRPCNotificationNotification *)notification {
    if (![notification isNotificationMemberOfClass:[SDLOnHMIStatus class]]) {
        return;
    }

    SDLOnHMIStatus *hmiStatus = notification.notification;
    self.currentHMILevel = hmiStatus.hmiLevel;

    // If the HMI level is non-NONE, and the state machine is currently waiting in the configured state, and _either_ we're using TCP and it's ready _or_ we're using IAP.
    if (self.sdl_isHMILevelNonNone
       && [self.stateMachine isCurrentState:SDLSecondaryTransportStateConfigured]
       && ((self.secondaryTransportType == SDLSecondaryTransportTypeTCP && [self sdl_isTCPReady]) || (self.secondaryTransportType == SDLSecondaryTransportTypeIAP))) {
        [self.stateMachine transitionToState:SDLSecondaryTransportStateConnecting];
    }
}

@end

NS_ASSUME_NONNULL_END
