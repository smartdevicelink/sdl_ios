//
//  SDLStreamingMediaLifecycleManager.m
//  SmartDeviceLink-iOS
//
//  Created by Muller, Alexander (A.) on 2/16/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "SDLStreamingMediaLifecycleManager.h"

#import "SDLAbstractProtocol.h"
#import "SDLAudioStreamManager.h"
#import "SDLCarWindow.h"
#import "SDLControlFramePayloadAudioStartServiceAck.h"
#import "SDLControlFramePayloadConstants.h"
#import "SDLControlFramePayloadNak.h"
#import "SDLControlFramePayloadVideoStartService.h"
#import "SDLControlFramePayloadVideoStartServiceAck.h"
#import "SDLDisplayCapabilities.h"
#import "SDLGenericResponse.h"
#import "SDLGetSystemCapability.h"
#import "SDLGetSystemCapabilityResponse.h"
#import "SDLGlobals.h"
#import "SDLFocusableItemLocator.h"
#import "SDLH264VideoEncoder.h"
#import "SDLHMICapabilities.h"
#import "SDLImageResolution.h"
#import "SDLLogMacros.h"
#import "SDLNotificationConstants.h"
#import "SDLOnHMIStatus.h"
#import "SDLProtocolMessage.h"
#import "SDLRegisterAppInterfaceResponse.h"
#import "SDLRPCNotificationNotification.h"
#import "SDLRPCResponseNotification.h"
#import "SDLScreenParams.h"
#import "SDLStateMachine.h"
#import "SDLStreamingMediaConfiguration.h"
#import "SDLStreamingMediaManagerDataSource.h"
#import "SDLSystemCapability.h"
#import "SDLTouchManager.h"
#import "SDLVehicleType.h"
#import "SDLVideoStreamingCapability.h"
#import "SDLVideoStreamingCodec.h"
#import "SDLVideoStreamingFormat.h"
#import "SDLVideoStreamingProtocol.h"

#import "CVPixelBufferRef+SDLUtil.h"


NS_ASSUME_NONNULL_BEGIN

SDLAppState *const SDLAppStateInactive = @"AppInactive";
SDLAppState *const SDLAppStateActive = @"AppActive";

SDLVideoStreamState *const SDLVideoStreamStateStopped = @"VideoStreamStopped";
SDLVideoStreamState *const SDLVideoStreamStateStarting = @"VideoStreamStarting";
SDLVideoStreamState *const SDLVideoStreamStateReady = @"VideoStreamReady";
SDLVideoStreamState *const SDLVideoStreamStateShuttingDown = @"VideoStreamShuttingDown";

SDLAudioStreamState *const SDLAudioStreamStateStopped = @"AudioStreamStopped";
SDLAudioStreamState *const SDLAudioStreamStateStarting = @"AudioStreamStarting";
SDLAudioStreamState *const SDLAudioStreamStateReady = @"AudioStreamReady";
SDLAudioStreamState *const SDLAudioStreamStateShuttingDown = @"AudioStreamShuttingDown";

static NSUInteger const FramesToSendOnBackground = 30;

typedef void(^SDLVideoCapabilityResponseHandler)(SDLVideoStreamingCapability *_Nullable capability);


@interface SDLStreamingMediaLifecycleManager () <SDLVideoEncoderDelegate>

@property (weak, nonatomic) id<SDLConnectionManagerType> connectionManager;
@property (weak, nonatomic) SDLAbstractProtocol *protocol;

@property (assign, nonatomic, readonly, getter=isAppStateVideoStreamCapable) BOOL appStateVideoStreamCapable;
@property (assign, nonatomic, readonly, getter=isHmiStateAudioStreamCapable) BOOL hmiStateAudioStreamCapable;
@property (assign, nonatomic, readonly, getter=isHmiStateVideoStreamCapable) BOOL hmiStateVideoStreamCapable;

@property (assign, nonatomic, readwrite) BOOL restartVideoStream;
@property (strong, nonatomic, readwrite, nullable) SDLVideoStreamingFormat *videoFormat;

@property (strong, nonatomic, nullable) SDLH264VideoEncoder *videoEncoder;
@property (copy, nonatomic) NSDictionary<NSString *, id> *videoEncoderSettings;
@property (copy, nonatomic) NSArray<NSString *> *secureMakes;
@property (copy, nonatomic) NSString *connectedVehicleMake;

