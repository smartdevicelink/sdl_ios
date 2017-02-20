//
//  SDLStreamingMediaLifecycleManager.m
//  SmartDeviceLink-iOS
//
//  Created by Muller, Alexander (A.) on 2/16/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "SDLStreamingMediaLifecycleManager.h"

#import "SDLAbstractProtocol.h"
#import "SDLDebugTool.h"
#import "SDLDisplayCapabilities.h"
#import "SDLGlobals.h"
#import "SDLHMILevel.h"
#import "SDLImageResolution.h"
#import "SDLNotificationConstants.h"
#import "SDLOnHMIStatus.h"
#import "SDLRegisterAppInterfaceResponse.h"
#import "SDLRPCNotificationNotification.h"
#import "SDLRPCResponseNotification.h"
#import "SDLScreenParams.h"
#import "SDLStateMachine.h"
#import "SDLTouchManager.h"
#import "SDLVideoEncoder.h"

NS_ASSUME_NONNULL_BEGIN

SDLAppState *const SDLAppStateBackground = @"Background";
SDLAppState *const SDLAppStateIsResigningActive = @"IsResigningActive";
SDLAppState *const SDLAppStateInactive = @"Inactive";
SDLAppState *const SDLAppStateIsRegainingActive = @"IsRegainingActive";
SDLAppState *const SDLAppStateActive = @"Active";

SDLVideoStreamState *const SDLVideoStreamStateStopped = @"VideoStreamStopped";
SDLVideoStreamState *const SDLVideoStreamStateStarting = @"VideoStreamStarting";
SDLVideoStreamState *const SDLVideoStreamStateReady = @"VideoStreamReady";
SDLVideoStreamState *const SDLVideoStreamStateShuttingDown = @"VideoStreamShuttingDown";

SDLAudioStreamState *const SDLAudioStreamStateStopped = @"AudioStreamStopped";
SDLAudioStreamState *const SDLAudioStreamStateStarting = @"AudioStreamStarting";
SDLAudioStreamState *const SDLAudioStreamStateReady = @"AudioStreamReady";
SDLAudioStreamState *const SDLAudioStreamStateShuttingDown = @"AudioStreamShuttingDown";

@interface SDLStreamingMediaLifecycleManager () <SDLVideoEncoderDelegate>

@property (copy, nonatomic, nullable) SDLHMILevel currentHMILevel;

@property (weak, nonatomic) SDLAbstractProtocol *protocol;

@property (strong, nonatomic, nullable) SDLVideoEncoder *videoEncoder;

@property (assign, nonatomic, readonly, getter=isAppStateVideoStreamCapable) BOOL appStateVideoStreamCapable;

@property (assign, nonatomic, readonly, getter=isHmiStateAudioStreamCapable) BOOL hmiStateAudioStreamCapable;
@property (assign, nonatomic, readonly, getter=isHmiStateVideoStreamCapable) BOOL hmiStateVideoStreamCapable;

@property (assign, nonatomic) BOOL shouldRestartVideoStream;

@property (copy, nonatomic) NSDictionary<NSString *, id> *videoEncoderSettings;

@property (strong, nonatomic, readwrite) SDLStateMachine *appStateMachine;
@property (strong, nonatomic, readwrite) SDLStateMachine *videoStreamStateMachine;
@property (strong, nonatomic, readwrite) SDLStateMachine *audioStreamStateMachine;

@end


@implementation SDLStreamingMediaLifecycleManager

#pragma mark - Public
#pragma mark Lifecycle

- (instancetype)init {
    return [self initWithEncryption:SDLStreamingEncryptionFlagAuthenticateAndEncrypt videoEncoderSettings:nil];
}

