//
//  SDLStreamingVideoLifecycleManager.m
//  SmartDeviceLink
//
//  Created by Joel Fischer on 6/19/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import "SDLStreamingVideoLifecycleManager.h"

#import "CVPixelBufferRef+SDLUtil.h"
#import "SDLAppCapability.h"
#import "SDLCarWindow.h"
#import "SDLConfiguration.h"
#import "SDLConnectionManagerType.h"
#import "SDLControlFramePayloadConstants.h"
#import "SDLControlFramePayloadNak.h"
#import "SDLControlFramePayloadVideoStartService.h"
#import "SDLControlFramePayloadVideoStartServiceAck.h"
#import "SDLDisplayCapabilities.h"
#import "SDLFocusableItemLocator.h"
#import "SDLGenericResponse.h"
#import "SDLGetSystemCapability.h"
#import "SDLGetSystemCapabilityResponse.h"
#import "SDLGlobals.h"
#import "SDLH264VideoEncoder.h"
#import "SDLHMILevel.h"
#import "SDLImageResolution.h"
#import "SDLLifecycleConfiguration.h"
#import "SDLLogMacros.h"
#import "SDLOnAppCapabilityUpdated.h"
#import "SDLOnHMIStatus.h"
#import "SDLProtocol.h"
#import "SDLProtocolMessage.h"
#import "SDLPredefinedWindows.h"
#import "SDLRegisterAppInterfaceResponse.h"
#import "SDLRPCNotificationNotification.h"
#import "SDLRPCResponseNotification.h"
#import "SDLScreenParams.h"
#import "SDLStateMachine.h"
#import "SDLStreamingMediaConfiguration.h"
#import "SDLEncryptionConfiguration.h"
#import "SDLStreamingMediaManagerDataSource.h"
#import "SDLStreamingVideoScaleManager.h"
#import "SDLSystemCapability.h"
#import "SDLSystemCapabilityManager.h"
#import "SDLTouchManager.h"
#import "SDLVehicleType.h"
#import "SDLVideoEncoderDelegate.h"
#import "SDLVideoStreamingCapability.h"
#import "SDLOnSystemCapabilityUpdated.h"
#import "SDLStreamingMediaDelegate.h"
#import "SDLSupportedStreamingRange.h"

static NSUInteger const FramesToSendOnBackground = 30;

NS_ASSUME_NONNULL_BEGIN
#define WEAKIFY typeof(self) __weak weakSelf = self

typedef void(^SDLVideoCapabilityResponseHandler)(SDLVideoStreamingCapability *_Nullable capability);

@interface SDLStreamingVideoLifecycleManager() <SDLVideoEncoderDelegate>

@property (weak, nonatomic) id<SDLConnectionManagerType> connectionManager;
@property (weak, nonatomic, nullable) SDLSystemCapabilityManager *systemCapabilityManager;
@property (weak, nonatomic) SDLProtocol *protocol;

@property (assign, nonatomic, readonly, getter=isAppStateVideoStreamCapable) BOOL appStateVideoStreamCapable;
@property (assign, nonatomic, readonly, getter=isHmiStateVideoStreamCapable) BOOL hmiStateVideoStreamCapable;

@property (strong, nonatomic, readwrite) SDLStateMachine *videoStreamStateMachine;
@property (strong, nonatomic, readwrite) SDLStateMachine *appStateMachine;

@property (strong, nonatomic, readwrite, nullable) SDLVideoStreamingFormat *videoFormat;

@property (strong, nonatomic, nullable) SDLH264VideoEncoder *videoEncoder;
@property (strong, nonatomic) NSMutableDictionary *videoEncoderSettings;
@property (copy, nonatomic) NSDictionary<NSString *, id> *customEncoderSettings;
@property (copy, nonatomic) NSArray<NSString *> *secureMakes;
@property (copy, nonatomic, nullable) NSString *connectedVehicleMake;

@property (copy, nonatomic, readonly) NSString *appName;
@property (assign, nonatomic) CV_NULLABLE CVPixelBufferRef backgroundingPixelBuffer;

@property (strong, nonatomic, nullable) CADisplayLink *displayLink;
@property (assign, nonatomic) BOOL useDisplayLink;

@property (assign, nonatomic, readwrite, getter=isVideoEncrypted) BOOL videoEncrypted;

@property (strong, nonatomic, nullable) SDLVideoStreamingCapability *videoStreamingCapability;
@property (assign, nonatomic) BOOL shouldAutoResume;
@property (strong, nonatomic, nullable) SDLSupportedStreamingRange *supportedLandscapeStreamingRange;
@property (strong, nonatomic, nullable) SDLSupportedStreamingRange *supportedPortraitStreamingRange;
@property (weak, nonatomic, nullable) id<SDLStreamingMediaDelegate> delegate;

/**
 * SSRC of RTP header field.
 *
 * SSRC field identifies the source of a stream and it should be
 * chosen randomly (see section 3 and 5.1 in RFC 3550).
 *
 * @note A random value is generated and used as default.
 */
@property (assign, nonatomic) UInt32 ssrc;
@property (assign, nonatomic) CMTime lastPresentationTimestamp;

@property (copy, nonatomic, readonly) NSString *videoStreamBackgroundString;
@property (nonatomic, copy, nullable) void (^videoServiceEndedCompletionHandler)(void);

@property (strong, nonatomic, nullable) NSNotificationCenter *subscriptionCenter;
@end

