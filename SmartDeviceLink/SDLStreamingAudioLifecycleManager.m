//
//  SDLStreamingAudioLifecycleManager.m
//  SmartDeviceLink
//
//  Created by Joel Fischer on 6/19/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import "SDLStreamingAudioLifecycleManager.h"

#import "SDLAudioStreamManager.h"
#import "SDLConfiguration.h"
#import "SDLConnectionManagerType.h"
#import "SDLControlFramePayloadAudioStartServiceAck.h"
#import "SDLControlFramePayloadConstants.h"
#import "SDLControlFramePayloadNak.h"
#import "SDLDisplayCapabilities.h"
#import "SDLGlobals.h"
#import "SDLHMICapabilities.h"
#import "SDLLogMacros.h"
#import "SDLOnHMIStatus.h"
#import "SDLProtocol.h"
#import "SDLProtocolMessage.h"
#import "SDLPredefinedWindows.h"
#import "SDLRegisterAppInterfaceResponse.h"
#import "SDLRPCNotificationNotification.h"
#import "SDLRPCResponseNotification.h"
#import "SDLStateMachine.h"
#import "SDLStreamingMediaConfiguration.h"
#import "SDLSystemCapabilityManager.h"
#import "SDLEncryptionConfiguration.h"
#import "SDLVehicleType.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLStreamingAudioLifecycleManager()

@property (nonatomic, strong, readwrite) SDLAudioStreamManager *audioTranscodingManager;
@property (strong, nonatomic, readwrite) SDLStateMachine *audioStreamStateMachine;
@property (assign, nonatomic, readonly, getter=isHmiStateAudioStreamCapable) BOOL hmiStateAudioStreamCapable;

@property (weak, nonatomic) id<SDLConnectionManagerType> connectionManager;
@property (weak, nonatomic, nullable) SDLSystemCapabilityManager *systemCapabilityManager;
@property (weak, nonatomic) SDLProtocol *protocol;

@property (copy, nonatomic) NSArray<NSString *> *secureMakes;
@property (copy, nonatomic, nullable) NSString *connectedVehicleMake;
@property (assign, nonatomic, readwrite, getter=isAudioEncrypted) BOOL audioEncrypted;

@property (nonatomic, copy, nullable) void (^audioServiceEndedCompletionHandler)(void);
@end

@implementation SDLStreamingAudioLifecycleManager

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager configuration:(SDLConfiguration *)configuration systemCapabilityManager:(nullable SDLSystemCapabilityManager *)systemCapabilityManager {
    self = [super init];
    if (!self) {
        return nil;
    }

    _connectionManager = connectionManager;
    _audioTranscodingManager = [[SDLAudioStreamManager alloc] initWithManager:self];
    _systemCapabilityManager = systemCapabilityManager;
    _requestedEncryptionType = configuration.streamingMediaConfig.maximumDesiredEncryption;

    NSMutableArray<NSString *> *tempMakeArray = [NSMutableArray array];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    for (Class securityManagerClass in configuration.streamingMediaConfig.securityManagers) {
        [tempMakeArray addObjectsFromArray:[securityManagerClass availableMakes].allObjects];
    }
#pragma clang diagnostic pop
    for (Class securityManagerClass in configuration.encryptionConfig.securityManagers) {
        [tempMakeArray addObjectsFromArray:[securityManagerClass availableMakes].allObjects];
    }
    NSOrderedSet *tempMakeSet = [NSOrderedSet orderedSetWithArray:tempMakeArray];
    _secureMakes = [tempMakeSet.array copy];

    _audioStreamStateMachine = [[SDLStateMachine alloc] initWithTarget:self initialState:SDLAudioStreamManagerStateStopped states:[self.class sdl_audioStreamingStateTransitionDictionary]];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_didReceiveRegisterAppInterfaceResponse:) name:SDLDidReceiveRegisterAppInterfaceResponse object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_hmiLevelDidChange:) name:SDLDidChangeHMIStatusNotification object:nil];

    return self;
}

- (void)startWithProtocol:(SDLProtocol *)protocol {
    SDLLogD(@"Starting with protocol: %@", protocol);
    _protocol = protocol;

    @synchronized(self.protocol.protocolDelegateTable) {
        if (![self.protocol.protocolDelegateTable containsObject:self]) {
            [self.protocol.protocolDelegateTable addObject:self];
        }
    }

    // attempt to start streaming since we may already have necessary conditions met
    [self sdl_startAudioSession];
}

- (void)stop {
    SDLLogD(@"Stopping manager");
    _protocol = nil;
    _hmiLevel = SDLHMILevelNone;
    _connectedVehicleMake = nil;
    [self.audioTranscodingManager stop];

    [self.audioStreamStateMachine transitionToState:SDLAudioStreamManagerStateStopped];
}

