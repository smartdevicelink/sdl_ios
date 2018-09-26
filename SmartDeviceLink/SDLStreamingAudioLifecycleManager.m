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
#import "SDLRegisterAppInterfaceResponse.h"
#import "SDLRPCNotificationNotification.h"
#import "SDLRPCResponseNotification.h"
#import "SDLStateMachine.h"
#import "SDLStreamingMediaConfiguration.h"
#import "SDLVehicleType.h"


NS_ASSUME_NONNULL_BEGIN

@interface SDLStreamingAudioLifecycleManager()

@property (strong, nonatomic, readwrite) SDLStateMachine *appStateMachine;
@property (strong, nonatomic, readwrite) SDLStateMachine *audioStreamStateMachine;
@property (assign, nonatomic, readonly, getter=isHmiStateAudioStreamCapable) BOOL hmiStateAudioStreamCapable;

@property (weak, nonatomic) id<SDLConnectionManagerType> connectionManager;
@property (weak, nonatomic) SDLProtocol *protocol;

@property (copy, nonatomic) NSArray<NSString *> *secureMakes;
@property (copy, nonatomic) NSString *connectedVehicleMake;

@end

@implementation SDLStreamingAudioLifecycleManager

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager configuration:(SDLStreamingMediaConfiguration *)configuration {
    self = [super init];
    if (!self) {
        return nil;
    }

    SDLLogV(@"Creating AudioStreamingLifecycleManager");

    _connectionManager = connectionManager;

    _audioManager = [[SDLAudioStreamManager alloc] initWithManager:self];

    _requestedEncryptionType = configuration.maximumDesiredEncryption;

    NSMutableArray<NSString *> *tempMakeArray = [NSMutableArray array];
    for (Class securityManagerClass in configuration.securityManagers) {
        [tempMakeArray addObjectsFromArray:[securityManagerClass availableMakes].allObjects];
    }
    _secureMakes = [tempMakeArray copy];

    SDLAppState *initialState = SDLAppStateInactive;
    switch ([[UIApplication sharedApplication] applicationState]) {
        case UIApplicationStateActive: {
            initialState = SDLAppStateActive;
        } break;
        case UIApplicationStateInactive: // fallthrough
        case UIApplicationStateBackground: {
            initialState = SDLAppStateInactive;
        } break;
        default: break;
    }

    _appStateMachine = [[SDLStateMachine alloc] initWithTarget:self initialState:initialState states:[self.class sdl_appStateTransitionDictionary]];
    _audioStreamStateMachine = [[SDLStateMachine alloc] initWithTarget:self initialState:SDLAudioStreamManagerStateStopped states:[self.class sdl_audioStreamingStateTransitionDictionary]];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_didReceiveRegisterAppInterfaceResponse:) name:SDLDidReceiveRegisterAppInterfaceResponse object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_hmiLevelDidChange:) name:SDLDidChangeHMIStatusNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_appStateDidUpdate:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_appStateDidUpdate:) name:UIApplicationWillResignActiveNotification object:nil];

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
    SDLLogD(@"Stopping manager");
    [self sdl_stopAudioSession];

    self.hmiLevel = SDLHMILevelNone;

    [self.audioStreamStateMachine transitionToState:SDLAudioStreamManagerStateStopped];
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

- (SDLAppState *)currentAppState {
    return self.appStateMachine.currentState;
}

- (SDLAudioStreamManagerState *)currentAudioStreamState {
    return self.audioStreamStateMachine.currentState;
}

#pragma mark - State Machines
#pragma mark App State
+ (NSDictionary<SDLState *, SDLAllowableStateTransitions *> *)sdl_appStateTransitionDictionary {
    return @{
             // Will go from Inactive to Active if coming from a Phone Call.
             // Will go from Inactive to IsRegainingActive if coming from Background.
             SDLAppStateInactive : @[SDLAppStateActive],
             SDLAppStateActive : @[SDLAppStateInactive]
             };
}

- (void)sdl_appStateDidUpdate:(NSNotification*)notification {
    if (notification.name == UIApplicationWillResignActiveNotification) {
        [self.appStateMachine transitionToState:SDLAppStateInactive];
    } else if (notification.name == UIApplicationDidBecomeActiveNotification) {
        [self.appStateMachine transitionToState:SDLAppStateActive];
    }
}