@implementation SDLStreamingVideoLifecycleManager

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager configuration:(SDLConfiguration *)configuration systemCapabilityManager:(nullable SDLSystemCapabilityManager *)systemCapabilityManager {
    self = [super init];
    if (!self) {
        return nil;
    }

    _appName = configuration.lifecycleConfig.appName;
    _connectionManager = connectionManager;
    _systemCapabilityManager = systemCapabilityManager;
    _videoEncoderSettings = [NSMutableDictionary dictionary];
    [_videoEncoderSettings addEntriesFromDictionary: SDLH264VideoEncoder.defaultVideoEncoderSettings];
    _customEncoderSettings = configuration.streamingMediaConfig.customVideoEncoderSettings;
    _videoScaleManager = [[SDLStreamingVideoScaleManager alloc] init];

    _supportedLandscapeStreamingRange = configuration.streamingMediaConfig.supportedLandscapeStreamingRange;
    _supportedPortraitStreamingRange = configuration.streamingMediaConfig.supportedPortraitStreamingRange;

    if (configuration.streamingMediaConfig.rootViewController != nil) {
        NSAssert(configuration.streamingMediaConfig.enableForcedFramerateSync, @"When using CarWindow (rootViewController != nil), forceFrameRateSync must be YES");

        if (@available(iOS 9.0, *)) {
            SDLLogD(@"Initializing focusable item locator");
            _focusableItemManager = [[SDLFocusableItemLocator alloc] initWithViewController:configuration.streamingMediaConfig.rootViewController connectionManager:_connectionManager videoScaleManager:_videoScaleManager];
        }

        SDLLogD(@"Initializing CarWindow");
        _carWindow = [[SDLCarWindow alloc] initWithStreamManager:self configuration:configuration.streamingMediaConfig];
        _carWindow.rootViewController = configuration.streamingMediaConfig.rootViewController;
    }

    _touchManager = [[SDLTouchManager alloc] initWithHitTester:(id)_focusableItemManager videoScaleManager:_videoScaleManager];

    _delegate = configuration.streamingMediaConfig.delegate;
    _requestedEncryptionType = configuration.streamingMediaConfig.maximumDesiredEncryption;
    _dataSource = configuration.streamingMediaConfig.dataSource;
    _useDisplayLink = configuration.streamingMediaConfig.enableForcedFramerateSync;
    _backgroundingPixelBuffer = NULL;
    _showVideoBackgroundDisplay = YES;
    _preferredFormatIndex = 0;
    _preferredResolutionIndex = 0;

    _hmiLevel = SDLHMILevelNone;
    _videoStreamingState = SDLVideoStreamingStateNotStreamable;

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
    _videoStreamStateMachine = [[SDLStateMachine alloc] initWithTarget:self initialState:SDLVideoStreamManagerStateStopped states:[self.class sdl_videoStreamStateTransitionDictionary]];

    //NOTE: the notification center should not be default & dont forget to unsubscribe
    [self subscribeForNotifications:[NSNotificationCenter defaultCenter]];

    _ssrc = arc4random_uniform(UINT32_MAX);
    _lastPresentationTimestamp = kCMTimeInvalid;

    return self;
}

- (void)shutDown {
    [self.systemCapabilityManager unsubscribeObserver:self];
    [self unsubscribeFromAllNotifications];
}

- (void)dealloc {
    [self shutDown];
}

- (void)startWithProtocol:(SDLProtocol *)protocol {
    SDLLogD(@"Starting with protocol: %@", protocol);
    _protocol = protocol;
    [self.protocol addListener:self];
    [self.focusableItemManager start];

    // attempt to start streaming since we may already have necessary conditions met
    [self sdl_startVideoSession];
}

- (void)stop {
    SDLLogD(@"Stopping manager");

    _backgroundingPixelBuffer = NULL;
    _preferredFormatIndex = 0;
    _preferredResolutionIndex = 0;
    _lastPresentationTimestamp = kCMTimeInvalid;
    _hmiLevel = SDLHMILevelNone;
    _videoStreamingState = SDLVideoStreamingStateNotStreamable;
    [self.videoScaleManager stop];
    [self.focusableItemManager stop];
    _connectedVehicleMake = nil;

    [self.protocol removeListener:self];
    _protocol = nil;
    [self.videoStreamStateMachine transitionToState:SDLVideoStreamManagerStateStopped];
}

- (void)secondaryTransportDidDisconnect {
    SDLLogD(@"Stopping video manager");
    [self.focusableItemManager stop];
    [self.videoStreamStateMachine transitionToState:SDLVideoStreamManagerStateStopped];
}