- (void)secondaryTransportDidDisconnect {
    [self.audioStreamStateMachine transitionToState:SDLAudioStreamManagerStateStopped];
}

- (void)endAudioServiceWithCompletionHandler:(void (^)(void))audioEndedCompletionHandler {
    SDLLogD(@"Ending audio service");
    self.audioServiceEndedCompletionHandler = audioEndedCompletionHandler;

    [self.audioTranscodingManager stop];
    [self.protocol endServiceWithType:SDLServiceTypeAudio];
}

- (BOOL)sendAudioData:(NSData*)audioData {
    if (!self.isAudioConnected) {
        return NO;
    }

    SDLLogV(@"Sending raw audio data");
    if (self.isAudioEncrypted) {
        [self.protocol sendEncryptedRawData:audioData onService:SDLServiceTypeAudio];
    } else {
        [self.protocol sendRawData:audioData withServiceType:SDLServiceTypeAudio];
    }
    return YES;
}

#pragma mark Getters

- (BOOL)isAudioConnected {
    return [self.audioStreamStateMachine isCurrentState:SDLAudioStreamManagerStateReady];
}

- (SDLAudioStreamManagerState *)currentAudioStreamState {
    return self.audioStreamStateMachine.currentState;
}

#pragma mark - State Machine
+ (NSDictionary<SDLState *, SDLAllowableStateTransitions *> *)sdl_audioStreamingStateTransitionDictionary {
    return @{
             SDLAudioStreamManagerStateStopped : @[SDLAudioStreamManagerStateStarting],
             SDLAudioStreamManagerStateStarting : @[SDLAudioStreamManagerStateStopped, SDLAudioStreamManagerStateReady],
             SDLAudioStreamManagerStateReady : @[SDLAudioStreamManagerStateShuttingDown, SDLAudioStreamManagerStateStopped],
             SDLAudioStreamManagerStateShuttingDown : @[SDLAudioStreamManagerStateStopped]
             };
}

- (void)didEnterStateAudioStreamStopped {
    SDLLogD(@"Audio stream stopped");
    _audioEncrypted = NO;

    [[NSNotificationCenter defaultCenter] postNotificationName:SDLAudioStreamDidStopNotification object:nil];

    if (self.audioServiceEndedCompletionHandler != nil) {
        self.audioServiceEndedCompletionHandler();
        self.audioServiceEndedCompletionHandler = nil;
    }
}

- (void)didEnterStateAudioStreamStarting {
    SDLLogD(@"Audio stream starting");
    if ((self.requestedEncryptionType != SDLStreamingEncryptionFlagNone) && ([self.secureMakes containsObject:self.connectedVehicleMake])) {
        [self.protocol startSecureServiceWithType:SDLServiceTypeAudio payload:nil tlsInitializationHandler:^(BOOL success, NSError * _Nonnull error) {
            if (error) {
                SDLLogE(@"TLS setup error: %@", error);
                [self.audioStreamStateMachine transitionToState:SDLAudioStreamManagerStateStopped];
            }
        }];
    } else {
        [self.protocol startServiceWithType:SDLServiceTypeAudio payload:nil];
    }
}

- (void)didEnterStateAudioStreamReady {
    SDLLogD(@"Audio stream ready");
    [[NSNotificationCenter defaultCenter] postNotificationName:SDLAudioStreamDidStartNotification object:nil];
}

- (void)didEnterStateAudioStreamShuttingDown {
    SDLLogD(@"Audio stream shutting down");
    [self.protocol endServiceWithType:SDLServiceTypeAudio];
}

#pragma mark - SDLProtocolDelegate
#pragma mark Start Service ACK/NAK

- (void)protocol:(SDLProtocol *)protocol didReceiveStartServiceACK:(SDLProtocolMessage *)startServiceACK {
    if (startServiceACK.header.serviceType != SDLServiceTypeAudio) { return; }

    self.audioEncrypted = startServiceACK.header.encrypted;

    SDLControlFramePayloadAudioStartServiceAck *audioAckPayload = [[SDLControlFramePayloadAudioStartServiceAck alloc] initWithData:startServiceACK.payload];
    SDLLogD(@"Request to start audio service ACKed on transport %@, with payload: %@", protocol.transport, audioAckPayload);

    if (audioAckPayload.mtu != SDLControlFrameInt64NotFound) {
        [[SDLGlobals sharedGlobals] setDynamicMTUSize:(NSUInteger)audioAckPayload.mtu forServiceType:SDLServiceTypeAudio];
    }

    [self.audioStreamStateMachine transitionToState:SDLAudioStreamManagerStateReady];
}

