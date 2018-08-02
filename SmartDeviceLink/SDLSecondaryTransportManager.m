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

#import "SDLControlFramePayloadConstants.h"
#import "SDLControlFramePayloadRPCStartServiceAck.h"
#import "SDLControlFramePayloadTransportEventUpdate.h"
#import "SDLIAPTransport.h"
#import "SDLLogMacros.h"
#import "SDLNotificationConstants.h"
#import "SDLProtocol.h"
#import "SDLProtocolHeader.h"
#import "SDLProtocolMessage.h"
#import "SDLSecondaryTransportManagerConstants.h"
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

// Timeout for receiving Register Secondary Transport ACK frame
static const float RegisterTransportTime = 10.0;

// Delay to retry connection after secondary transport is disconnected or registration is failed
static const float RetryConnectionDelay = 15.0;


/** An internal class to receive event from primary transport. */
@interface PrimaryProtocolListener : NSObject <SDLProtocolListener>

@property (weak, nonatomic) SDLProtocol *primaryProtocol;
@property (copy, nonatomic) SDLProtocolHeader *primaryRPCHeader;

@end

@implementation PrimaryProtocolListener

- (instancetype)initWithProtocol:(SDLProtocol *)primaryProtocol {
    self = [super init];
    if (!self) {
        return nil;
    }

    _primaryProtocol = primaryProtocol;

    return self;
}

- (void)start {
    @synchronized(self.primaryProtocol.protocolDelegateTable) {
        [self.primaryProtocol.protocolDelegateTable addObject:self];
    }
}

- (void)stop {
    @synchronized(self.primaryProtocol.protocolDelegateTable) {
        [self.primaryProtocol.protocolDelegateTable removeObject:self];
    }
}

// called from protocol's _reeiveQueue of Primary Transport
- (void)handleProtocolStartServiceACKMessage:(SDLProtocolMessage *)startServiceACK {
    if (startServiceACK.header.serviceType != SDLServiceTypeRPC) {
        return;
    }

    SDLLogV(@"Received Start Service ACK header of RPC service on primary transport");

    // keep header to acquire Session ID
    self.primaryRPCHeader = startServiceACK.header;

    SDLControlFramePayloadRPCStartServiceAck *payload = [[SDLControlFramePayloadRPCStartServiceAck alloc] initWithData:startServiceACK.payload];

    NSDictionary<NSString *, id> *userInfo = @{SDLNotificationUserInfoObject: payload};
    [[NSNotificationCenter defaultCenter] postNotificationName:SDLStartSecondaryTransportManagerNotification object:self userInfo:userInfo];
}

// called from protocol's _reeiveQueue of Primary Transport
- (void)handleTransportEventUpdateMessage:(SDLProtocolMessage *)transportEventUpdate {

    SDLControlFramePayloadTransportEventUpdate *payload = [[SDLControlFramePayloadTransportEventUpdate alloc] initWithData:transportEventUpdate.payload];
    SDLLogV(@"Transport Config Update: %@", payload);

    NSDictionary<NSString *, id> *userInfo = @{SDLNotificationUserInfoObject: payload};
    [[NSNotificationCenter defaultCenter] postNotificationName:SDLTransportEventUpdateNotification object:self userInfo:userInfo];
}

@end

@interface SDLSecondaryTransportManager ()

// State of this manager.
@property (strong, nonatomic, readwrite) SDLStateMachine *stateMachine;
// Dedicated queue that the state machine will run on.
@property (copy, nonatomic) dispatch_queue_t stateMachineQueue;

// Instance of the protocol that runs on primary transport.
@property (weak, nonatomic) SDLProtocol *primaryProtocol;
// A sub-class to catch Start Service ACK and Transport Config Update frames.
@property (strong, nonatomic) PrimaryProtocolListener *primaryProtocolListener;

// Selected type of secondary transport. If 'SDLTransportSelectionDisabled' then secondary transport is disabled.
@property (assign, nonatomic) SDLSecondaryTransportType transportSelection;
// Instance of the transport for secondary transport.
@property (nullable, strong, nonatomic) id<SDLTransportType> secondaryTransport;
// Instance of the protocol that runs on secondary transport.
@property (nullable, strong, nonatomic) SDLProtocol *secondaryProtocol;
// Timer to check Register Secondary Transport ACK response on secondary transport.
@property (strong, nonatomic, nullable) SDLTimer *registerTransportTimer;