@property (strong, nonatomic, readwrite) SDLStateMachine *appStateMachine;
@property (strong, nonatomic, readwrite) SDLStateMachine *videoStreamStateMachine;
@property (strong, nonatomic, readwrite) SDLStateMachine *audioStreamStateMachine;

@property (assign, nonatomic) CV_NULLABLE CVPixelBufferRef backgroundingPixelBuffer;

@property (strong, nonatomic, nullable) CADisplayLink *displayLink;
@property (assign, nonatomic) BOOL useDisplayLink;

@property (assign, nonatomic) CMTime lastPresentationTimestamp;

@end


@implementation SDLStreamingMediaLifecycleManager

#pragma mark - Public
#pragma mark Lifecycle

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager configuration:(SDLStreamingMediaConfiguration *)configuration {
    self = [super init];
    if (!self) {
        return nil;
    }

    SDLLogV(@"Creating StreamingLifecycleManager");

    _connectionManager = connectionManager;
    _videoEncoderSettings = configuration.customVideoEncoderSettings ?: SDLH264VideoEncoder.defaultVideoEncoderSettings;

    if (configuration.rootViewController != nil) {
        NSAssert(configuration.enableForcedFramerateSync, @"When using CarWindow (rootViewController != nil), forceFrameRateSync must be YES");
        if (@available(iOS 9.0, *)) {
            SDLLogD(@"Initializing focusable item locator");
            _focusableItemManager = [[SDLFocusableItemLocator alloc] initWithViewController:configuration.rootViewController connectionManager:_connectionManager];
        }

        SDLLogD(@"Initializing CarWindow");
        _carWindow = [[SDLCarWindow alloc] initWithStreamManager:self configuration:configuration];
        _carWindow.rootViewController = configuration.rootViewController;
    }

    _touchManager = [[SDLTouchManager alloc] initWithHitTester:(id)_focusableItemManager];
    _audioManager = [[SDLAudioStreamManager alloc] initWithManager:self];

    _requestedEncryptionType = configuration.maximumDesiredEncryption;
    _dataSource = configuration.dataSource;
    _useDisplayLink = configuration.enableForcedFramerateSync;
    _screenSize = SDLDefaultScreenSize;
    _backgroundingPixelBuffer = NULL;
    _preferredFormatIndex = 0;
    _preferredResolutionIndex = 0;

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
    _videoStreamStateMachine = [[SDLStateMachine alloc] initWithTarget:self initialState:SDLVideoStreamStateStopped states:[self.class sdl_videoStreamStateTransitionDictionary]];
    _audioStreamStateMachine = [[SDLStateMachine alloc] initWithTarget:self initialState:SDLAudioStreamStateStopped states:[self.class sdl_audioStreamingStateTransitionDictionary]];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_didReceiveRegisterAppInterfaceResponse:) name:SDLDidReceiveRegisterAppInterfaceResponse object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_hmiLevelDidChange:) name:SDLDidChangeHMIStatusNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_appStateDidUpdate:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_appStateDidUpdate:) name:UIApplicationWillResignActiveNotification object:nil];

    _lastPresentationTimestamp = kCMTimeInvalid;

    return self;
}

- (void)startWithProtocol:(SDLAbstractProtocol *)protocol {
    _protocol = protocol;

    if (![self.protocol.protocolDelegateTable containsObject:self]) {
        [self.protocol.protocolDelegateTable addObject:self];
    }
}

- (void)stop {
    SDLLogD(@"Stopping manager");
    [self sdl_stopAudioSession];
    [self sdl_stopVideoSession];

    self.restartVideoStream = NO;

    self.hmiLevel = SDLHMILevelNone;

    [self.audioStreamStateMachine transitionToState:SDLAudioStreamStateStopped];
    [self.videoStreamStateMachine transitionToState:SDLVideoStreamStateStopped];
}

- (BOOL)sendVideoData:(CVImageBufferRef)imageBuffer {
    return [self sendVideoData:imageBuffer presentationTimestamp:kCMTimeInvalid];
}