- (void)didEnterStateAppInactive {
    SDLLogD(@"App became inactive");
    [self sdl_stopAudioSession];
}

// Per Apple's guidelines: https://developer.apple.com/library/content/documentation/iPhone/Conceptual/iPhoneOSProgrammingGuide/StrategiesforHandlingAppStateTransitions/StrategiesforHandlingAppStateTransitions.html
// We should be waiting to start any OpenGL drawing until UIApplicationDidBecomeActive is called.
- (void)didEnterStateAppActive {
    SDLLogD(@"App became active");
    [self sdl_startAudioSession];
}

#pragma mark Audio
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
        [self.protocol startSecureServiceWithType:SDLServiceTypeAudio payload:nil completionHandler:^(BOOL success, NSError * _Nonnull error) {
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
#pragma mark Video / Audio Start Service ACK

- (void)handleProtocolStartServiceACKMessage:(SDLProtocolMessage *)startServiceACK {
    switch (startServiceACK.header.serviceType) {
        case SDLServiceTypeAudio: {
            [self sdl_handleAudioStartServiceAck:startServiceACK];
        } break;
        default: break;
    }
}

- (void)sdl_handleAudioStartServiceAck:(SDLProtocolMessage *)audioStartServiceAck {
    SDLLogD(@"Audio service started");
    _audioEncrypted = audioStartServiceAck.header.encrypted;

    SDLControlFramePayloadAudioStartServiceAck *audioAckPayload = [[SDLControlFramePayloadAudioStartServiceAck alloc] initWithData:audioStartServiceAck.payload];
    SDLLogV(@"ACK: %@", audioAckPayload);

    if (audioAckPayload.mtu != SDLControlFrameInt64NotFound) {
        [[SDLGlobals sharedGlobals] setDynamicMTUSize:(NSUInteger)audioAckPayload.mtu forServiceType:SDLServiceTypeAudio];
    }

    [self.audioStreamStateMachine transitionToState:SDLAudioStreamManagerStateReady];
}

#pragma mark Video / Audio Start Service NAK

- (void)handleProtocolStartServiceNAKMessage:(SDLProtocolMessage *)startServiceNAK {
    switch (startServiceNAK.header.serviceType) {
        case SDLServiceTypeAudio: {
            [self sdl_handleAudioStartServiceNak:startServiceNAK];
        } break;
        default: break;
    }
}

- (void)sdl_handleAudioStartServiceNak:(SDLProtocolMessage *)audioStartServiceNak {
    SDLLogW(@"Audio service failed to start due to NAK");
    [self sdl_transitionToStoppedState:SDLServiceTypeAudio];
}

#pragma mark Video / Audio End Service

- (void)handleProtocolEndServiceACKMessage:(SDLProtocolMessage *)endServiceACK {
    SDLLogD(@"%@ service ended", (endServiceACK.header.serviceType == SDLServiceTypeVideo ? @"Video" : @"Audio"));
    [self sdl_transitionToStoppedState:endServiceACK.header.serviceType];
}

- (void)handleProtocolEndServiceNAKMessage:(SDLProtocolMessage *)endServiceNAK {
    SDLLogW(@"%@ service ended with end service NAK", (endServiceNAK.header.serviceType == SDLServiceTypeVideo ? @"Video" : @"Audio"));
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

    SDLLogV(@"Determining whether streaming is supported");
    _streamingSupported = registerResponse.hmiCapabilities.videoStreaming ? registerResponse.hmiCapabilities.videoStreaming.boolValue : registerResponse.displayCapabilities.graphicSupported.boolValue;

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
    SDLLogD(@"HMI level changed from level %@ to level %@", self.hmiLevel, hmiStatus.hmiLevel);
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
    switch (serviceType) {
        case SDLServiceTypeAudio:
            [self.audioStreamStateMachine transitionToState:SDLAudioStreamManagerStateStopped];
            break;
        default: break;
    }
}

#pragma mark Setters / Getters

- (BOOL)isHmiStateAudioStreamCapable {
    return [self.hmiLevel isEqualToEnum:SDLHMILevelLimited] || [self.hmiLevel isEqualToEnum:SDLHMILevelFull];
}

@end

NS_ASSUME_NONNULL_END