- (instancetype)initWithEncryption:(SDLStreamingEncryptionFlag)encryption videoEncoderSettings:(nullable NSDictionary<NSString *, id> *)videoEncoderSettings {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    if (SDL_SYSTEM_VERSION_LESS_THAN(@"8.0")) {
        NSAssert(NO, @"SDL Video Sessions can only be run on iOS 8+ devices");
        return nil;
    }
    
    _videoEncoderSettings = videoEncoderSettings ?: SDLVideoEncoder.defaultVideoEncoderSettings;
    
    _requestedEncryptionType = encryption;
    
    _audioStreamingSupported = NO;
    _videoStreamingSupported = NO;
    
    _audioEncrypted = NO;
    _videoEncrypted = NO;
    
    _currentHMILevel = nil;
    
    _screenSize = SDLDefaultScreenSize;
    
    SDLAppState *initialState = SDLAppStateBackground;
    switch ([[UIApplication sharedApplication] applicationState]) {
        case UIApplicationStateActive:
            initialState = SDLAppStateActive;
            break;
        case UIApplicationStateInactive:
            initialState = SDLAppStateInactive;
            break;
        case UIApplicationStateBackground:
            initialState = SDLAppStateBackground;
            break;
        default:
            break;
    }
    
    _touchManager = [[SDLTouchManager alloc] init];
    
    _appStateMachine = [[SDLStateMachine alloc] initWithTarget:self initialState:initialState states:[self.class sdl_appStateTransitionDictionary]];
    _videoStreamStateMachine = [[SDLStateMachine alloc] initWithTarget:self initialState:SDLVideoStreamStateStopped states:[self.class sdl_videoStreamStateTransitionDictionary]];
    _audioStreamStateMachine = [[SDLStateMachine alloc] initWithTarget:self initialState:SDLAudioStreamStateStopped states:[self.class sdl_audioStreamingStateTransitionDictionary]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_didReceiveRegisterAppInterfaceResponse:) name:SDLDidReceiveRegisterAppInterfaceResponse object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_hmiLevelDidChange:) name:SDLDidChangeHMIStatusNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_appStateDidUpdate:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_appStateDidUpdate:) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_appStateDidUpdate:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_appStateDidUpdate:) name:UIApplicationWillResignActiveNotification object:nil];
    
    return self;
}

- (void)startWithProtocol:(SDLAbstractProtocol *)protocol completionHandler:(void (^)(BOOL, NSError * _Nullable))completionHandler {
    _protocol = protocol;
    
    if (![self.protocol.protocolDelegateTable containsObject:self]) {
        [self.protocol.protocolDelegateTable addObject:self];
    }
    
    completionHandler(YES, nil);
}

- (void)stop {
    [self sdl_stopAudioSession];
    [self sdl_stopVideoSession];
    
    if (_videoEncoder != nil) {
        [_videoEncoder stop];
        _videoEncoder = nil;
    }
}

- (BOOL)sendVideoData:(CVImageBufferRef)imageBuffer {
    if (!self.isVideoConnected) {
        [SDLDebugTool logInfo:@"Video streaming is not ready to send video data"];
        return NO;
    } else if (!self.isAppStateVideoStreamCapable) {
        [SDLDebugTool logInfo:@"App state must be in the foreground to stream."];
        return NO;
    } else if (!self.isHmiStateVideoStreamCapable) {
        [SDLDebugTool logInfo:@"HMI State must be in Limited or Full to stream"];
        return NO;
    }
    
    return [self.videoEncoder encodeFrame:imageBuffer];
}

- (BOOL)sendAudioData:(NSData*)audioData {
    if (!self.isAudioConnected) {
        return NO;
    }
    
    if (self.isAudioEncrypted) {
        [self.protocol sendEncryptedRawData:audioData onService:SDLServiceTypeAudio];
    } else {
        [self.protocol sendRawData:audioData withServiceType:SDLServiceTypeAudio];
    }
    return YES;
}

#pragma mark Getters
- (BOOL)isAudioConnected {
    return [self.audioStreamStateMachine isCurrentState:SDLAudioStreamStateReady];
}

- (BOOL)isVideoConnected {
    return [self.videoStreamStateMachine isCurrentState:SDLVideoStreamStateReady];
}

- (BOOL)isVideoStreamingPaused {
    return !(self.isVideoConnected && self.isHmiStateVideoStreamCapable && self.isAppStateVideoStreamCapable);
}

- (CVPixelBufferPoolRef __nullable)pixelBufferPool {
    return self.videoEncoder.pixelBufferPool;
}

- (SDLAppState *)currentAppState {
    return self.appStateMachine.currentState;
}

- (SDLAudioStreamState *)currentAudioStreamState {
    return self.audioStreamStateMachine.currentState;
}

- (SDLVideoStreamState *)currentVideoStreamState {
    return self.videoStreamStateMachine.currentState;
}