// A listener to notify protocol change.
@property (weak, nonatomic) id<SDLStreamingProtocolListener> streamingProtocolListener;

// Configuration sent by system; list of transports that are allowed to carry audio service
@property (strong, nonatomic, nullable) NSArray<SDLTransportClassBox *> *transportsForAudioService;
// Configuration sent by system; list of transports that are allowed to carry video service
@property (strong, nonatomic, nullable) NSArray<SDLTransportClassBox *> *transportsForVideoService;
// A map to remember which service is currently running on which transport
@property (strong, nonatomic) NSMutableDictionary<SDLServiceTypeBox *, SDLTransportClassBox *> *streamingServiceTransportMap;

// IP address of SDL Core (either IPv4 or IPv6 address)
@property (strong, nonatomic, nullable) NSString *ipAddress;
// TCP port number of SDL Core. -1 if the information isn't available
@property (assign, nonatomic) int tcpPort;

@end

@implementation SDLSecondaryTransportManager

#pragma mark - Public

- (instancetype)initWithStreamingProtocolListener:(id<SDLStreamingProtocolListener>)streamingProtocolListener {
    self = [super init];
    if (!self) {
        return nil;
    }

    _stateMachine = [[SDLStateMachine alloc] initWithTarget:self initialState:SDLSecondaryTransportStateStopped states:[self.class sdl_stateTransitionDictionary]];
    _stateMachineQueue = dispatch_queue_create("com.sdl.secondarytransportmanager", DISPATCH_QUEUE_SERIAL);
    _streamingProtocolListener = streamingProtocolListener;

    _transportSelection = SDLSecondaryTransportTypeDisabled;
    _streamingServiceTransportMap = [@{@(SDLServiceTypeAudio):@(SDLTransportClassInvalid),
                            @(SDLServiceTypeVideo):@(SDLTransportClassInvalid)} mutableCopy];
    _tcpPort = -1;

    return self;
}

- (void)startWithPrimaryProtocol:(SDLProtocol *)primaryProtocol {
    SDLLogD(@"SDLSecondaryTransportManager start");

    dispatch_sync(_stateMachineQueue, ^{
        if (![self.stateMachine isCurrentState:SDLSecondaryTransportStateStopped]) {
            SDLLogW(@"Secondary transport manager is already started!");
            return;
        }

        self.primaryProtocol = primaryProtocol;
        self.primaryProtocolListener = [[PrimaryProtocolListener alloc] initWithProtocol:primaryProtocol];

        [self.stateMachine transitionToState:SDLSecondaryTransportStateStarted];
    });
}

- (void)stop {
    SDLLogD(@"SDLSecondaryTransportManager stop");

    dispatch_sync(_stateMachineQueue, ^{
        // stop all services, including those running on primary transport
        SDLLogD(@"Stopping audio / video services on both transports");
        [self sdl_handleTransportUpdate:NO secondaryAvailable:NO];

        [self.stateMachine transitionToState:SDLSecondaryTransportStateStopped];
    });
}

- (void)dealloc {
    SDLLogD(@"SDLSecondaryTransportManager dealloc");
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
    [self sdl_stopManager];
}

- (void)didEnterStateStarted {
    [self sdl_startManager];
}

- (void)didEnterStateConfigured {
    if ((self.transportSelection == SDLSecondaryTransportTypeTCP && [self sdl_isTCPReady])
        || self.transportSelection == SDLSecondaryTransportTypeIAP) {
        [self.stateMachine transitionToState:SDLSecondaryTransportStateConnecting];
    }
}

- (void)didEnterStateConnecting {
    [self sdl_connectSecondaryTransport];
}

- (void)willLeaveStateConnecting {
    // make sure to terminate the timer, which is only used in Connecting state
    [self.registerTransportTimer cancel];
    self.registerTransportTimer = nil;
}

- (void)willTransitionFromStateConnectingToStateConfigured {
    [self sdl_disconnectSecondaryTransport];
}

- (void)willTransitionFromStateConnectingToStateReconnecting {
    [self sdl_disconnectSecondaryTransport];
}

- (void)willTransitionFromStateConnectingToStateStopped {
    [self sdl_disconnectSecondaryTransport];
}

- (void)didEnterStateRegistered {
    [self sdl_handleTransportUpdate:YES secondaryAvailable:YES];
}

- (void)willTransitionFromStateRegisteredToStateConfigured {
    // before disconnecting Secondary Transport, stop running services
    SDLLogD(@"Stopping services on secondary transport");
    [self sdl_handleTransportUpdate:YES secondaryAvailable:NO];

    [self sdl_disconnectSecondaryTransport];
}