- (void)endVideoServiceWithCompletionHandler:(void (^)(void))videoEndedCompletionHandler {
    SDLLogD(@"Ending video service");
    [self sdl_disposeDisplayLink];
    self.videoServiceEndedCompletionHandler = videoEndedCompletionHandler;
    [self.protocol endServiceWithType:SDLServiceTypeVideo];
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

#pragma mark Getters

- (BOOL)isVideoConnected {
    return [self.videoStreamStateMachine isCurrentState:SDLVideoStreamManagerStateReady];
}

- (BOOL)isVideoSuspended {
    return [self.videoStreamStateMachine isCurrentState:SDLVideoStreamManagerStateSuspended];
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

- (SDLVideoStreamManagerState *)currentVideoStreamState {
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
    if (self.protocol == nil) {
        SDLLogV(@"No session established with head unit. Ignoring app backgrounded notification");
        return;
    }

    if (_showVideoBackgroundDisplay) {
        [self sdl_sendBackgroundFrames];
    }
    [self suspendVideo];
}

// Per Apple's guidelines: https://developer.apple.com/library/content/documentation/iPhone/Conceptual/iPhoneOSProgrammingGuide/StrategiesforHandlingAppStateTransitions/StrategiesforHandlingAppStateTransitions.html
// We should be waiting to start any OpenGL drawing until UIApplicationDidBecomeActive is called.
- (void)didEnterStateAppActive {
    SDLLogD(@"App became active");
    [self resumeVideo];
}

- (void)resumeVideo {
    self.shouldAutoResume = NO;

    if (self.protocol == nil) {
        SDLLogV(@"No session established with head unit. Cannot continue video.");
        return;
    }

    if (self.isVideoSuspended) {
        [self.videoStreamStateMachine transitionToState:SDLVideoStreamManagerStateReady];
    } else {
        [self sdl_startVideoSession];
    }
}

- (void)suspendVideo {
    if (!self.protocol) {
        SDLLogV(@"No session established with head unit. Cannot suspend video.");
        return;
    }

    [self.touchManager cancelPendingTouches];

    if (self.isVideoConnected) {
        [self.videoStreamStateMachine transitionToState:SDLVideoStreamManagerStateSuspended];
    } else {
        [self sdl_stopVideoSession];
    }
}

#pragma mark Video Streaming
+ (NSDictionary<SDLState *, SDLAllowableStateTransitions *> *)sdl_videoStreamStateTransitionDictionary {
    return @{
             SDLVideoStreamManagerStateStopped : @[SDLVideoStreamManagerStateStarting],
             SDLVideoStreamManagerStateStarting : @[SDLVideoStreamManagerStateStopped, SDLVideoStreamManagerStateReady],
             SDLVideoStreamManagerStateReady : @[SDLVideoStreamManagerStateSuspended, SDLVideoStreamManagerStateShuttingDown, SDLVideoStreamManagerStateStopped],
             SDLVideoStreamManagerStateSuspended : @[SDLVideoStreamManagerStateReady, SDLVideoStreamManagerStateShuttingDown, SDLVideoStreamManagerStateStopped],
             SDLVideoStreamManagerStateShuttingDown : @[SDLVideoStreamManagerStateStopped]
             };
}

- (void)sdl_disposeDisplayLink {
    if (self.displayLink == nil) { return; }
    SDLLogD(@"Destroying display link");
    [self.displayLink invalidate];
    self.displayLink = nil;
}

#pragma mark - Video State Machine callbacks

- (void)didEnterStateVideoStreamStopped {
    SDLLogD(@"Video stream stopped");
    _videoEncrypted = NO;
    _videoFormat = nil;

    [self.systemCapabilityManager unsubscribeFromCapabilityType:SDLSystemCapabilityTypeVideoStreaming withObserver:self];

    if (_videoEncoder != nil) {
        [_videoEncoder stop];
        _videoEncoder = nil;
    }

    _backgroundingPixelBuffer = NULL;
    _preferredFormatIndex = 0;
    _preferredResolutionIndex = 0;
    _lastPresentationTimestamp = kCMTimeInvalid;

    [self sdl_disposeDisplayLink];

    [[NSNotificationCenter defaultCenter] postNotificationName:SDLVideoStreamDidStopNotification object:nil];

    if (self.videoServiceEndedCompletionHandler != nil) {
        self.videoServiceEndedCompletionHandler();
        self.videoServiceEndedCompletionHandler = nil;
    }

    if (self.shouldAutoResume) {
        self.shouldAutoResume = NO;
        [self.videoStreamStateMachine transitionToState:SDLVideoStreamManagerStateStarting];
    }
}

- (void)didEnterStateVideoStreamStarting {
    SDLLogD(@"Video stream starting");

    // unsubscribing and subscribing again makes the .systemCapabilityManager call and respond in the callback
    [self.systemCapabilityManager unsubscribeFromCapabilityType:SDLSystemCapabilityTypeVideoStreaming withObserver:self];
    [self.systemCapabilityManager subscribeToCapabilityType:SDLSystemCapabilityTypeVideoStreaming withObserver:self selector:@selector(sdl_displayCapabilityDidUpdate:)];
}

- (void)didEnterStateVideoStreamReady {
    SDLLogD(@"Video stream ready");

    if (self.videoEncoder != nil) {
        [self.videoEncoder stop];
        self.videoEncoder = nil;
    }

    [self sdl_disposeDisplayLink];

    [[NSNotificationCenter defaultCenter] postNotificationName:SDLVideoStreamDidStartNotification object:nil];

    if (!self.isAppStateVideoStreamCapable) {
        SDLLogD(@"App is in the background and can not stream video. Video will resume when app is foregrounded");
        [self.videoStreamStateMachine transitionToState:SDLVideoStreamManagerStateSuspended];
        return;
    }

    if (self.videoEncoder == nil) {
        NSError* error = nil;
        NSAssert(self.videoFormat != nil, @"No video format is known, but it must be if we got a protocol start service response");

        SDLLogD(@"Attempting to create video encoder");
        self.videoEncoder = [[SDLH264VideoEncoder alloc] initWithProtocol:self.videoFormat.protocol dimensions:self.videoScaleManager.appViewportFrame.size ssrc:self.ssrc properties:self.videoEncoderSettings delegate:self error:&error];

        if (error || self.videoEncoder == nil) {
            SDLLogE(@"Could not create a video encoder: %@", error);
            [self.videoStreamStateMachine transitionToState:SDLVideoStreamManagerStateStopped];
            return;
        }

        if (!self.backgroundingPixelBuffer) {
            CVPixelBufferRef backgroundingPixelBuffer = [self.videoEncoder newPixelBuffer];
            if (CVPixelBufferAddText(backgroundingPixelBuffer, self.videoStreamBackgroundString) == NO) {
                SDLLogE(@"Could not create a backgrounding frame");
                [self.videoStreamStateMachine transitionToState:SDLVideoStreamManagerStateStopped];
                return;
            }

            self.backgroundingPixelBuffer = backgroundingPixelBuffer;
        }
        self.lastPresentationTimestamp = kCMTimeInvalid;
    }

    if (self.useDisplayLink) {
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            NSInteger targetFramerate = ((NSNumber *)strongSelf.videoEncoderSettings[(__bridge NSString *)kVTCompressionPropertyKey_ExpectedFrameRate]).integerValue;
            SDLLogD(@"Initializing CADisplayLink with framerate: %ld", (long)targetFramerate);
            if (strongSelf.displayLink) {
                SDLLogW(@"The display link was not disposed in good time");
            }
            strongSelf.displayLink = [CADisplayLink displayLinkWithTarget:strongSelf selector:@selector(sdl_displayLinkFired:)];

            if (@available(iOS 10, *)) {
                strongSelf.displayLink.preferredFramesPerSecond = targetFramerate;
            } else {
                strongSelf.displayLink.frameInterval = (60 / targetFramerate);
            }
            [strongSelf.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        });
    } else {
        self.touchManager.enableSyncedPanning = NO;
    }
}

- (void)didEnterStateVideoStreamSuspended {
    SDLLogD(@"Video stream suspended");
    [self sdl_disposeDisplayLink];
    if (self.shouldAutoResume) {
        self.shouldAutoResume = NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.videoStreamingCapability) {
                [self sdl_applyVideoCapability:self.videoStreamingCapability];
            }
            [self resumeVideo];
        });
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:SDLVideoStreamSuspendedNotification object:nil];
}

