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

@property (nonatomic, copy, nullable) void (^audioEndServiceReceivedHandler)(BOOL success);

@end

@implementation SDLStreamingAudioLifecycleManager

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager streamingConfiguration:(SDLStreamingMediaConfiguration *)streamingConfiguration encryptionConfiguration:(SDLEncryptionConfiguration *)encryptionConfiguration {
    self = [super init];
    if (!self) {
        return nil;
    }

    SDLLogV(@"Creating AudioStreamingLifecycleManager");

    _connectionManager = connectionManager;
    _audioManager = [[SDLAudioStreamManager alloc] initWithManager:self];
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

- (void)stop {
    SDLLogD(@"Stopping audio streaming lifecycle manager");
    _protocol = nil;
    _hmiLevel = SDLHMILevelNone;
    _connectedVehicleMake = nil;
    [self.audioStreamStateMachine transitionToState:SDLAudioStreamManagerStateStopped];
}

- (void)stopWithCompletionHandler:(nullable void(^)(BOOL success))completionHandler {
    self.audioEndServiceReceivedHandler = completionHandler;

    // Can't sent procol to `nil` else we will not get a response to the end audio service control frame

    // _hmiLevel = SDLHMILevelNone;
    _connectedVehicleMake = nil;

    [self.protocol endServiceWithType:SDLServiceTypeAudio];
//    if (self.isAudioConnected) {
//        [self.audioStreamStateMachine transitionToState:SDLAudioStreamManagerStateShuttingDown];
//    } else {
//        SDLLogV(@"No audio currently streaming. No need to send an end audio service request");
//        return completionHandler(NO);
//    }
}

- (void)closeProtocol {
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
#pragma mark Start Service ACK

- (void)handleProtocolStartServiceACKMessage:(SDLProtocolMessage *)startServiceACK {
    if (startServiceACK.header.serviceType != SDLServiceTypeAudio) { return; }
    [self sdl_handleAudioStartServiceAck:startServiceACK];
}

- (void)sdl_handleAudioStartServiceAck:(SDLProtocolMessage *)audioStartServiceAck {
    SDLLogW(@"Audio start ACKed");
    //SDLLogD(@"Audio service started");
    _audioEncrypted = audioStartServiceAck.header.encrypted;

    SDLControlFramePayloadAudioStartServiceAck *audioAckPayload = [[SDLControlFramePayloadAudioStartServiceAck alloc] initWithData:audioStartServiceAck.payload];
    //SDLLogV(@"ACK: %@", audioAckPayload);

    if (audioAckPayload.mtu != SDLControlFrameInt64NotFound) {
        [[SDLGlobals sharedGlobals] setDynamicMTUSize:(NSUInteger)audioAckPayload.mtu forServiceType:SDLServiceTypeAudio];
    }

    [self.audioStreamStateMachine transitionToState:SDLAudioStreamManagerStateReady];
}

#pragma mark Start Service NAK

- (void)handleProtocolStartServiceNAKMessage:(SDLProtocolMessage *)startServiceNAK {
    if (startServiceNAK.header.serviceType != SDLServiceTypeAudio) { return; }
    [self sdl_handleAudioStartServiceNak:startServiceNAK];
}

- (void)sdl_handleAudioStartServiceNak:(SDLProtocolMessage *)audioStartServiceNak {
    SDLLogW(@"Audio start NAKed");
    //SDLLogW(@"Audio service failed to start due to NAK");
    [self sdl_transitionToStoppedState:SDLServiceTypeAudio];
}

#pragma mark End Service

- (void)handleProtocolEndServiceACKMessage:(SDLProtocolMessage *)endServiceACK {
    if (endServiceACK.header.serviceType != SDLServiceTypeAudio) { return; }
    SDLLogW(@"Audio end ACKed");
    //SDLLogD(@"Audio service ended successfully");

    if (self.audioEndServiceReceivedHandler != nil) {
        self.audioEndServiceReceivedHandler(YES);
        self.audioEndServiceReceivedHandler = nil;
    }

    [self sdl_transitionToStoppedState:endServiceACK.header.serviceType];
}

- (void)handleProtocolEndServiceNAKMessage:(SDLProtocolMessage *)endServiceNAK {
    if (endServiceNAK.header.serviceType != SDLServiceTypeAudio) { return; }
    SDLLogW(@"Audio end NAKed");
    //SDLLogE(@"Audio service did not end successfully");

    if (self.audioEndServiceReceivedHandler != nil) {
        self.audioEndServiceReceivedHandler(NO);
        self.audioEndServiceReceivedHandler = nil;
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