#pragma mark - State Machines
#pragma mark App
+ (NSDictionary<SDLState *, SDLAllowableStateTransitions *> *)sdl_appStateTransitionDictionary {
    return @{
             SDLAppStateBackground : @[SDLAppStateIsRegainingActive],
             // Will go from Inactive to Active if coming from a Phone Call.
             // Will go from Inactive to IsRegainingActive if coming from Background.
             SDLAppStateInactive : @[SDLAppStateBackground, SDLAppStateIsRegainingActive, SDLAppStateActive],
             SDLAppStateActive : @[SDLAppStateIsResigningActive],
             SDLAppStateIsRegainingActive : @[SDLAppStateActive],
             SDLAppStateIsResigningActive : @[SDLAppStateInactive]
             };
}

- (void)sdl_appStateDidUpdate:(NSNotification*)notification {
    if (notification.name == UIApplicationWillEnterForegroundNotification) {
        [self.appStateMachine transitionToState:SDLAppStateIsRegainingActive];
    } else if (notification.name == UIApplicationWillResignActiveNotification) {
        [self.appStateMachine transitionToState:SDLAppStateIsResigningActive];
    } else if (notification.name == UIApplicationDidBecomeActiveNotification) {
        [self.appStateMachine transitionToState:SDLAppStateActive];
    } else if (notification.name == UIApplicationDidEnterBackgroundNotification) {
        [self.appStateMachine transitionToState:SDLAppStateBackground];
    }
}

- (void)didEnterStateBackground {
    self.shouldRestartVideoStream = YES;
}

- (void)didEnterStateInactive {
    [self.touchManager cancelPendingTouches];
    self.shouldRestartVideoStream = YES;
}

// Per Apple's guidelines: https://developer.apple.com/library/content/documentation/iPhone/Conceptual/iPhoneOSProgrammingGuide/StrategiesforHandlingAppStateTransitions/StrategiesforHandlingAppStateTransitions.html
// We should be waiting to start any OpenGL drawing until UIApplicationDidBecomeActive is called.
- (void)didEnterStateActive {
    [self sdl_startVideoSession];
    [self sdl_startAudioSession];
}

- (void)didEnterStateIsResigningActive {
    [self.appStateMachine transitionToState:SDLAppStateInactive];
}

- (void)didEnterStateIsRegainingActive { }

#pragma mark Video Streaming
+ (NSDictionary<SDLState *, SDLAllowableStateTransitions *> *)sdl_videoStreamStateTransitionDictionary {
    return @{
             SDLVideoStreamStateStopped : @[SDLVideoStreamStateStarting],
             SDLVideoStreamStateStarting : @[SDLVideoStreamStateStopped, SDLVideoStreamStateReady],
             SDLVideoStreamStateReady : @[SDLVideoStreamStateShuttingDown, SDLVideoStreamStateStopped],
             SDLVideoStreamStateShuttingDown : @[SDLVideoStreamStateStopped]
             };
}

- (void)didEnterStateVideoStreamStopped {
    _videoEncrypted = NO;
    
    if (_videoEncoder != nil) {
        [_videoEncoder stop];
        _videoEncoder = nil;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SDLVideoStreamDidStopNotification object:nil];
    
    if (self.shouldRestartVideoStream) {
        self.shouldRestartVideoStream = NO;
        [self sdl_startVideoSession];
    }
}

- (void)didEnterStateVideoStreamStarting {
    self.shouldRestartVideoStream = NO;
    
    if (self.requestedEncryptionType != SDLStreamingEncryptionFlagNone) {
        [self.protocol startSecureServiceWithType:SDLServiceTypeVideo completionHandler:^(BOOL success, NSError *error) {
            // This only fires if we fail!!
            if (error) {
                [SDLDebugTool logFormat:@"TLS Setup Error: %@", error];
                [self.videoStreamStateMachine transitionToState:SDLVideoStreamStateStopped];
            }
        }];
    } else {
        [self.protocol startServiceWithType:SDLServiceTypeVideo];
    }
}