- (void)didEnterStateVideoStreamShuttingDown {
    SDLLogD(@"Video stream shutting down");
    [self.protocol endServiceWithType:SDLServiceTypeVideo];
}

#pragma mark - SDLProtocolDelegate
#pragma mark Start Service ACK/NAK

- (void)protocol:(SDLProtocol *)protocol didReceiveStartServiceACK:(SDLProtocolMessage *)startServiceACK {
    if (startServiceACK.header.serviceType != SDLServiceTypeVideo) { return; }

    if (![self.videoStreamStateMachine.currentState isEqualToEnum:SDLVideoStreamManagerStateStarting]) {
        SDLLogW(@"Request to start video service ACKed in wrong state %@, skip", self.videoStreamStateMachine.currentState);
        return;
    }

    self.videoEncrypted = startServiceACK.header.encrypted;

    SDLControlFramePayloadVideoStartServiceAck *videoAckPayload = [[SDLControlFramePayloadVideoStartServiceAck alloc] initWithData:startServiceACK.payload];
    SDLLogD(@"Request to start video service ACKed on transport %@, with payload: %@", protocol.transport, videoAckPayload);

    if (videoAckPayload.mtu != SDLControlFrameInt64NotFound) {
        [[SDLGlobals sharedGlobals] setDynamicMTUSize:(NSUInteger)videoAckPayload.mtu forServiceType:SDLServiceTypeVideo];
    }

    // This is the definitive screen size that will be used
    if ((videoAckPayload.height != SDLControlFrameInt32NotFound || videoAckPayload.height != 0) && (videoAckPayload.width != SDLControlFrameInt32NotFound && videoAckPayload.width != 0)) {
        const float scale = self.videoScaleManager.scale;
        const CGSize ackSize = CGSizeMake(videoAckPayload.width, videoAckPayload.height);
        self.videoScaleManager.displayViewportResolution = CGSizeMake(ackSize.width * scale, ackSize.height * scale);
    } else if (self.preferredResolutions.count > 0) {
        // If a preferred resolution was set, use the first option to set the screen size
        SDLImageResolution *preferredResolution = self.preferredResolutions.firstObject;
        const CGSize newScreenSize = preferredResolution.makeSize;
        if (!CGSizeEqualToSize(self.videoScaleManager.displayViewportResolution, newScreenSize)) {
            SDLLogW(@"The preferred resolution does not match the screen dimensions returned by the Register App Interface Response. Video may look distorted or video may not show up on the head unit");
            self.videoScaleManager.displayViewportResolution = newScreenSize;
        }
    } // else we are using the screen size we got from the RAI earlier

    // Figure out the definitive format that will be used. If the protocol / codec weren't passed in the payload, it's probably a system that doesn't support those properties, which also means it's a system that requires H.264 RAW encoding
    self.videoFormat = [[SDLVideoStreamingFormat alloc] initWithCodec:videoAckPayload.videoCodec ?: SDLVideoStreamingCodecH264 protocol:videoAckPayload.videoProtocol ?: SDLVideoStreamingProtocolRAW];

    [self.videoStreamStateMachine transitionToState:SDLVideoStreamManagerStateReady];
}

