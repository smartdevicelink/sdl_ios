//
//  SDLStreamingAudioLifecycleManager.m
//  SmartDeviceLink
//
//  Created by Joel Fischer on 6/19/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import "SDLStreamingAudioLifecycleManager.h"

#import "SDLAudioStreamManager.h"
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
#import "SDLEncryptionConfiguration.h"
#import "SDLVehicleType.h"


NS_ASSUME_NONNULL_BEGIN

@interface SDLStreamingAudioLifecycleManager()

@property (strong, nonatomic, readwrite) SDLStateMachine *audioStreamStateMachine;
@property (assign, nonatomic, readonly, getter=isHmiStateAudioStreamCapable) BOOL hmiStateAudioStreamCapable;

@property (weak, nonatomic) id<SDLConnectionManagerType> connectionManager;
@property (weak, nonatomic) SDLProtocol *protocol;

@property (copy, nonatomic) NSArray<NSString *> *secureMakes;
@property (copy, nonatomic, nullable) NSString *connectedVehicleMake;

@property (nonatomic, copy, nullable) SDLAudioEndedCompletionHandler audioEndedCompletionHandler;

@end

@implementation SDLStreamingAudioLifecycleManager

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager streamingConfiguration:(SDLStreamingMediaConfiguration *)streamingConfiguration encryptionConfiguration:(SDLEncryptionConfiguration *)encryptionConfiguration {
    return [self initWithConnectionManager:connectionManager streamingConfiguration:streamingConfiguration encryptionConfiguration:encryptionConfiguration audioManager:nil];
}

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager streamingConfiguration:(SDLStreamingMediaConfiguration *)streamingConfiguration encryptionConfiguration:(SDLEncryptionConfiguration *)encryptionConfiguration audioManager:(nullable SDLAudioStreamManager *)audioManager {
    self = [super init];
    if (!self) {
        return nil;
    }

    SDLLogV(@"Creating AudioStreamingLifecycleManager");

    _connectionManager = connectionManager;
    _audioManager = audioManager != nil ? audioManager : [[SDLAudioStreamManager alloc] initWithManager:self];
    _requestedEncryptionType = streamingConfiguration.maximumDesiredEncryption;
    _connectedVehicleMake = nil;

    NSMutableArray<NSString *> *tempMakeArray = [NSMutableArray array];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    for (Class securityManagerClass in streamingConfiguration.securityManagers) {
        [tempMakeArray addObjectsFromArray:[securityManagerClass availableMakes].allObjects];
    }
#pragma clang diagnostic pop
    for (Class securityManagerClass in encryptionConfiguration.securityManagers) {
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
    _protocol = protocol;

    @synchronized(self.protocol.protocolDelegateTable) {
        if (![self.protocol.protocolDelegateTable containsObject:self]) {
            [self.protocol.protocolDelegateTable addObject:self];
        }
    }

    // attempt to start streaming since we may already have necessary conditions met
    [self sdl_startAudioSession];
}

/// Stops the manager when the device disconnects from the module. Since there is no connection between the device and the module there is no point in sending an end audio service control frame as the module will never receive the request.
- (void)stop {
    SDLLogD(@"Stopping audio streaming lifecycle manager");

    // Since the transport layer has been destroyed, destroy the protocol as it is not usable.
    _protocol = nil;

    // Reset the `hmiLevel`. This is done because we will not get a notification with the updated hmi status due to the transport being destroyed.
    _hmiLevel = SDLHMILevelNone;

    // Reset the `connectedVehicleMake` because we will get a `RegisterAppInterfaceResponse` when a new session is established between the device and a module. It is possible that the user could connect to different module during the same app session.
    _connectedVehicleMake = nil;

    // Stop the audio manager
    [_audioManager stop];

    [self.audioStreamStateMachine transitionToState:SDLAudioStreamManagerStateStopped];
}

// Stops the manager when audio needs to be stopped on the secondary transport. The primary transport is still open.
// 1. Since the primary transport is still open, do will not reset the `hmiLevel` since we can still get notifications from the module with the updated hmi status on the primary transport.
// 2. We need to send an end audio service control frame to the module to ensure that the audio session is shut down correctly. In order to do this the protocol must be kept open and only destroyed after the module ACKs or NAKs our end audio service request.
- (void)stopAudioWithCompletionHandler:(nullable SDLAudioEndedCompletionHandler)completionHandler {
    SDLLogD(@"Stopping audio streaming");
    self.audioEndedCompletionHandler = completionHandler;

    // Stop the audio manager from sending any more data
    [_audioManager stop];

    // Always send an end audio service control frame, regardless of whether video is streaming or not.
    [self.protocol endServiceWithType:SDLServiceTypeAudio];
}

/// Used internally to destroy the protocol after the secondary transport is shut down.
- (void)destroyProtocol {
    self.protocol = nil;
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

#pragma mark - SDLProtocolListener
#pragma mark Start Service ACK/NAK

- (void)handleProtocolStartServiceACKMessage:(SDLProtocolMessage *)startServiceACK {
    if (startServiceACK.header.serviceType != SDLServiceTypeAudio) { return; }

    SDLLogD(@"Request to start audio service ACKed");
    _audioEncrypted = startServiceACK.header.encrypted;

    SDLControlFramePayloadAudioStartServiceAck *audioAckPayload = [[SDLControlFramePayloadAudioStartServiceAck alloc] initWithData:startServiceACK.payload];

    if (audioAckPayload.mtu != SDLControlFrameInt64NotFound) {
        [[SDLGlobals sharedGlobals] setDynamicMTUSize:(NSUInteger)audioAckPayload.mtu forServiceType:SDLServiceTypeAudio];
    }

    [self.audioStreamStateMachine transitionToState:SDLAudioStreamManagerStateReady];
}

- (void)handleProtocolStartServiceNAKMessage:(SDLProtocolMessage *)startServiceNAK {
    if (startServiceNAK.header.serviceType != SDLServiceTypeAudio) { return; }
    SDLLogW(@"Request to start audio service NAKed");

    [self sdl_transitionToStoppedState:SDLServiceTypeAudio];
}

#pragma mark End Service ACK/NAK

- (void)handleProtocolEndServiceACKMessage:(SDLProtocolMessage *)endServiceACK {
    if (endServiceACK.header.serviceType != SDLServiceTypeAudio) { return; }

    SDLLogD(@"Request to end audio service ACKed");
    if (self.audioEndedCompletionHandler != nil) {
        self.audioEndedCompletionHandler(YES);
        self.audioEndedCompletionHandler = nil;
    }

    [self sdl_transitionToStoppedState:endServiceACK.header.serviceType];
}

- (void)handleProtocolEndServiceNAKMessage:(SDLProtocolMessage *)endServiceNAK {
    if (endServiceNAK.header.serviceType != SDLServiceTypeAudio) { return; }

    SDLLogW(@"Request to end audio service ACKed");
    if (self.audioEndedCompletionHandler != nil) {
        self.audioEndedCompletionHandler(NO);
        self.audioEndedCompletionHandler = nil;
    }

    [self sdl_transitionToStoppedState:endServiceNAK.header.serviceType];
}

#pragma mark - SDL RPC Notification callbacks

- (void)sdl_didReceiveRegisterAppInterfaceResponse:(SDLRPCResponseNotification *)notification {
    NSAssert([notification.response isKindOfClass:[SDLRegisterAppInterfaceResponse class]], @"A notification was sent with an unanticipated object");
    if (![notification.response isKindOfClass:[SDLRegisterAppInterfaceResponse class]]) {
        return;
    }

    SDLLogD(@"Received Register App Interface");
    SDLRegisterAppInterfaceResponse* registerResponse = (SDLRegisterAppInterfaceResponse*)notification.response;

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
    SDLLogV(@"Determining whether streaming is supported");
    _streamingSupported = registerResponse.hmiCapabilities.videoStreaming ? registerResponse.hmiCapabilities.videoStreaming.boolValue : registerResponse.displayCapabilities.graphicSupported.boolValue;
#pragma clang diagnostic pop

    if (!self.isStreamingSupported) {
        SDLLogE(@"Graphics are not supported on this head unit. We are are assuming screen size is also unavailable and exiting.");
        return;
    }

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

- (void)sdl_transitionToStoppedState:(SDLServiceType)serviceType {
    if (serviceType != SDLServiceTypeAudio) { return; }
    [self.audioStreamStateMachine transitionToState:SDLAudioStreamManagerStateStopped];
}

#pragma mark Setters / Getters

- (BOOL)isHmiStateAudioStreamCapable {
    return [self.hmiLevel isEqualToEnum:SDLHMILevelLimited] || [self.hmiLevel isEqualToEnum:SDLHMILevelFull];
}

@end

NS_ASSUME_NONNULL_END