- (void)didEnterStateVideoStreamReady {
    if (_videoEncoder == nil) {
        NSError* error = nil;
        _videoEncoder = [[SDLVideoEncoder alloc] initWithDimensions:self.screenSize properties:self.videoEncoderSettings delegate:self error:&error];
        
        if (error) {
            [SDLDebugTool logFormat:@"Encountered error creating video encoder: %@", error.localizedDescription];
            [self.videoStreamStateMachine transitionToState:SDLVideoStreamStateStopped];
            return;
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SDLVideoStreamDidStartNotification object:nil];
}

- (void)didEnterStateVideoStreamShuttingDown {
    [self.protocol endServiceWithType:SDLServiceTypeVideo];
}

#pragma mark Audio
+ (NSDictionary<SDLState *, SDLAllowableStateTransitions *> *)sdl_audioStreamingStateTransitionDictionary {
    return @{
             SDLAudioStreamStateStopped : @[SDLAudioStreamStateStarting],
             SDLAudioStreamStateStarting : @[SDLAudioStreamStateStopped, SDLAudioStreamStateReady],
             SDLAudioStreamStateReady : @[SDLAudioStreamStateShuttingDown, SDLAudioStreamStateStopped],
             SDLAudioStreamStateShuttingDown : @[SDLAudioStreamStateStopped]
             };
}

- (void)didEnterStateAudioStreamStopped {
    _audioEncrypted = NO;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SDLAudioStreamDidStopNotification object:nil];
}

- (void)didEnterStateAudioStreamStarting {
    if (self.requestedEncryptionType != SDLStreamingEncryptionFlagNone) {
        [self.protocol startSecureServiceWithType:SDLServiceTypeAudio completionHandler:^(BOOL success, NSError *error) {
            // This only fires if we fail!!
            if (error) {
                [SDLDebugTool logFormat:@"TLS Setup Error: %@", error];
                [self.audioStreamStateMachine transitionToState:SDLAudioStreamStateStopped];
            }
        }];
    } else {
        [self.protocol startServiceWithType:SDLServiceTypeAudio];
    }
}

- (void)didEnterStateAudioStreamReady {
    [[NSNotificationCenter defaultCenter] postNotificationName:SDLAudioStreamDidStartNotification object:nil];
}

- (void)didEnterStateAudioStreamShuttingDown {
    [self.protocol endServiceWithType:SDLServiceTypeAudio];
}

#pragma mark - SDLProtocolListener
- (void)handleProtocolStartSessionACK:(SDLProtocolHeader *)header {
    switch (header.serviceType) {
        case SDLServiceTypeAudio: {
            _audioEncrypted = header.encrypted;
            
            [self.audioStreamStateMachine transitionToState:SDLAudioStreamStateReady];
        } break;
        case SDLServiceTypeVideo: {
            _videoEncrypted = header.encrypted;
            
            [self.videoStreamStateMachine transitionToState:SDLVideoStreamStateReady];
        } break;
        default: break;
    }
}

- (void)handleProtocolStartSessionNACK:(SDLServiceType)serviceType {
    [self sdl_transitionToStoppedState:serviceType];
}

- (void)handleProtocolEndSessionACK:(SDLServiceType)serviceType {
    [self sdl_transitionToStoppedState:serviceType];
}

- (void)handleProtocolEndSessionNACK:(SDLServiceType)serviceType {
    [self sdl_transitionToStoppedState:serviceType];
}

#pragma mark - SDLVideoEncoderDelegate
- (void)videoEncoder:(SDLVideoEncoder *)encoder hasEncodedFrame:(NSData *)encodedVideo {
    // Do we care about app state here? I don't think so…
    BOOL capableVideoStreamState = [self.videoStreamStateMachine isCurrentState:SDLVideoStreamStateReady];
    
    if (self.isHmiStateVideoStreamCapable && capableVideoStreamState) {
        if (self.isVideoEncrypted) {
            [self.protocol sendEncryptedRawData:encodedVideo onService:SDLServiceTypeVideo];
        } else {
            [self.protocol sendRawData:encodedVideo withServiceType:SDLServiceTypeVideo];
        }
    }
}

#pragma mark - Private
- (void)sdl_didReceiveRegisterAppInterfaceResponse:(SDLRPCResponseNotification*)notification {
    NSAssert([notification.response isKindOfClass:[SDLRegisterAppInterfaceResponse class]], @"A notification was sent with an unanticipated object");
    if (![notification.response isKindOfClass:[SDLRegisterAppInterfaceResponse class]]) {
        return;
    }
    
    SDLRegisterAppInterfaceResponse* registerResponse = (SDLRegisterAppInterfaceResponse*)notification.response;
    
    _videoStreamingSupported = registerResponse.displayCapabilities.graphicSupported.boolValue;
    _audioStreamingSupported = registerResponse.displayCapabilities.graphicSupported.boolValue;
    
    if (!self.isVideoStreamingSupported) {
        [SDLDebugTool logInfo:@"Graphics are not support. We are assuming screen size is also unavailable"];
        return;
    }
    
    SDLImageResolution* resolution = registerResponse.displayCapabilities.screenParams.resolution;
    if (resolution != nil) {
        _screenSize = CGSizeMake(resolution.resolutionWidth.floatValue,
                                 resolution.resolutionHeight.floatValue);
    } else {
        _screenSize = SDLDefaultScreenSize;
    }
}