- (void)protocol:(SDLProtocol *)protocol didReceiveStartServiceNAK:(SDLProtocolMessage *)startServiceNAK {
    if (startServiceNAK.header.serviceType != SDLServiceTypeVideo) { return; }

    if (![self.videoStreamStateMachine.currentState isEqualToEnum:SDLVideoStreamManagerStateStarting]) {
        SDLLogW(@"Request to start video service NAKed in wrong state %@, skip", self.videoStreamStateMachine.currentState);
        return;
    }

    SDLControlFramePayloadNak *nakPayload = [[SDLControlFramePayloadNak alloc] initWithData:startServiceNAK.payload];
    SDLLogE(@"Request to start video service NAKed on transport %@, with payload: %@", protocol.transport, nakPayload);

    // If we have no payload rejected params, we don't know what to do to retry, so we'll just stop and maybe cry
    if (nakPayload.rejectedParams.count == 0) {
        [self.videoStreamStateMachine transitionToState:SDLVideoStreamManagerStateStopped];
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

#pragma mark End Service ACK/NAK

- (void)protocol:(SDLProtocol *)protocol didReceiveEndServiceACK:(SDLProtocolMessage *)endServiceACK {
    if (endServiceACK.header.serviceType != SDLServiceTypeVideo) { return; }
    SDLLogD(@"Request to end video service ACKed on transport %@", protocol.transport);

    if (![self.videoStreamStateMachine.currentState isEqualToEnum:SDLVideoStreamManagerStateShuttingDown]) {
        SDLLogW(@"wrong state %@, skip", self.videoStreamStateMachine.currentState);
        return;
    }

    [self.videoStreamStateMachine transitionToState:SDLVideoStreamManagerStateStopped];
}

- (void)protocol:(SDLProtocol *)protocol didReceiveEndServiceNAK:(SDLProtocolMessage *)endServiceNAK {
    if (endServiceNAK.header.serviceType != SDLServiceTypeVideo) { return; }

    if (![self.videoStreamStateMachine.currentState isEqualToEnum:SDLVideoStreamManagerStateShuttingDown]) {
        SDLLogW(@"Request to end video service NAKed in wrong state %@, skip", self.videoStreamStateMachine.currentState);
        return;
    }

    SDLControlFramePayloadNak *nakPayload = [[SDLControlFramePayloadNak alloc] initWithData:endServiceNAK.payload];
    SDLLogE(@"Request to end video service NAKed on transport %@, with payload: %@", protocol.transport, nakPayload);

    /// Core will NAK the video end service control frame if video is not streaming or if video is streaming but the HMI does not recognize that video is streaming.
    [self.videoStreamStateMachine transitionToState:SDLVideoStreamManagerStateStopped];
}

#pragma mark - SDL RPC Notification callbacks

- (void)sdl_didReceiveRegisterAppInterfaceResponse:(SDLRPCResponseNotification *)notification {
    NSAssert([notification.response isKindOfClass:[SDLRegisterAppInterfaceResponse class]], @"A notification was sent with an unanticipated object");
    if (![notification.response isKindOfClass:[SDLRegisterAppInterfaceResponse class]]) {
        return;
    }

    SDLLogD(@"Received Register App Interface");
    SDLRegisterAppInterfaceResponse *registerResponse = (SDLRegisterAppInterfaceResponse *)notification.response;

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
    SDLImageResolution *resolution = registerResponse.displayCapabilities.screenParams.resolution;
#pragma clang diagnostic pop
    if (resolution != nil) {
        const CGSize initSize = CGSizeMake(resolution.resolutionWidth.floatValue, resolution.resolutionHeight.floatValue);
        // use initial size and default scale, it may change on video capabilities update
        self.videoScaleManager.displayViewportResolution = initSize;
        self.videoScaleManager.scale = 1;
        // HAX: Workaround for Legacy Ford and Lincoln displays with > 800 resolution width or height. They don't support scaling and if we don't do this workaround, they will not correctly scale the view.
        NSString *make = registerResponse.vehicleType.make;
        if (([make containsString:@"Ford"] || [make containsString:@"Lincoln"]) && (initSize.width > 800 || initSize.height > 800)) {
            self.videoScaleManager.scale = 1.0f / 0.75f; // Scale by 1.333333
        }
    }

    self.connectedVehicleMake = registerResponse.vehicleType.make;

    SDLLogD(@"Determined base screen size on display capabilities: %@", NSStringFromCGSize(self.videoScaleManager.displayViewportResolution));
}

/// Parses out the `hmiLevel` and `videoStreamingState` from an `OnHMIStatus` notification from Core. Since Core only allows video streaming when the `hmiLevel` is `FULL` or `LIMITED`, sending video data when the `hmiLevel` is not `FULL` or `LIMITED` will result in Core forcing an unregistration with a reason of `PROTOCOL_VIOLATION`.
/// 1. The `hmiLevel` will go to `FULL` when the user opens the SDL app by tapping on the SDL app icon on the HMI or uses a voice command to launch the SDL app.
/// 2. The `hmiLevel` will go to `LIMITED` when the user backgrounds the SDL app by opening another app or by going back to the home screen.
/// 3. The `hmiLevel` will go to `NONE` when the user "exits" the app (either through gesture or voice commands). It will also go to `NONE` if video fails to stream and the user presses "cancel" on the HMI popup. In these cases the transport between the phone and accessory will still be open. It will also go to `NONE` when the user disconnects the transport between the phone and accessory. In this case no notification will be recieved since the transport was disconnected.
/// 4. The `hmiLevel` will go to `BACKGROUND` if the app is in `LIMITED` and another app takes over video streaming capability (i.e. another navigation app's `hmiLevel` changes to `FULL`).
///
/// @param notification The `OnHMIStatus` notification
- (void)sdl_hmiStatusDidChange:(SDLRPCNotificationNotification *)notification {
    NSAssert([notification.notification isKindOfClass:[SDLOnHMIStatus class]], @"A notification was sent with an unanticipated object");
    if (![notification.notification isKindOfClass:[SDLOnHMIStatus class]]) {
        return;
    }

    SDLOnHMIStatus *hmiStatus = (SDLOnHMIStatus*)notification.notification;
    if (hmiStatus.windowID != nil && hmiStatus.windowID.integerValue != SDLPredefinedWindowsDefaultWindow) {
        return;
    }

    self.hmiLevel = hmiStatus.hmiLevel;

    SDLVideoStreamingState newState = hmiStatus.videoStreamingState ?: SDLVideoStreamingStateStreamable;
    if (![self.videoStreamingState isEqualToEnum:newState]) {
        SDLLogD(@"Video streaming state changed from %@ to %@", self.videoStreamingState, hmiStatus.videoStreamingState);
        self.videoStreamingState = newState;
    }

    // if startWithProtocol has not been called yet, abort here
    if (self.protocol == nil) {
        SDLLogW(@"No session established with head unit. HMI status is not relevant.");
        return;
    }

    if (self.isHmiStateVideoStreamCapable) {
        [self sdl_startVideoSession];
    } else {
        [self sdl_stopVideoSession];
    }
}

- (void)subscribeForNotifications:(NSNotificationCenter*)notificationCenter {
    if (!self.subscriptionCenter) {
        self.subscriptionCenter = notificationCenter;
        [notificationCenter addObserver:self selector:@selector(sdl_didReceiveRegisterAppInterfaceResponse:) name:SDLDidReceiveRegisterAppInterfaceResponse object:nil];
        [notificationCenter addObserver:self selector:@selector(sdl_hmiStatusDidChange:) name:SDLDidChangeHMIStatusNotification object:nil];
        [notificationCenter addObserver:self selector:@selector(sdl_appStateDidUpdate:) name:UIApplicationDidBecomeActiveNotification object:nil];
        [notificationCenter addObserver:self selector:@selector(sdl_appStateDidUpdate:) name:UIApplicationWillResignActiveNotification object:nil];
    }
}

- (void)unsubscribeFromAllNotifications {
    [self.subscriptionCenter removeObserver:self];
    self.subscriptionCenter = nil;
}

#pragma mark - Subscribed notifications

- (void)sdl_displayCapabilityDidUpdate:(SDLSystemCapability *)systemCapability {
    SDLVideoStreamingCapability *videoCapability = systemCapability.videoStreamingCapability;
    self.videoStreamingCapability = videoCapability;
    SDLLogD(@"Video capabilities notification received: %@", videoCapability);

    if ([self.videoStreamStateMachine.currentState isEqualToEnum:SDLVideoStreamManagerStateStarting]) {
        [self sdl_videoCapabilityDidUpdateStarting:videoCapability];
    }
    else if ([self.videoStreamStateMachine.currentState isEqualToEnum:SDLVideoStreamManagerStateReady]) {
        [self sdl_videoCapabilityDidUpdateReady:videoCapability];
    }
}

#pragma mark - Video capability logic

- (void)sdl_videoCapabilityDidUpdateStarting:(SDLVideoStreamingCapability*)videoCapability {
    WEAKIFY;

    NSArray<SDLVideoStreamingCapability *>* capabilityMatches = [self matchVideoCapability:videoCapability];

    SDLVideoStreamingCapability *matchedVideoCapability = [capabilityMatches firstObject];
    if (!matchedVideoCapability) {
        matchedVideoCapability = [videoCapability copy];
        matchedVideoCapability.additionalVideoStreamingCapabilities = nil;
    }
    if (!matchedVideoCapability) {
        // no capability, make a default one
    }
    self.videoStreamingCapability = matchedVideoCapability;

    // create and send SDLOnAppCapabilityUpdated notification
    SDLVideoStreamingCapability *appCapabilityMatch = [matchedVideoCapability copy];
    if (1 < capabilityMatches.count) {
        appCapabilityMatch.additionalVideoStreamingCapabilities = [capabilityMatches subarrayWithRange:NSMakeRange(1, capabilityMatches.count - 1)];
    } else { //TODO: remove this test case when done; add fake capabilities
        SDLVideoStreamingFormat *form1 = [[SDLVideoStreamingFormat alloc] initWithCodec:SDLVideoStreamingCodecH264 protocol:SDLVideoStreamingProtocolRAW];
        SDLVideoStreamingFormat *form2 = [[SDLVideoStreamingFormat alloc] initWithCodec:SDLVideoStreamingCodecH265 protocol:SDLVideoStreamingProtocolRTP];
        NSArray<SDLVideoStreamingFormat *> *formats = @[form1, form2];

        SDLImageResolution *res1 = [[SDLImageResolution alloc] initWithWidth:200 height:400];
        SDLVideoStreamingCapability *cap1 = [[SDLVideoStreamingCapability alloc] initWithPreferredResolution:res1 maxBitrate:1000001 supportedFormats:formats hapticDataSupported:YES diagonalScreenSize:1.0 pixelPerInch:100.0 scale:1.5];

        SDLImageResolution *res2 = [[SDLImageResolution alloc] initWithWidth:1024 height:768];
        SDLVideoStreamingCapability *cap2 = [[SDLVideoStreamingCapability alloc] initWithPreferredResolution:res2 maxBitrate:1000002 supportedFormats:formats hapticDataSupported:YES diagonalScreenSize:1.0 pixelPerInch:100.0 scale:2.0];

        SDLImageResolution *res3 = [[SDLImageResolution alloc] initWithWidth:640 height:480];
        SDLVideoStreamingCapability *cap3 = [[SDLVideoStreamingCapability alloc] initWithPreferredResolution:res3 maxBitrate:1000003 supportedFormats:formats hapticDataSupported:YES diagonalScreenSize:1.0 pixelPerInch:100.0 scale:3.0];

        appCapabilityMatch.additionalVideoStreamingCapabilities = @[cap1, cap2, cap3];
    }

    SDLAppCapability *appCapability = [[SDLAppCapability alloc] initWithVideoStreamingCapability:appCapabilityMatch];
    SDLOnAppCapabilityUpdated *notification = [[SDLOnAppCapabilityUpdated alloc] initWithAppCapability:appCapability];
    [self sdl_postRPCNotification:notification];

    if (matchedVideoCapability) {
        // match found, let the video service start
        const CGSize displaySize = matchedVideoCapability.makeImageResolution.makeSize;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.delegate videoStreamingSizeDidUpdate:displaySize];
        });

        [self sdl_applyVideoCapability:videoCapability];

        // Apply customEncoderSettings here. Note that value from HMI (such as maxBitrate) will be overwritten by custom settings.
        for (id key in self.customEncoderSettings.keyEnumerator) {
            self.videoEncoderSettings[key] = [self.customEncoderSettings valueForKey:key];
        }

        if (self.dataSource != nil) {
            SDLLogV(@"Calling data source for modified preferred resolutions");
            self.preferredResolutions = [self.dataSource resolutionFromHeadUnitPreferredResolution:self.preferredResolutions.firstObject];
            SDLLogD(@"Got specialized video resolutions: %@", self.preferredResolutions);
        }

        [self sdl_sendVideoStartService];
    } else {
        // match not found, full stop
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.delegate videoStreamingSizeDoesNotMatch];

            weakSelf.shouldAutoResume = NO; // just in case, at this point it must be NO any way
            [weakSelf.videoStreamStateMachine transitionToState:SDLVideoStreamManagerStateShuttingDown];
        });
    }
}