- (void)willTransitionFromStateRegisteredToStateReconnecting {
    SDLLogD(@"Stopping services on secondary transport");
    [self sdl_handleTransportUpdate:YES secondaryAvailable:NO];

    [self sdl_disconnectSecondaryTransport];
}

- (void)willTransitionFromStateRegisteredToStateStopped {
    // sdl_handleTransportUpdate is called in stop method
    [self sdl_disconnectSecondaryTransport];
}

- (void)didEnterStateReconnecting {
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(RetryConnectionDelay * NSEC_PER_SEC)), _stateMachineQueue, ^{
        if ([weakSelf.stateMachine isCurrentState:SDLSecondaryTransportStateReconnecting]) {
            SDLLogD(@"Retry secondary transport after disconnection or registration failure");
            [self.stateMachine transitionToState:SDLSecondaryTransportStateConfigured];
        }
    });
}

- (void)sdl_startManager {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_onStartServiceACKReceived:) name:SDLStartSecondaryTransportManagerNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_onTransportEventUpdate:) name:SDLTransportEventUpdateNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_onAppStateUpdated:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_onAppStateUpdated:) name:UIApplicationWillResignActiveNotification object:nil];

    [self.primaryProtocolListener start];
}

- (void)sdl_stopManager {
    SDLLogD(@"SDLSecondaryTransportManager stop");

    [[NSNotificationCenter defaultCenter] removeObserver:self name:SDLStartSecondaryTransportManagerNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SDLTransportEventUpdateNotification object:nil];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];

    [self.primaryProtocolListener stop];

    self.streamingServiceTransportMap = [@{@(SDLServiceTypeAudio):@(SDLTransportClassInvalid),
                                @(SDLServiceTypeVideo):@(SDLTransportClassInvalid)} mutableCopy];
    self.transportSelection = SDLSecondaryTransportTypeDisabled;
    self.transportsForAudioService = nil;
    self.transportsForVideoService = nil;

    self.ipAddress = nil;
    self.tcpPort = -1;
}

- (void)sdl_configureManager:(nullable NSArray<SDLSecondaryTransportTypeBox *> *)secondaryTransports
          transportsForAudio:(nullable NSArray<SDLTransportClassBox *> *)transportsForAudio
          transportsForVideo:(nullable NSArray<SDLTransportClassBox *> *)transportsForVideo {
    if (![self.stateMachine isCurrentState:SDLSecondaryTransportStateStarted]) {
        SDLLogW(@"SecondaryTransportManager ignores duplicate Start Service ACK frame");
        return;
    }

    SDLSecondaryTransportType secondaryTransportSelection;
    if (secondaryTransports == nil || [secondaryTransports count] == 0) {
        SDLLogW(@"Did not receive secondary transport type from system. Secondary transport is disabled.");
        secondaryTransportSelection = SDLSecondaryTransportTypeDisabled;
    } else {
        // current proposal says the list should contain only one element
        SDLSecondaryTransportTypeBox *transportSelection = [secondaryTransports objectAtIndex:0];
        secondaryTransportSelection = [transportSelection integerValue];
    }

    SDLSecondaryTransportType primaryTransportSelection = [self sdl_getTransportSelectionFromProtocol:self.primaryProtocol];
    if (primaryTransportSelection == secondaryTransportSelection) {
        SDLLogW(@"Same transport is specified for both primary and secondary transport. Secondary transport is disabled.");
        secondaryTransportSelection = SDLSecondaryTransportTypeDisabled;
        // clear out these values, so that audio and video services will start on primary transport
        transportsForAudio = nil;
        transportsForVideo = nil;
    } else if (secondaryTransportSelection == SDLSecondaryTransportTypeIAP) {
        SDLLogW(@"Starting IAP as secondary transport, which does not usually happen");
    }

    self.transportSelection = secondaryTransportSelection;
    self.transportsForAudioService = transportsForAudio;
    self.transportsForVideoService = transportsForVideo;

    // this will trigger audio / video streaming if they are allowed on primary transport
    [self sdl_handleTransportUpdate:YES secondaryAvailable:NO];

    [self.stateMachine transitionToState:SDLSecondaryTransportStateConfigured];
}