- (void)sdl_hmiLevelDidChange:(SDLRPCNotificationNotification *)notification {
    NSAssert([notification.notification isKindOfClass:[SDLOnHMIStatus class]], @"A notification was sent with an unanticipated object");
    if (![notification.notification isKindOfClass:[SDLOnHMIStatus class]]) {
        return;
    }
    
    SDLOnHMIStatus *hmiStatus = (SDLOnHMIStatus*)notification.notification;
    
    SDLHMILevel oldHMILevel = [self.currentHMILevel copy];
    self.currentHMILevel = hmiStatus.hmiLevel;
    
    if (self.isHmiStateVideoStreamCapable) {
        [self sdl_startVideoSession];
    } else {
        [self sdl_stopVideoSession];
    }
    
    if (self.isHmiStateAudioStreamCapable) {
        [self sdl_startAudioSession];
    } else {
        [self sdl_stopAudioSession];
    }
}

- (void)sdl_startVideoSession {
    if (!self.isVideoStreamingSupported) {
        return;
    }
    
    if (self.shouldRestartVideoStream
        && [self.videoStreamStateMachine isCurrentState:SDLVideoStreamStateReady]) {
        [self sdl_stopVideoSession];
        return;
    }
    
    if ([self.videoStreamStateMachine isCurrentState:SDLVideoStreamStateStopped]
        && self.isHmiStateVideoStreamCapable
        && self.isAppStateVideoStreamCapable) {
        [self.videoStreamStateMachine transitionToState:SDLVideoStreamStateStarting];
    } else {
        [SDLDebugTool logFormat:@"Video Stream State: %@", self.videoStreamStateMachine.currentState];
        [SDLDebugTool logFormat:@"HMI State: %@", self.currentHMILevel];
        [SDLDebugTool logFormat:@"App State: %@", self.appStateMachine.currentState];
        [SDLDebugTool logFormat:@"Cannot start video stream."];
    }
}

- (void)sdl_startAudioSession {
    if (!self.isAudioStreamingSupported) {
        return;
    }
    
    if ([self.audioStreamStateMachine isCurrentState:SDLAudioStreamStateStopped]
        && self.isHmiStateAudioStreamCapable) {
        [self.audioStreamStateMachine transitionToState:SDLAudioStreamStateStarting];
    }
}

- (void)sdl_stopVideoSession {
    if (!self.isVideoStreamingSupported) {
        return;
    }
    
    if (self.isVideoConnected) {
        [self.videoStreamStateMachine transitionToState:SDLVideoStreamStateShuttingDown];
    }
}

- (void)sdl_stopAudioSession {
    if (!self.isAudioStreamingSupported) {
        return;
    }
    
    if (self.isAudioConnected) {
        [self.audioStreamStateMachine transitionToState:SDLAudioStreamStateShuttingDown];
    }
}

- (void)sdl_transitionToStoppedState:(SDLServiceType)serviceType {
    switch (serviceType) {
        case SDLServiceTypeAudio:
            [self.audioStreamStateMachine transitionToState:SDLAudioStreamStateStopped];
            break;
        case SDLServiceTypeVideo:
            [self.videoStreamStateMachine transitionToState:SDLVideoStreamStateStopped];
            break;
        default:
            break;
    }
}

#pragma mark Getters
- (BOOL)isAppStateVideoStreamCapable {
    return [self.appStateMachine isCurrentState:SDLAppStateActive];
}

- (BOOL)isHmiStateAudioStreamCapable {
    return YES;
}

- (BOOL)isHmiStateVideoStreamCapable {
    return [self.currentHMILevel isEqualToString:SDLHMILevelLimited] || [self.currentHMILevel isEqualToString:SDLHMILevelFull];
}

@end

NS_ASSUME_NONNULL_END