- (void)sdl_videoCapabilityDidUpdateReady:(SDLVideoStreamingCapability*)videoCapability {
    WEAKIFY;

    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.shouldAutoResume = YES;
        [weakSelf.videoStreamStateMachine transitionToState:SDLVideoStreamManagerStateShuttingDown];
        // videoStreamingCapability will be applied later when video resumes
    });
}

- (NSArray<SDLVideoStreamingCapability *>* __nullable)matchVideoCapability:(SDLVideoStreamingCapability*)videoStreamingCapability {
    if (!videoStreamingCapability) {
        return nil;
    }

    NSArray <SDLVideoStreamingCapability*>* allCapabilities = [videoStreamingCapability allVideoStreamingCapabilitiesPlain];

    if (!self.supportedLandscapeStreamingRange || !self.supportedPortraitStreamingRange) {
        // there is nothing to match, return any (1st) object
        return @[[allCapabilities firstObject]];
    }

    NSMutableArray *matchCapabilities = [NSMutableArray arrayWithCapacity:allCapabilities.count];
    for (SDLVideoStreamingCapability* nextCapability in allCapabilities) {
        SDLImageResolution *imageResolution = [nextCapability makeImageResolution];
        if ([self.supportedPortraitStreamingRange isImageResolutionInRange:imageResolution] ||
            [self.supportedLandscapeStreamingRange isImageResolutionInRange:imageResolution]) {
            [matchCapabilities addObject:nextCapability];
            continue;
        }

        const float diagonal = nextCapability.diagonalScreenSize.floatValue;
        if (0 < diagonal) {
            if (diagonal >= self.supportedPortraitStreamingRange.minimumDiagonal ||
                diagonal >= self.supportedLandscapeStreamingRange.minimumDiagonal) {
                [matchCapabilities addObject:nextCapability];
                continue;
            }
        }

        const float ratio = nextCapability.preferredResolution.normalizedAspectRatio;
        if (1 <= ratio) {
            if ([self.supportedPortraitStreamingRange isAspectRatioInRange:ratio] ||
                [self.supportedLandscapeStreamingRange isAspectRatioInRange:ratio]) {
                [matchCapabilities addObject:nextCapability];
                continue;
            }
        }
    }

    return matchCapabilities;
}