- (BOOL)sendVideoData:(CVImageBufferRef)imageBuffer presentationTimestamp:(CMTime)presentationTimestamp {
    if (!self.isVideoConnected) {
        SDLLogW(@"Attempted to send video data, but not connected");
        return NO;
    } else if (!self.isAppStateVideoStreamCapable) {
        SDLLogW(@"Attempted to send video data, but app is not in the foreground");
        return NO;
    } else if (!self.isHmiStateVideoStreamCapable) {
        SDLLogW(@"Attempted to send video data, but the app is not in LIMITED or FULL HMI state");
        return NO;
    }

    /*
     * reject input image for following cases:
     * - presentation timestamp is not increasing
     * - app tries to send images while background images are shown
     */
    if (CMTIME_IS_VALID(self.lastPresentationTimestamp) && CMTIME_IS_VALID(presentationTimestamp)
        && CMTIME_COMPARE_INLINE(presentationTimestamp, <=, self.lastPresentationTimestamp)) {
        SDLLogW(@"The video data is out of date");
        return NO;
    }
    self.lastPresentationTimestamp = presentationTimestamp;

    SDLLogV(@"Sending data to video encoder");
    return [self.videoEncoder encodeFrame:imageBuffer presentationTimestamp:presentationTimestamp];
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
    if (!self.protocol) { return; }

    [self sdl_sendBackgroundFrames];
    [self.touchManager cancelPendingTouches];

    [self sdl_stopAudioSession];
    [self sdl_stopVideoSession];
}

// Per Apple's guidelines: https://developer.apple.com/library/content/documentation/iPhone/Conceptual/iPhoneOSProgrammingGuide/StrategiesforHandlingAppStateTransitions/StrategiesforHandlingAppStateTransitions.html
// We should be waiting to start any OpenGL drawing until UIApplicationDidBecomeActive is called.
- (void)didEnterStateAppActive {
    SDLLogD(@"App became active");
    if (!self.protocol) { return; }

    [self sdl_startVideoSession];
    [self sdl_startAudioSession];
}

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
    SDLLogD(@"Video stream stopped");
    _videoEncrypted = NO;
    _videoFormat = nil;

    if (_videoEncoder != nil) {
        [_videoEncoder stop];
        _videoEncoder = nil;
    }

    self.displayLink.paused = YES;
    [self.displayLink invalidate];

    [[NSNotificationCenter defaultCenter] postNotificationName:SDLVideoStreamDidStopNotification object:nil];

    if (self.shouldRestartVideoStream) {
        self.restartVideoStream = NO;
        [self sdl_startVideoSession];
    }
}

- (void)didEnterStateVideoStreamStarting {
    SDLLogD(@"Video stream starting");
    self.restartVideoStream = NO;

    __weak typeof(self) weakSelf = self;
    [self sdl_requestVideoCapabilities:^(SDLVideoStreamingCapability * _Nullable capability) {
        SDLLogD(@"Received video capability response");
        SDLLogV(@"Capability: %@", capability);

        if (capability != nil) {
            // If we got a response, get the head unit's preferred formats and resolutions
            weakSelf.preferredFormats = capability.supportedFormats;
            weakSelf.preferredResolutions = @[capability.preferredResolution];

            if (weakSelf.dataSource != nil) {
                SDLLogV(@"Calling data source for modified preferred formats");
                weakSelf.preferredFormats = [weakSelf.dataSource preferredVideoFormatOrderFromHeadUnitPreferredOrder:weakSelf.preferredFormats];
            }

            if (weakSelf.focusableItemManager != nil) {
                weakSelf.focusableItemManager.enableHapticDataRequests = capability.hapticSpatialDataSupported.boolValue;
            }

            SDLLogD(@"Got specialized video capabilites, preferred formats: %@, haptics enabled %@", weakSelf.preferredFormats, (capability.hapticSpatialDataSupported.boolValue ? @"YES" : @"NO"));
        } else {
            // If no response, assume that the format is H264 RAW and get the screen resolution from the RAI response's display capabilities.
            SDLVideoStreamingFormat *format = [[SDLVideoStreamingFormat alloc] initWithCodec:SDLVideoStreamingCodecH264 protocol:SDLVideoStreamingProtocolRAW];
            SDLImageResolution *resolution = [[SDLImageResolution alloc] initWithWidth:(uint16_t)weakSelf.screenSize.width height:(uint16_t)weakSelf.screenSize.height];
            weakSelf.preferredFormats = @[format];
            weakSelf.preferredResolutions = @[resolution];

            if (weakSelf.focusableItemManager != nil) {
                weakSelf.focusableItemManager.enableHapticDataRequests = NO;
            }

            SDLLogD(@"Using generic video capabilites, preferred formats: %@, resolutions: %@, haptics disabled", weakSelf.preferredFormats, weakSelf.preferredResolutions);
        }

        if (weakSelf.dataSource != nil) {
            SDLLogV(@"Calling data source for modified preferred resolutions");
            weakSelf.preferredResolutions = [weakSelf.dataSource resolutionFromHeadUnitPreferredResolution:weakSelf.preferredResolutions.firstObject];
            SDLLogD(@"Got specialized video resolutions: %@", weakSelf.preferredResolutions);
        }

        [self sdl_sendVideoStartService];
    }];
}