- (void)protocol:(SDLProtocol *)protocol didReceiveStartServiceNAK:(SDLProtocolMessage *)startServiceNAK {
    if (startServiceNAK.header.serviceType != SDLServiceTypeAudio) { return; }
    
    SDLLogE(@"Request to start audio service NAKed on transport %@, with payload: %@", protocol.transport, startServiceNAK.payload);

    [self.audioStreamStateMachine transitionToState:SDLAudioStreamManagerStateStopped];
}

#pragma mark End Service ACK/NAK

- (void)protocol:(SDLProtocol *)protocol didReceiveEndServiceACK:(SDLProtocolMessage *)endServiceACK {
    if (endServiceACK.header.serviceType != SDLServiceTypeAudio) { return; }
    SDLLogD(@"Request to end audio service ACKed on transport %@", protocol.transport);

    [self.audioStreamStateMachine transitionToState:SDLAudioStreamManagerStateStopped];
}

- (void)protocol:(SDLProtocol *)protocol didReceiveEndServiceNAK:(SDLProtocolMessage *)endServiceNAK {
    if (endServiceNAK.header.serviceType != SDLServiceTypeAudio) { return; }

    SDLControlFramePayloadNak *nakPayload = [[SDLControlFramePayloadNak alloc] initWithData:endServiceNAK.payload];
    SDLLogE(@"Request to end audio service NAKed on transport %@, with payload: %@", protocol.transport, nakPayload);

    /// Core will NAK the audio end service control frame if audio is not streaming or if video is streaming but the HMI does not recognize that audio is streaming.
    [self.audioStreamStateMachine transitionToState:SDLAudioStreamManagerStateStopped];
}

#pragma mark - SDL RPC Notification callbacks

- (void)sdl_didReceiveRegisterAppInterfaceResponse:(SDLRPCResponseNotification *)notification {
    NSAssert([notification.response isKindOfClass:[SDLRegisterAppInterfaceResponse class]], @"A notification was sent with an unanticipated object");
    if (![notification.response isKindOfClass:[SDLRegisterAppInterfaceResponse class]]) {
        return;
    }

    SDLLogV(@"Received Register App Interface response");
    SDLRegisterAppInterfaceResponse *registerResponse = (SDLRegisterAppInterfaceResponse*)notification.response;

    self.connectedVehicleMake = registerResponse.vehicleType.make;
}

- (void)sdl_hmiLevelDidChange:(SDLRPCNotificationNotification *)notification {
    NSAssert([notification.notification isKindOfClass:[SDLOnHMIStatus class]], @"A notification was sent with an unanticipated object");
    if (![notification.notification isKindOfClass:[SDLOnHMIStatus class]]) {
        return;
    }

    SDLOnHMIStatus *hmiStatus = (SDLOnHMIStatus*)notification.notification;
    
    if (hmiStatus.windowID != nil && hmiStatus.windowID.integerValue != SDLPredefinedWindowsDefaultWindow) {
        return;
    }
    
    self.hmiLevel = hmiStatus.hmiLevel;

    // if startWithProtocol has not been called yet, abort here
    if (!self.protocol) { return; }

    if (self.isHmiStateAudioStreamCapable) {
        [self sdl_startAudioSession];
    } else {
        [self sdl_stopAudioSession];
    }
}

#pragma mark - Streaming session helpers

- (void)sdl_startAudioSession {
    SDLLogV(@"Attempting to start audio session");
    if (!self.protocol) {
        return;
    }

    if (!self.isStreamingSupported) {
        return;
    }

    if ([self.audioStreamStateMachine isCurrentState:SDLAudioStreamManagerStateStopped] && self.isHmiStateAudioStreamCapable) {
        [self.audioStreamStateMachine transitionToState:SDLAudioStreamManagerStateStarting];
    }
}

- (void)sdl_stopAudioSession {
    SDLLogV(@"Attempting to stop audio session");
    if (!self.isStreamingSupported) {
        return;
    }

    if (self.isAudioConnected) {
        [self.audioStreamStateMachine transitionToState:SDLAudioStreamManagerStateShuttingDown];
    }
}

#pragma mark Setters / Getters

- (BOOL)isHmiStateAudioStreamCapable {
    return [self.hmiLevel isEqualToEnum:SDLHMILevelLimited] || [self.hmiLevel isEqualToEnum:SDLHMILevelFull];
}

- (BOOL)isStreamingSupported {
    return (self.systemCapabilityManager != nil) ? [self.systemCapabilityManager isCapabilitySupported:SDLSystemCapabilityTypeVideoStreaming] : YES;
}

@end

NS_ASSUME_NONNULL_END