- (void)sdl_postRPCNotification:(SDLRPCNotification*)notification {
    [self.protocol sendRPC:notification];
}

#pragma mark - SDLVideoEncoderDelegate

- (void)videoEncoder:(SDLH264VideoEncoder *)encoder hasEncodedFrame:(NSData *)encodedVideo {
    SDLLogV(@"Video encoder encoded frame, sending data");
    // Do we care about app state here? I don't think so…
    BOOL capableVideoStreamState = [self.videoStreamStateMachine isCurrentState:SDLVideoStreamManagerStateReady];

    if (self.isHmiStateVideoStreamCapable && capableVideoStreamState) {
        if (self.isVideoEncrypted) {
            [self.protocol sendEncryptedRawData:encodedVideo onService:SDLServiceTypeVideo];
        } else {
            [self.protocol sendRawData:encodedVideo withServiceType:SDLServiceTypeVideo];
        }
    }
}

#pragma mark - Streaming session helpers

- (void)sdl_startVideoSession {
    SDLLogV(@"Attempting to start video session");
    if (self.protocol == nil) {
        SDLLogW(@"No transport established with head unit. Video start service request will not be sent.");
        return;
    }

    if (!self.isHmiStateVideoStreamCapable) {
        SDLLogV(@"SDL Core is not ready to stream video. Video start service request will not be sent.");
        return;
    }

    if (!self.isStreamingSupported) {
        SDLLogV(@"Streaming is not supported. Video start service request will not be sent.");
        return;
    }

    if ([self.videoStreamStateMachine isCurrentState:SDLVideoStreamManagerStateStopped] && self.isHmiStateVideoStreamCapable) {
        [self.videoStreamStateMachine transitionToState:SDLVideoStreamManagerStateStarting];
        return;
    }

    SDLLogE(@"Unable to send video start service request\n"
            "Video State must be in state STOPPED: %@\n"
            "HMI state must be LIMITED or FULL: %@\n",
            self.videoStreamStateMachine.currentState, self.hmiLevel);
}