- (void)didEnterStateVideoStreamReady {
    SDLLogD(@"Video stream ready");
    // TODO: What if it isn't nil, is it even possible for it to not be nil?
    if (self.videoEncoder == nil) {
        NSError* error = nil;
        NSAssert(self.videoFormat != nil, @"No video format is known, but it must be if we got a protocol start service response");

        SDLLogD(@"Attempting to create video encoder");
        self.videoEncoder = [[SDLH264VideoEncoder alloc] initWithProtocol:self.videoFormat.protocol dimensions:self.screenSize properties:self.videoEncoderSettings delegate:self error:&error];

        if (error || self.videoEncoder == nil) {
            SDLLogE(@"Could not create a video encoder: %@", error);
            [self.videoStreamStateMachine transitionToState:SDLVideoStreamStateStopped];
            return;
        }

        if (!self.backgroundingPixelBuffer) {
            CVPixelBufferRef backgroundingPixelBuffer = [self.videoEncoder newPixelBuffer];
            if (CVPixelBufferAddText(backgroundingPixelBuffer, @"") == NO) {
                SDLLogE(@"Could not create a backgrounding frame");
                [self.videoStreamStateMachine transitionToState:SDLVideoStreamStateStopped];
                return;
            }

            self.backgroundingPixelBuffer = backgroundingPixelBuffer;
        }
        self.lastPresentationTimestamp = kCMTimeInvalid;
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:SDLVideoStreamDidStartNotification object:nil];

    if (self.useDisplayLink) {
        dispatch_async(dispatch_get_main_queue(), ^{
            // And start up the displayLink
            NSInteger targetFramerate = ((NSNumber *)self.videoEncoderSettings[(__bridge NSString *)kVTCompressionPropertyKey_ExpectedFrameRate]).integerValue;
            SDLLogD(@"Initializing CADisplayLink with framerate: %ld", (long)targetFramerate);
            self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(sdl_displayLinkFired:)];
            if (@available(iOS 10, *)) {
                self.displayLink.preferredFramesPerSecond = targetFramerate;
            } else {
                self.displayLink.frameInterval = (60 / targetFramerate);
            }
            [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        });
    } else {
        self.touchManager.enableSyncedPanning = NO;
    }
}