- (void)sdl_handleTransportEventUpdate {
    if ([self.stateMachine isCurrentState:SDLSecondaryTransportStateStarted]) {
        // The system sent Transport Event Update frame prior to Start Service ACK! Just keep the information and do nothing here.
        SDLLogD(@"Received TCP transport information prior to Start Service ACK");
        return;
    }
    if (self.transportSelection != SDLSecondaryTransportTypeTCP) {
        return;
    }

    if ([self.stateMachine isCurrentState:SDLSecondaryTransportStateConfigured] && [self sdl_isTCPReady]) {
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

- (void)sdl_handleTransportRegistered {
    // secondary transport is now ready
    [self.stateMachine transitionToState:SDLSecondaryTransportStateRegistered];
}

- (void)sdl_handleTransportRegisterFailed {
    [self.stateMachine transitionToState:SDLSecondaryTransportStateReconnecting];
}

- (void)sdl_handleTransportRegisterTimeout {
    // if the state is still Connecting, go back to Configured state and retry immediately
    if ([self.stateMachine isCurrentState:SDLSecondaryTransportStateConnecting]) {
        SDLLogD(@"Retry secondary transport connection after registration timeout");
        [self.stateMachine transitionToState:SDLSecondaryTransportStateConfigured];
    }
}

- (void)sdl_handleProtocolClosed {
    if ([self sdl_isTransportOpened]) {
        [self.stateMachine transitionToState:SDLSecondaryTransportStateReconnecting];
    }
}

- (void)sdl_handleAppBecomeActive {
    if (([self.stateMachine isCurrentState:SDLSecondaryTransportStateConfigured])
        && self.transportSelection == SDLSecondaryTransportTypeTCP && [self sdl_isTCPReady]) {
        SDLLogD(@"Resuming TCP transport since the app becomes foreground");
        [self.stateMachine transitionToState:SDLSecondaryTransportStateConnecting];
    }
}

- (void)sdl_handleAppResignedActive {
    if ([self sdl_isTransportOpened] && self.transportSelection == SDLSecondaryTransportTypeTCP) {
        SDLLogD(@"Disconnecting TCP transport since the app will go to background");
        [self.stateMachine transitionToState:SDLSecondaryTransportStateConfigured];
    }
}

- (BOOL)sdl_isTransportOpened {
    return [self.stateMachine isCurrentState:SDLSecondaryTransportStateConnecting]
    || [self.stateMachine isCurrentState:SDLSecondaryTransportStateRegistered];
}


#pragma mark - Starting / Stopping / Restarting services

- (void)sdl_handleTransportUpdate:(BOOL)primaryAvailable secondaryAvailable:(BOOL)secondaryAvailable {
    // update audio service
    [self sdl_updateService:SDLServiceTypeAudio
          allowedTransports:self.transportsForAudioService
           primaryAvailable:primaryAvailable
         secondaryAvailable:secondaryAvailable
      transportUpdatedBlock:^(SDLProtocol * _Nullable oldProtocol, SDLProtocol * _Nullable newProtocol) {
          [self.streamingProtocolListener audioServiceProtocolDidUpdateFromOldProtocol:oldProtocol toNewProtocol:newProtocol];
      }];

    // update video service
    [self sdl_updateService:SDLServiceTypeVideo
          allowedTransports:self.transportsForVideoService
           primaryAvailable:primaryAvailable
         secondaryAvailable:secondaryAvailable
      transportUpdatedBlock:^(SDLProtocol * _Nullable oldProtocol, SDLProtocol * _Nullable newProtocol) {
          [self.streamingProtocolListener videoServiceProtocolDidUpdateFromOldProtocol:oldProtocol toNewProtocol:newProtocol];
      }];
}

- (void)sdl_updateService:(UInt8)service
        allowedTransports:(nullable NSArray<SDLTransportClassBox *> *)transportList
         primaryAvailable:(BOOL)primaryTransportAvailable
       secondaryAvailable:(BOOL)secondaryTransportAvailable
    transportUpdatedBlock:(void (^)(SDLProtocol * _Nullable oldProtocol, SDLProtocol * _Nullable newProtocol))transportUpdatedBlock {
    if (transportList == nil) {
        // SDL Core did not send transport list for this service. Let's start it on Primary Transport for safe.
        SDLLogW(@"Transport for service 0x%2X is not specified by the system, using primary transport", service);
        transportList = @[@(SDLTransportClassPrimary)];
    }

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

        transportUpdatedBlock([self sdl_getProtocolFromTransportClass:oldTransport],
                              [self sdl_getProtocolFromTransportClass:newTransport]);
    }
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


#pragma mark - Start Service ACK notification implementation

// called from SDLProtocol's _receiveQueue of "primary" transport
- (void)sdl_onStartServiceACKReceived:(NSNotification *)notification {
    NSAssert([notification.userInfo[SDLNotificationUserInfoObject] isKindOfClass:[SDLControlFramePayloadRPCStartServiceAck class]], @"Unexpected type of object in the notification");

    SDLControlFramePayloadRPCStartServiceAck *payload = notification.userInfo[SDLNotificationUserInfoObject];

    NSMutableArray<SDLSecondaryTransportTypeBox *> *secondaryTransports = nil;
    if (payload.secondaryTransports != nil) {
        secondaryTransports = [NSMutableArray array];
        for (NSString *transportString in payload.secondaryTransports) {
            SDLSecondaryTransportType transport = [self sdl_convertTransportSelection:transportString];
            [secondaryTransports addObject:@(transport)];
        }
    }
    NSArray<SDLTransportClassBox *> *transportsForAudio = [self sdl_convertServiceTransports:payload.audioServiceTransports];
    NSArray<SDLTransportClassBox *> *transportsForVideo = [self sdl_convertServiceTransports:payload.videoServiceTransports];

    SDLLogV(@"Secondary transports: %@, transports for audio: %@, transports for video: %@", secondaryTransports, transportsForAudio, transportsForVideo);

    dispatch_async(_stateMachineQueue, ^{
        [self sdl_configureManager:secondaryTransports transportsForAudio:transportsForAudio transportsForVideo:transportsForVideo];
    });
}

- (SDLSecondaryTransportType)sdl_convertTransportSelection:(NSString *)transportString {
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
    NSMutableArray<SDLTransportClassBox *> *array = [NSMutableArray new];
    for (NSNumber *num in transports) {
        int transport = [num intValue];
        if (transport == 1) {
            [array addObject:@(SDLTransportClassPrimary)];
        } else if (transport == 2) {
            [array addObject:@(SDLTransportClassSecondary)];
        } else {
            SDLLogV(@"Unknown transport class received: %d", transport);
        }
    }

    return [array copy];
}

- (SDLSecondaryTransportType)sdl_getTransportSelectionFromProtocol:(SDLProtocol *)protocol {
    if ([protocol.transport isMemberOfClass:[SDLIAPTransport class]]) {
        return SDLSecondaryTransportTypeIAP;
    } else if ([protocol.transport isMemberOfClass:[SDLTCPTransport class]]) {
        return SDLSecondaryTransportTypeTCP;
    } else {
        SDLLogD(@"Unknown type of primary transport");
        return SDLSecondaryTransportTypeDisabled;
    }
}


#pragma mark - TransportEventUpdate notification implementation

// called from SDLProtocol's _receiveQueue of "primary" transport
- (void)sdl_onTransportEventUpdate:(NSNotification *)notification {
    NSAssert([notification.userInfo[SDLNotificationUserInfoObject] isKindOfClass:[SDLControlFramePayloadTransportEventUpdate class]], @"Unexpected type of object in the notification");

    SDLControlFramePayloadTransportEventUpdate *payload = notification.userInfo[SDLNotificationUserInfoObject];

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


#pragma mark - Transport management

// try establishing secondary transport. Returns NO if failed
- (BOOL)sdl_connectSecondaryTransport {
    if (self.secondaryTransport != nil) {
        SDLLogW(@"Secondary transport is already started.");
        return NO;
    }

    switch (self.transportSelection) {
        case SDLSecondaryTransportTypeTCP:
            return [self sdl_startTCPSecondaryTransport];
        case SDLSecondaryTransportTypeIAP:
            return [self sdl_startIAPSecondaryTransport];
        default:
            SDLLogW(@"Unknown transport type for secondary transport: %ld", (long)self.transportSelection);
            return NO;
    }
}

- (BOOL)sdl_disconnectSecondaryTransport {
    if (self.secondaryTransport == nil) {
        SDLLogD(@"Secondary transport is already stopped.");
        return NO;
    }

    SDLLogD(@"Disconnect secondary transport");
    [self.secondaryTransport disconnect];
    self.secondaryTransport = nil;

    return YES;
}

- (BOOL)sdl_startTCPSecondaryTransport {
    if (![self sdl_isTCPReady]) {
        SDLLogD(@"Cannot start TCP secondary transport");
        return NO;
    }

    SDLLogD(@"Starting TCP Secondary Transport (IP address = \"%@\", port = \"%d\")", self.ipAddress, self.tcpPort);

    SDLTCPTransport *transport = [[SDLTCPTransport alloc] init];
    transport.hostName = self.ipAddress;
    transport.portNumber = [NSString stringWithFormat:@"%d", self.tcpPort];
    SDLProtocol *protocol = [[SDLProtocol alloc] init];
    transport.delegate = protocol;
    protocol.transport = transport;
    [protocol.protocolDelegateTable addObject:self];

    self.secondaryProtocol = protocol;
    self.secondaryTransport = transport;

    // we reuse Session ID acquired from primary transport's protocol
    // this is for Register Secondary Transport frame
    [self.secondaryProtocol storeHeader:self.primaryProtocolListener.primaryRPCHeader forServiceType:SDLServiceTypeControl];
    // this is for video and audio services
    [self.secondaryProtocol storeHeader:self.primaryProtocolListener.primaryRPCHeader forServiceType:SDLServiceTypeRPC];

    [self.secondaryTransport connect];
    return YES;
}

- (BOOL)sdl_startIAPSecondaryTransport {
    SDLLogD(@"Starting Secondary Transport: iAP");

    SDLIAPTransport *transport = [[SDLIAPTransport alloc] init];
    SDLProtocol *protocol = [[SDLProtocol alloc] init];
    transport.delegate = protocol;
    protocol.transport = transport;
    [protocol.protocolDelegateTable addObject:self];

    self.secondaryProtocol = protocol;
    self.secondaryTransport = transport;

    // we reuse Session ID acquired from primary transport's protocol
    // this is for Register Secondary Transport frame
    [self.secondaryProtocol storeHeader:self.primaryProtocolListener.primaryRPCHeader forServiceType:SDLServiceTypeControl];
    // this is for video and audio services
    [self.secondaryProtocol storeHeader:self.primaryProtocolListener.primaryRPCHeader forServiceType:SDLServiceTypeRPC];

    [self.secondaryTransport connect];
    return YES;
}

- (BOOL)sdl_isTCPReady {
    if ([self.ipAddress length] == 0) {
        SDLLogD(@"IP address is empty");
        return NO;
    }
    if (self.tcpPort < 0) {
        SDLLogD(@"TCP port number is not available");
        return NO;
    }
    if (!(self.tcpPort > 0 && self.tcpPort <= 65535)) {
        SDLLogW(@"Invalid TCP port number for secondary transport: %d", self.tcpPort);
        return NO;
    }

    if ([self sdl_getAppState] != UIApplicationStateActive) {
        SDLLogD(@"App state is not Active, abort starting TCP transport");
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
            [weakSelf sdl_handleTransportRegisterTimeout];
        });
    };
    [self.registerTransportTimer start];

    [self.secondaryProtocol registerSecondaryTransport:nil];
}

// called on transport's thread, notifying that the transport is disconnected
// (Note: when transport's disconnect method is called, this method will not be called)
- (void)onProtocolClosed {
    SDLLogD(@"secondary transport disconnected");

    dispatch_async(self.stateMachineQueue, ^{
        [self sdl_handleProtocolClosed];
    });
}

// called from SDLProtocol's _receiveQueue of secondary transport
- (void)handleProtocolRegisterSecondaryTransportACKMessage:(SDLProtocolMessage *)registerSecondaryTransportACK {
    SDLLogD(@"Received Register Secondary Transport ACK frame");

    dispatch_async(self.stateMachineQueue, ^{
        [self sdl_handleTransportRegistered];
    });
}

// called from SDLProtocol's _receiveQueue of secondary transport
- (void)handleProtocolRegisterSecondaryTransportNAKMessage:(SDLProtocolMessage *)registerSecondaryTransportNAK {
    SDLLogW(@"Received Register Secondary Transport NAK frame");

    dispatch_async(self.stateMachineQueue, ^{
        [self sdl_handleTransportRegisterFailed];
    });
}

#pragma mark - App state handling

- (void)sdl_onAppStateUpdated:(NSNotification *)notification {
    dispatch_async(_stateMachineQueue, ^{
        if (notification.name == UIApplicationWillResignActiveNotification) {
            [self sdl_handleAppResignedActive];
        } else if (notification.name == UIApplicationDidBecomeActiveNotification) {
            [self sdl_handleAppBecomeActive];
        }
    });
}

@end

NS_ASSUME_NONNULL_END