- (void)sdl_stopVideoSession {
    SDLLogV(@"Attempting to stop video session");
    if (!self.isStreamingSupported) {
        SDLLogW(@"Head unit does not support video streaming. Will not send an end video service request");
        return;
    }

    if (self.isVideoConnected || self.isVideoSuspended) {
        [self.videoStreamStateMachine transitionToState:SDLVideoStreamManagerStateShuttingDown];
    } else {
        SDLLogW(@"No video is currently streaming. Will not send an end video service request.");
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
    SDLGetSystemCapability *getVideoCapabilityRequest = [[SDLGetSystemCapability alloc] initWithType:SDLSystemCapabilityTypeVideoStreaming subscribe:YES];

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
        [self.videoStreamStateMachine transitionToState:SDLVideoStreamManagerStateStopped];
        return;
    }

    SDLVideoStreamingFormat *preferredFormat = self.preferredFormats[self.preferredFormatIndex];
    SDLImageResolution *preferredResolution = self.preferredResolutions[self.preferredResolutionIndex];

    SDLControlFramePayloadVideoStartService *startVideoPayload = [[SDLControlFramePayloadVideoStartService alloc] initWithVideoHeight:preferredResolution.resolutionHeight.intValue width:preferredResolution.resolutionWidth.intValue protocol:preferredFormat.protocol codec:preferredFormat.codec];

    // Decide if we need to start a secure service or not
    if ((self.requestedEncryptionType != SDLStreamingEncryptionFlagNone) && ([self.secureMakes containsObject:self.connectedVehicleMake])) {
        SDLLogD(@"Sending secure video start service with payload: %@", startVideoPayload);
        [self.protocol startSecureServiceWithType:SDLServiceTypeVideo payload:startVideoPayload.data tlsInitializationHandler:^(BOOL success, NSError *error) {
            if (error) {
                SDLLogE(@"TLS setup error: %@", error);
                [self.videoStreamStateMachine transitionToState:SDLVideoStreamManagerStateStopped];
            }
        }];
    } else {
        SDLLogD(@"Sending insecure video start service with payload: %@", startVideoPayload);
        [self.protocol startServiceWithType:SDLServiceTypeVideo payload:startVideoPayload.data];
    }
}

- (void)sdl_applyVideoCapability:(SDLVideoStreamingCapability*)capability {
    self.videoStreamingCapability = capability;

    if (capability != nil) {
        self.videoScaleManager.scale = capability.scale.floatValue;
        self.videoScaleManager.displayViewportResolution = capability.preferredResolution.makeSize;
        SDLImageResolution *resolution = self.videoScaleManager.makeScaledResolution;

        // If we got a response, get the head unit's preferred formats and resolutions
        self.preferredFormats = capability.supportedFormats;
        self.preferredResolutions = @[resolution];
        if (capability.maxBitrate != nil) {
            self.videoEncoderSettings[(__bridge NSString *) kVTCompressionPropertyKey_AverageBitRate] = [[NSNumber alloc] initWithUnsignedLongLong:(capability.maxBitrate.unsignedLongLongValue * 1000)];
        }

        if (self.dataSource != nil) {
            SDLLogV(@"Calling data source for modified preferred formats");
            self.preferredFormats = [self.dataSource preferredVideoFormatOrderFromHeadUnitPreferredOrder:self.preferredFormats];
        }

        if (self.focusableItemManager != nil) {
            self.focusableItemManager.enableHapticDataRequests = capability.hapticSpatialDataSupported.boolValue;
        }

        SDLLogD(@"Got specialized video capabilites, preferred formats: %@, haptics %@", self.preferredFormats, (capability.hapticSpatialDataSupported.boolValue ? @"enabled" : @"disabled"));
    } else {
        // If no response, assume that the format is H264 RAW and get the screen resolution from the RAI response's display capabilities.
        SDLVideoStreamingFormat *format = [[SDLVideoStreamingFormat alloc] initWithCodec:SDLVideoStreamingCodecH264 protocol:SDLVideoStreamingProtocolRAW];
        SDLImageResolution *resolution = self.videoScaleManager.makeScaledResolution;
        self.preferredFormats = @[format];
        self.preferredResolutions = @[resolution];

        if (self.focusableItemManager != nil) {
            self.focusableItemManager.enableHapticDataRequests = NO;
        }

        SDLLogD(@"Using generic video capabilites, preferred formats: %@, resolutions: %@, haptics disabled", self.preferredFormats, self.preferredResolutions);
    }
}

#pragma mark Setters / Getters

- (void)setRootViewController:(nullable UIViewController *)viewController {
    self.focusableItemManager.viewController = viewController;
    self.carWindow.rootViewController = viewController;
}

- (nullable UIViewController *)rootViewController {
    return self.carWindow.rootViewController;
}

- (BOOL)isAppStateVideoStreamCapable {
    return [self.appStateMachine isCurrentState:SDLAppStateActive];
}

- (BOOL)isHmiStateVideoStreamCapable {
    return (![self.videoStreamingState isEqualToEnum:SDLVideoStreamingStateNotStreamable]
            && ([self.hmiLevel isEqualToEnum:SDLHMILevelLimited] || [self.hmiLevel isEqualToEnum:SDLHMILevelFull]));
}

- (NSArray<SDLVideoStreamingFormat *> *)supportedFormats {
    SDLVideoStreamingFormat *h264raw = [[SDLVideoStreamingFormat alloc] initWithCodec:SDLVideoStreamingCodecH264 protocol:SDLVideoStreamingProtocolRAW];
    SDLVideoStreamingFormat *h264rtp = [[SDLVideoStreamingFormat alloc] initWithCodec:SDLVideoStreamingCodecH264 protocol:SDLVideoStreamingProtocolRTP];

    return @[h264raw, h264rtp];
}

- (NSString *)videoStreamBackgroundString {
    return [NSString stringWithFormat:@"When it is safe to do so, open %@ on your phone", self.appName];
}

- (BOOL)isStreamingSupported {
    return (self.systemCapabilityManager != nil) ? [self.systemCapabilityManager isCapabilitySupported:SDLSystemCapabilityTypeVideoStreaming] : YES;
}

@end

#undef WEAKIFY
NS_ASSUME_NONNULL_END