- (void)didEnterStateVideoStreamShuttingDown {
    SDLLogD(@"Video stream shutting down");
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
                [self.audioStreamStateMachine transitionToState:SDLAudioStreamStateStopped];
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
        case SDLServiceTypeVideo: {
            [self sdl_handleVideoStartServiceAck:startServiceACK];
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

    [self.audioStreamStateMachine transitionToState:SDLAudioStreamStateReady];
}

- (void)sdl_handleVideoStartServiceAck:(SDLProtocolMessage *)videoStartServiceAck {
    SDLLogD(@"Video service started");
    _videoEncrypted = videoStartServiceAck.header.encrypted;

    SDLControlFramePayloadVideoStartServiceAck *videoAckPayload = [[SDLControlFramePayloadVideoStartServiceAck alloc] initWithData:videoStartServiceAck.payload];
    SDLLogV(@"ACK: %@", videoAckPayload);

    if (videoAckPayload.mtu != SDLControlFrameInt64NotFound) {
        [[SDLGlobals sharedGlobals] setDynamicMTUSize:(NSUInteger)videoAckPayload.mtu forServiceType:SDLServiceTypeVideo];
    }

    // This is the definitive screen size that will be used
    if (videoAckPayload.height != SDLControlFrameInt32NotFound && videoAckPayload.width != SDLControlFrameInt32NotFound) {
        _screenSize = CGSizeMake(videoAckPayload.width, videoAckPayload.height);
    } else if (self.preferredResolutions.count > 0) {
        // If a preferred resolution was set, use the first option to set the screen size
        SDLImageResolution *preferredResolution = self.preferredResolutions.firstObject;
        CGSize newScreenSize = CGSizeMake(preferredResolution.resolutionWidth.floatValue, preferredResolution.resolutionHeight.floatValue);
        if (!CGSizeEqualToSize(self.screenSize, newScreenSize)) {
            SDLLogW(@"The preferred resolution does not match the screen dimensions returned by the Register App Interface Response. Video may look distorted or video may not show up on the head unit");
            _screenSize = CGSizeMake(preferredResolution.resolutionWidth.floatValue, preferredResolution.resolutionHeight.floatValue);
        }
    } // else we are using the screen size we got from the RAIR earlier

    // Figure out the definitive format that will be used. If the protocol / codec weren't passed in the payload, it's probably a system that doesn't support those properties, which also means it's a system that requires H.264 RAW encoding
    self.videoFormat = [[SDLVideoStreamingFormat alloc] init];
    self.videoFormat.codec = videoAckPayload.videoCodec ?: SDLVideoStreamingCodecH264;
    self.videoFormat.protocol = videoAckPayload.videoProtocol ?: SDLVideoStreamingProtocolRAW;

    [self.videoStreamStateMachine transitionToState:SDLVideoStreamStateReady];
}

#pragma mark Video / Audio Start Service NAK

- (void)handleProtocolStartServiceNAKMessage:(SDLProtocolMessage *)startServiceNAK {
    switch (startServiceNAK.header.serviceType) {
        case SDLServiceTypeAudio: {
            [self sdl_handleAudioStartServiceNak:startServiceNAK];
        } break;
        case SDLServiceTypeVideo: {
            [self sdl_handleVideoStartServiceNak:startServiceNAK];
        }
        default: break;
    }
}

- (void)sdl_handleVideoStartServiceNak:(SDLProtocolMessage *)videoStartServiceNak {
    SDLLogW(@"Video service failed to start due to NAK");
    SDLControlFramePayloadNak *nakPayload = [[SDLControlFramePayloadNak alloc] initWithData:videoStartServiceNak.payload];
    SDLLogD(@"NAK: %@", videoStartServiceNak);

    // If we have no payload rejected params, we don't know what to do to retry, so we'll just stop and maybe cry
    if (nakPayload.rejectedParams.count == 0) {
        [self sdl_transitionToStoppedState:SDLServiceTypeVideo];
        return;
    }

    // If height and/or width was rejected, and we have another resolution to try, advance our counter to try another resolution
    if (([nakPayload.rejectedParams containsObject:[NSString stringWithUTF8String:SDLControlFrameHeightKey]]
         || [nakPayload.rejectedParams containsObject:[NSString stringWithUTF8String:SDLControlFrameWidthKey]])) {
        self.preferredResolutionIndex++;
    }

    if (([nakPayload.rejectedParams containsObject:[NSString stringWithUTF8String:SDLControlFrameVideoCodecKey]]
         || [nakPayload.rejectedParams containsObject:[NSString stringWithUTF8String:SDLControlFrameVideoProtocolKey]])) {
        self.preferredFormatIndex++;
    }

    [self sdl_sendVideoStartService];
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

#pragma mark - SDLVideoEncoderDelegate

- (void)videoEncoder:(SDLH264VideoEncoder *)encoder hasEncodedFrame:(NSData *)encodedVideo {
    SDLLogV(@"Video encoder encoded frame, sending data");
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

    SDLImageResolution* resolution = registerResponse.displayCapabilities.screenParams.resolution;
    if (resolution != nil) {
        _screenSize = CGSizeMake(resolution.resolutionWidth.floatValue,
                                 resolution.resolutionHeight.floatValue);
    } else {
        _screenSize = SDLDefaultScreenSize;
    }

    self.connectedVehicleMake = registerResponse.vehicleType.make;

    SDLLogD(@"Determined base screen size on display capabilities: %@", NSStringFromCGSize(_screenSize));
}

- (void)sdl_hmiLevelDidChange:(SDLRPCNotificationNotification *)notification {
    NSAssert([notification.notification isKindOfClass:[SDLOnHMIStatus class]], @"A notification was sent with an unanticipated object");
    if (![notification.notification isKindOfClass:[SDLOnHMIStatus class]]) {
        return;
    }

    SDLOnHMIStatus *hmiStatus = (SDLOnHMIStatus*)notification.notification;
    SDLLogD(@"HMI level changed from level %@ to level %@", self.hmiLevel, hmiStatus.hmiLevel);
    self.hmiLevel = hmiStatus.hmiLevel;

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


#pragma mark - Streaming session helpers

- (void)sdl_startVideoSession {
    SDLLogV(@"Attempting to start video session");

    if (!self.isHmiStateVideoStreamCapable) {
        SDLLogV(@"SDL Core is not ready to stream video. Video start service request will not be sent.");
        return;
    }

    if (!self.isStreamingSupported) {
        SDLLogV(@"Streaming is not supported. Video start service request will not be sent.");
        return;
    }

    if (self.shouldRestartVideoStream && [self.videoStreamStateMachine isCurrentState:SDLVideoStreamStateReady]) {
        SDLLogV(@"Video needs to be restarted. Stopping video stream.");
        [self sdl_stopVideoSession];
        return;
    }

    if ([self.videoStreamStateMachine isCurrentState:SDLVideoStreamStateStopped] && self.isHmiStateVideoStreamCapable) {
        [self.videoStreamStateMachine transitionToState:SDLVideoStreamStateStarting];
    } else {
        SDLLogE(@"Unable to send video start service request\n"
                "Video State must be in state STOPPED: %@\n"
                "HMI state must be LIMITED or FULL: %@\n",
                self.videoStreamStateMachine.currentState, self.hmiLevel);
    }
}

- (void)sdl_startAudioSession {
    SDLLogV(@"Attempting to start audio session");
    if (!self.isStreamingSupported) {
        return;
    }

    if ([self.audioStreamStateMachine isCurrentState:SDLAudioStreamStateStopped]
        && self.isHmiStateAudioStreamCapable) {
        [self.audioStreamStateMachine transitionToState:SDLAudioStreamStateStarting];
    }
}

- (void)sdl_stopVideoSession {
    SDLLogV(@"Attempting to stop video session");
    if (!self.isStreamingSupported) {
        return;
    }

    if (self.isVideoConnected) {
        [self.videoStreamStateMachine transitionToState:SDLVideoStreamStateShuttingDown];
    }
}

- (void)sdl_stopAudioSession {
    SDLLogV(@"Attempting to stop audio session");
    if (!self.isStreamingSupported) {
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

- (void)sdl_displayLinkFired:(CADisplayLink *)displayLink {
    NSAssert([NSThread isMainThread], @"Display link should always fire on the main thread");
    if (@available(iOS 10.0, *)) {
        SDLLogV(@"DisplayLink frame fired, duration: %f, last frame timestamp: %f, target timestamp: %f", displayLink.duration, displayLink.timestamp, displayLink.targetTimestamp);
    } else {
        SDLLogV(@"DisplayLink frame fired, duration: %f, last frame timestamp: %f, target timestamp: (not available)", displayLink.duration, displayLink.timestamp);
    }

    [self.touchManager syncFrame];
    [self.carWindow syncFrame];
}

- (void)sdl_sendBackgroundFrames {
    SDLLogV(@"Attempting to send background frames");
    if (!self.backgroundingPixelBuffer) {
        SDLLogW(@"No background pixel buffer, unable to send background frames");
        return;
    }

    int32_t timeRate = 30;
    if (self.videoEncoderSettings[(__bridge NSString *)kVTCompressionPropertyKey_ExpectedFrameRate] != nil) {
        timeRate = ((NSNumber *)self.videoEncoderSettings[(__bridge NSString *)kVTCompressionPropertyKey_ExpectedFrameRate]).intValue;
    }

    const CMTime interval = CMTimeMake(1, timeRate);
    for (int frameCount = 0; frameCount < FramesToSendOnBackground; frameCount++) {
        if (CMTIME_IS_VALID(self.lastPresentationTimestamp)) {
            self.lastPresentationTimestamp = CMTimeAdd(self.lastPresentationTimestamp, interval);
            [self.videoEncoder encodeFrame:self.backgroundingPixelBuffer presentationTimestamp:self.lastPresentationTimestamp];
        } else {
            [self.videoEncoder encodeFrame:self.backgroundingPixelBuffer];
        }
    }
}

- (void)sdl_requestVideoCapabilities:(SDLVideoCapabilityResponseHandler)responseHandler {
    SDLLogD(@"Requesting video capabilities");
    SDLGetSystemCapability *getVideoCapabilityRequest = [[SDLGetSystemCapability alloc] initWithType:SDLSystemCapabilityTypeVideoStreaming];

    [self.connectionManager sendConnectionManagerRequest:getVideoCapabilityRequest withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
        if (!response.success || [response isMemberOfClass:SDLGenericResponse.class]) {
            SDLLogW(@"Video capabilities response failed: %@", error);
            responseHandler(nil);
            BLOCK_RETURN;
        }

        SDLVideoStreamingCapability *videoCapability = ((SDLGetSystemCapabilityResponse *)response).systemCapability.videoStreamingCapability;
        SDLLogD(@"Video capabilities response received: %@", videoCapability);
        responseHandler(videoCapability);
    }];
}

/**
 Pull the current format / resolution out of our preferred resolutions and craft a start video service payload out of it, then send a start service. If the format isn't one that we support, we're going to try the next format.
 */
- (void)sdl_sendVideoStartService {
    SDLLogV(@"Attempting to find preferred format");
    while (self.preferredFormatIndex < self.preferredFormats.count) {
        if (![self.supportedFormats containsObject:self.preferredFormats[self.preferredFormatIndex]]) {
            self.preferredFormatIndex++;
        } else {
            SDLLogV(@"Preferred format index found: %lu", self.preferredFormatIndex);
            break;
        }
    }

    // If this fails we have no known formats to use
    if (self.preferredFormatIndex >= self.preferredFormats.count
        || self.preferredResolutionIndex >= self.preferredResolutions.count) {
        SDLLogE(@"No preferred format or no preferred resolution found that works: format index %lu, resolution index %lu", (unsigned long)self.preferredFormatIndex, (unsigned long)self.preferredResolutionIndex);
        [self sdl_transitionToStoppedState:SDLServiceTypeVideo];
        return;
    }

    SDLVideoStreamingFormat *preferredFormat = self.preferredFormats[self.preferredFormatIndex];
    SDLImageResolution *preferredResolution = self.preferredResolutions[self.preferredResolutionIndex];

    SDLControlFramePayloadVideoStartService *startVideoPayload = [[SDLControlFramePayloadVideoStartService alloc] initWithVideoHeight:preferredResolution.resolutionHeight.intValue width:preferredResolution.resolutionWidth.intValue protocol:preferredFormat.protocol codec:preferredFormat.codec];

    // Decide if we need to start a secure service or not
    if ((self.requestedEncryptionType != SDLStreamingEncryptionFlagNone) && ([self.secureMakes containsObject:self.connectedVehicleMake])) {
        SDLLogD(@"Sending secure video start service with payload: %@", startVideoPayload);
        [self.protocol startSecureServiceWithType:SDLServiceTypeVideo payload:startVideoPayload.data completionHandler:^(BOOL success, NSError *error) {
            if (error) {
                SDLLogE(@"TLS setup error: %@", error);
                [self.videoStreamStateMachine transitionToState:SDLVideoStreamStateStopped];
            }
        }];
    } else {
        SDLLogD(@"Sending insecure video start service with payload: %@", startVideoPayload);
        [self.protocol startServiceWithType:SDLServiceTypeVideo payload:startVideoPayload.data];
    }
}


#pragma mark Setters / Getters

- (void)setRootViewController:(UIViewController *)rootViewController {
    if (self.focusableItemManager != nil) {
        self.focusableItemManager.viewController = rootViewController;
    }

    if (self.carWindow != nil) {
        self.carWindow.rootViewController = rootViewController;
    }
}

- (BOOL)isAppStateVideoStreamCapable {
    return [self.appStateMachine isCurrentState:SDLAppStateActive];
}

- (BOOL)isHmiStateAudioStreamCapable {
    return [self.hmiLevel isEqualToEnum:SDLHMILevelLimited] || [self.hmiLevel isEqualToEnum:SDLHMILevelFull];
}

- (BOOL)isHmiStateVideoStreamCapable {
    return [self.hmiLevel isEqualToEnum:SDLHMILevelLimited] || [self.hmiLevel isEqualToEnum:SDLHMILevelFull];
}

- (NSArray<SDLVideoStreamingFormat *> *)supportedFormats {
    SDLVideoStreamingFormat *h264raw = [[SDLVideoStreamingFormat alloc] initWithCodec:SDLVideoStreamingCodecH264 protocol:SDLVideoStreamingProtocolRAW];
    SDLVideoStreamingFormat *h264rtp = [[SDLVideoStreamingFormat alloc] initWithCodec:SDLVideoStreamingCodecH264 protocol:SDLVideoStreamingProtocolRTP];
    
    return @[h264raw, h264rtp];
}

@end

NS_ASSUME_NONNULL_END
