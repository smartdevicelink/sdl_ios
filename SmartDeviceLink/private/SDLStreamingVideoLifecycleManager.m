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
#import "SDLImageResolution+StreamingVideoExtensions.h"
#import "SDLLifecycleConfiguration.h"
#import "SDLLogMacros.h"
#import "SDLOnAppCapabilityUpdated.h"
#import "SDLOnHMIStatus.h"
#import "SDLOnSystemCapabilityUpdated.h"
#import "SDLProtocol.h"
#import "SDLProtocolMessage.h"
#import "SDLPredefinedWindows.h"
#import "SDLRegisterAppInterfaceResponse.h"
#import "SDLRPCNotificationNotification.h"
#import "SDLRPCResponseNotification.h"
#import "SDLScreenParams.h"
#import "SDLStateMachine.h"
#import "SDLStreamingVideoDelegate.h"
#import "SDLStreamingMediaConfiguration.h"
#import "SDLEncryptionConfiguration.h"
#import "SDLStreamingMediaManagerDataSource.h"
#import "SDLStreamingVideoScaleManager.h"
#import "SDLVideoStreamingRange.h"
#import "SDLSystemCapability.h"
#import "SDLSystemCapabilityManager.h"
#import "SDLSystemInfo.h"
#import "SDLTouchManager.h"
#import "SDLVehicleType.h"
#import "SDLVideoEncoderDelegate.h"
#import "SDLVideoStreamingCapability+StreamingVideoExtensions.h"

static NSUInteger const FramesToSendOnBackground = 30;

NS_ASSUME_NONNULL_BEGIN

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

@property (copy, nonatomic, readonly) NSString *appName;
@property (assign, nonatomic) CV_NULLABLE CVPixelBufferRef backgroundingPixelBuffer;

@property (strong, nonatomic, nullable) CADisplayLink *displayLink;
@property (assign, nonatomic) BOOL useDisplayLink;

@property (assign, nonatomic, readwrite, getter=isVideoEncrypted) BOOL videoEncrypted;

@property (strong, nonatomic, nullable) SDLVideoStreamingCapability *videoStreamingCapability;
@property (strong, nonatomic, nullable) SDLVideoStreamingCapability *videoStreamingCapabilityUpdated;
@property (assign, nonatomic) BOOL shouldAutoResume;
@property (assign, nonatomic) BOOL shouldSendOnAppCapabilityUpdated;
@property (assign, nonatomic) BOOL shouldUpdateDelegateOnSizeChange;
@property (strong, nonatomic, nullable) SDLVideoStreamingRange *supportedLandscapeStreamingRange;
@property (strong, nonatomic, nullable) SDLVideoStreamingRange *supportedPortraitStreamingRange;
@property (weak, nonatomic, nullable) id<SDLStreamingVideoDelegate> delegate;

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

@property (assign, nonatomic) BOOL isSubscribedForNotifications;
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

        SDLLogD(@"Initializing focusable item locator");
        _focusableItemManager = [[SDLFocusableItemLocator alloc] initWithViewController:configuration.streamingMediaConfig.rootViewController connectionManager:_connectionManager videoScaleManager:_videoScaleManager];

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

    [self sdl_subscribeToNotifications];

    _ssrc = arc4random_uniform(UINT32_MAX);
    _lastPresentationTimestamp = kCMTimeInvalid;

    return self;
}

- (void)sdl_shutDown {
    [self.systemCapabilityManager unsubscribeFromCapabilityType:SDLSystemCapabilityTypeVideoStreaming withObserver:self];
    [self sdl_unsubscribeNotifications];
}

- (void)dealloc {
    [self sdl_shutDown];
}

- (void)startWithProtocol:(SDLProtocol *)protocol {
    SDLLogD(@"Starting with protocol: %@", protocol);
    _protocol = protocol;
    @synchronized(self.protocol.protocolDelegateTable) {
        if (![self.protocol.protocolDelegateTable containsObject:self]) {
            [self.protocol.protocolDelegateTable addObject:self];
        }
    }
    [self.focusableItemManager start];
    self.shouldSendOnAppCapabilityUpdated = YES;

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

    @synchronized(self.protocol.protocolDelegateTable) {
        if ([self.protocol.protocolDelegateTable containsObject:self]) {
            [self.protocol.protocolDelegateTable removeObject:self];
        }
    }
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
    [self sdl_suspendVideo];
}

// Per Apple's guidelines: https://developer.apple.com/library/content/documentation/iPhone/Conceptual/iPhoneOSProgrammingGuide/StrategiesforHandlingAppStateTransitions/StrategiesforHandlingAppStateTransitions.html
// We should be waiting to start any OpenGL drawing until UIApplicationDidBecomeActive is called.
- (void)didEnterStateAppActive {
    SDLLogD(@"App became active");
    [self sdl_resumeVideo];
}

- (void)sdl_resumeVideo {
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

- (void)sdl_suspendVideo {
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
             SDLVideoStreamManagerStateStarting : @[SDLVideoStreamManagerStateStopped, SDLVideoStreamManagerStateReady, SDLVideoStreamManagerStateSuspended],
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
    self.shouldUpdateDelegateOnSizeChange = NO;

    if (!self.shouldAutoResume) {
        [self.systemCapabilityManager unsubscribeFromCapabilityType:SDLSystemCapabilityTypeVideoStreaming withObserver:self];
    }

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
        [self.videoStreamStateMachine transitionToState:SDLVideoStreamManagerStateStarting];
    }
}

- (void)didEnterStateVideoStreamStarting {
    SDLLogD(@"Video stream starting");

    const BOOL applyCapabilities = self.shouldAutoResume && (self.videoStreamingCapabilityUpdated != nil);
    if (applyCapabilities) {
        //apply previously received video capabilities
        [self sdl_applyVideoCapabilityWhileStarting:self.videoStreamingCapabilityUpdated];
    }
    self.shouldAutoResume = NO;
    self.videoStreamingCapabilityUpdated = nil;
    if (!applyCapabilities) {
        [self.systemCapabilityManager subscribeToCapabilityType:SDLSystemCapabilityTypeVideoStreaming withObserver:self selector:@selector(sdl_videoStreamingCapabilityDidUpdate:)];
    }
}

- (void)didEnterStateVideoStreamReady {
    SDLLogD(@"Video stream ready");

    if ([self.currentAppState isEqual:SDLAppStateInactive]) {
        SDLLogD(@"Video streaming will not start until the app becomes active");
        [self.videoStreamStateMachine transitionToState:SDLVideoStreamManagerStateSuspended];
        return;
    }

    if (self.videoEncoder != nil) {
        [self.videoEncoder stop];
        self.videoEncoder = nil;
    }

    [self sdl_disposeDisplayLink];

    [[NSNotificationCenter defaultCenter] postNotificationName:SDLVideoStreamDidStartNotification object:nil];

    // Don't update the delegate if video is resuming after being suspended.
    if (self.shouldUpdateDelegateOnSizeChange && self.delegate != nil) {
        const CGSize displaySize = self.videoStreamingCapability.makeImageResolution.makeSize;
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.delegate videoStreamingSizeDidUpdate:displaySize];
        });
    }
    self.shouldUpdateDelegateOnSizeChange = NO;

    if (!self.isAppStateVideoStreamCapable) {
        SDLLogD(@"App is in the background and can not stream video. Video will resume when app is foregrounded");
        [self.videoStreamStateMachine transitionToState:SDLVideoStreamManagerStateSuspended];
        return;
    }

    if (self.videoEncoder == nil) {
        NSError* error = nil;
        NSAssert(self.videoFormat != nil, @"No video format is known, but it must be if we got a protocol start service response");

        const CGSize dimensions = self.videoScaleManager.appViewportFrame.size;
        SDLLogD(@"Attempting to create video encoder (dimensions: %@; protocol: %@)", NSStringFromCGSize(dimensions), self.videoFormat.protocol);
        self.videoEncoder = [[SDLH264VideoEncoder alloc] initWithProtocol:self.videoFormat.protocol dimensions:dimensions ssrc:self.ssrc properties:self.videoEncoderSettings delegate:self error:&error];

        if (error || self.videoEncoder == nil) {
            SDLLogE(@"Could not create a video encoder: %@", error);
            [self.videoStreamStateMachine transitionToState:SDLVideoStreamManagerStateStopped];
            return;
        }

        if (!self.backgroundingPixelBuffer) {
            CVPixelBufferRef backgroundingPixelBuffer = [self.videoEncoder newPixelBuffer];
            if (!CVPixelBufferAddText(backgroundingPixelBuffer, self.videoStreamBackgroundString)) {
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
            strongSelf.displayLink.preferredFramesPerSecond = targetFramerate;
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
        SDLVideoStreamingCapability *capability = (self.videoStreamingCapabilityUpdated == nil) ? self.videoStreamingCapability : self.videoStreamingCapabilityUpdated;
        typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (capability) {
                [weakSelf sdl_applyVideoCapability:capability];
            }
            [weakSelf sdl_resumeVideo];
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

    // Video is ready to stream. If the app is inactive and can't stream video, then the Ready state will handle transitioning to the Suspended state
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
        SDLLogW(@"end service in wrong state %@", self.videoStreamStateMachine.currentState);
    }

    [self.videoStreamStateMachine transitionToState:SDLVideoStreamManagerStateStopped];
}

- (void)protocol:(SDLProtocol *)protocol didReceiveEndServiceNAK:(SDLProtocolMessage *)endServiceNAK {
    if (endServiceNAK.header.serviceType != SDLServiceTypeVideo) { return; }

    if (![self.videoStreamStateMachine.currentState isEqualToEnum:SDLVideoStreamManagerStateShuttingDown]) {
        SDLLogW(@"Request to end video service NAKed in wrong state %@", self.videoStreamStateMachine.currentState);
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

    SDLLogV(@"Received Register App Interface");
    SDLRegisterAppInterfaceResponse *registerResponse = (SDLRegisterAppInterfaceResponse *)notification.response;

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
    SDLImageResolution *resolution = registerResponse.displayCapabilities.screenParams.resolution;
#pragma clang diagnostic pop
    if (resolution) {
        const CGSize initSize = resolution.makeSize;
        // use initial size and default scale, it may change on video capabilities update
        self.videoScaleManager.displayViewportResolution = initSize;
        self.videoScaleManager.scale = 1;
        // HAX: Workaround for Legacy Ford and Lincoln displays with > 800 resolution width or height. They don't support scaling and if we don't do this workaround, they will not correctly scale the view.
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
        NSString *make = registerResponse.vehicleType.make;
#pragma clang diagnostic pop
        CGSize resolution = self.videoScaleManager.displayViewportResolution;
        if (([make containsString:@"Ford"] || [make containsString:@"Lincoln"]) && (resolution.width > 800 || resolution.height > 800)) {
            self.videoScaleManager.scale = 1.0f / 0.75f; // Scale by 1.333333
        }
    } else {
        self.videoScaleManager.displayViewportResolution = CGSizeZero;
        self.videoScaleManager.scale = 1;
    }

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

- (void)sdl_subscribeToNotifications {
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    if (!self.isSubscribedForNotifications) {
        self.isSubscribedForNotifications = YES;
        [notificationCenter addObserver:self selector:@selector(sdl_didReceiveRegisterAppInterfaceResponse:) name:SDLDidReceiveRegisterAppInterfaceResponse object:nil];
        [notificationCenter addObserver:self selector:@selector(sdl_hmiStatusDidChange:) name:SDLDidChangeHMIStatusNotification object:nil];
        [notificationCenter addObserver:self selector:@selector(sdl_appStateDidUpdate:) name:UIApplicationDidBecomeActiveNotification object:nil];
        [notificationCenter addObserver:self selector:@selector(sdl_appStateDidUpdate:) name:UIApplicationWillResignActiveNotification object:nil];
    }
}

- (void)sdl_unsubscribeNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.isSubscribedForNotifications = NO;
}

#pragma mark - Subscribed notifications

- (void)sdl_videoStreamingCapabilityDidUpdate:(SDLSystemCapability *)systemCapability {
    SDLVideoStreamingCapability *videoCapability = systemCapability.videoStreamingCapability;

    if (videoCapability) {
        SDLLogD(@"Video capabilities notification received (%@): %@", self.videoStreamStateMachine.currentState, videoCapability);
        [self sdl_useVideoCapability:videoCapability];
    } else {
        SDLLogD(@"Empty video capabilities notification received (%@)", self.videoStreamStateMachine.currentState);
        // If no response, assume that the format is H264 RAW and get the screen resolution from the RAI response's display capabilities.
        SDLVideoStreamingFormat *format = [[SDLVideoStreamingFormat alloc] initWithCodec:SDLVideoStreamingCodecH264 protocol:SDLVideoStreamingProtocolRAW];
        SDLImageResolution *resolution = [[SDLImageResolution alloc] initWithWidth:(uint16_t)self.videoScaleManager.displayViewportResolution.width height:(uint16_t)self.videoScaleManager.displayViewportResolution.height];
        self.preferredFormats = @[format];
        self.preferredResolutions = @[resolution];
        if (self.focusableItemManager != nil) {
            self.focusableItemManager.enableHapticDataRequests = NO;
        }
        SDLLogD(@"Using generic video capabilites, preferred formats: %@, resolutions: %@, haptics disabled", self.preferredFormats, self.preferredResolutions);

        // HAX: to support legacy head units (SYNC 3.0) as a slight delay is needed between getting the `OnHMIStatus` notification and sending the video `StartService`. Otherwise, video will stream but the screen will be black. Add the delay here as legacy head units do not support `videoStreamingCapability`. 
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 250 * NSEC_PER_MSEC), dispatch_get_main_queue(), ^{
             [self sdl_useVideoCapability:nil];
        });
    }
}

#pragma mark - Video capability logic

- (void)sdl_useVideoCapability:(nullable SDLVideoStreamingCapability *)videoCapability {
    if ([self.currentVideoStreamState isEqualToEnum:SDLVideoStreamManagerStateStarting]) {
        [self sdl_applyVideoCapabilityWhileStarting:videoCapability];
    } else if ([self.currentVideoStreamState isEqualToEnum:SDLVideoStreamManagerStateReady] || [self.currentVideoStreamState isEqualToEnum:SDLVideoStreamManagerStateSuspended]) {
        [self sdl_applyVideoCapabilityWhenStreaming:videoCapability];
    } else {
        SDLLogD(@"Received video capabilities in wrong state: %@; ignore it", self.videoStreamStateMachine.currentState);
    }
}

- (void)sdl_applyVideoCapabilityWhileStarting:(nullable SDLVideoStreamingCapability *)videoCapabilityUpdated {
    SDLVideoStreamingCapability *videoCapability = (videoCapabilityUpdated == nil) ? [self sdl_defaultVideoCapability] : videoCapabilityUpdated;
    NSArray<SDLVideoStreamingCapability *> *capabilityMatches = [self matchVideoCapability:videoCapability];
    if (capabilityMatches.count == 0) {
        // no supported video capabilities, full stop
        SDLLogE(@"The video stream was not started because there are no supported video streaming capabilities. Please double check that the video streaming ranges set on the SDLStreamingMediaConfiguration are not disabled");
        [self.videoStreamStateMachine transitionToState:SDLVideoStreamManagerStateStopped];
        return;
    }

    if (self.shouldSendOnAppCapabilityUpdated) {
        self.shouldSendOnAppCapabilityUpdated = NO;
        [self sdl_sendOnAppCapabilityUpdated:capabilityMatches];
    }

    SDLVideoStreamingCapability *matchedVideoCapability = capabilityMatches.firstObject;
    if (capabilityMatches.count > 1) {
        // add the remaining capabilities that match video streaming criteria
        matchedVideoCapability.additionalVideoStreamingCapabilities = [capabilityMatches subarrayWithRange:NSMakeRange(1, capabilityMatches.count - 1)];
    } else {
        // add any other possible capabilities here if needed
        matchedVideoCapability.additionalVideoStreamingCapabilities = @[];
    }

    // take formats from 'parent' if absent in children
    if (!matchedVideoCapability.supportedFormats) {
        matchedVideoCapability.supportedFormats = videoCapabilityUpdated.supportedFormats;
    }
    if (matchedVideoCapability.maxBitrate == nil) {
        matchedVideoCapability.maxBitrate = videoCapabilityUpdated.maxBitrate;
    }
    if (matchedVideoCapability.preferredFPS == nil) {
        matchedVideoCapability.preferredFPS = videoCapabilityUpdated.preferredFPS;
    }

    [self sdl_applyVideoCapability:matchedVideoCapability];
    self.shouldUpdateDelegateOnSizeChange = YES;

    // start service with new capabilities or without (use old from start service ACK)
    [self sdl_sendVideoStartService];
}

- (void)sdl_sendOnAppCapabilityUpdated:(nullable NSArray<SDLVideoStreamingCapability *> *)supportedVideoStreamingCapabilities {
    // create and send SDLOnAppCapabilityUpdated notification
    SDLVideoStreamingCapability *notifyCapability = [[SDLVideoStreamingCapability alloc] init];
    notifyCapability.additionalVideoStreamingCapabilities = supportedVideoStreamingCapabilities ?: @[];
    SDLAppCapability *appCapability = [[SDLAppCapability alloc] initWithAppCapabilityType:SDLAppCapabilityTypeVideoStreaming videoStreamingCapability:notifyCapability];
    SDLOnAppCapabilityUpdated *notification = [[SDLOnAppCapabilityUpdated alloc] initWithAppCapability:appCapability];
    [self.connectionManager sendConnectionRPC:notification];
}

- (void)sdl_applyVideoCapabilityWhenStreaming:(nullable SDLVideoStreamingCapability *)videoCapability {
    if (!videoCapability) {
        // continue streaming though core may expect something different
        SDLLogD(@"Nil video capability received, ignore it (do not restart)");
        return;
    }
    // try to validate absent fields taking ones from the current capability
    if (!videoCapability.scale) {
        videoCapability.scale = self.videoStreamingCapability.scale;
        if (!videoCapability.scale) {
            videoCapability.scale = @1.0;
        }
    }
    if (!videoCapability.diagonalScreenSize) {
        videoCapability.diagonalScreenSize = self.videoStreamingCapability.diagonalScreenSize;
    }
    if (!videoCapability.pixelPerInch) {
        videoCapability.pixelPerInch = self.videoStreamingCapability.pixelPerInch;
    }
    if (!videoCapability.preferredResolution) {
        SDLLogD(@"Nil video capability received, no preffered resolution");
        videoCapability.preferredResolution = self.videoStreamingCapability.preferredResolution;
    }
    if (!videoCapability.maxBitrate) {
        videoCapability.maxBitrate = self.videoStreamingCapability.maxBitrate;
    }
    if (!videoCapability.hapticSpatialDataSupported) {
        videoCapability.hapticSpatialDataSupported = self.videoStreamingCapability.hapticSpatialDataSupported;
    }
    if (!videoCapability.preferredFPS) {
        videoCapability.preferredFPS = self.videoStreamingCapability.preferredFPS;
    }
    if (videoCapability.supportedFormats.count == 0) {
        if (self.videoFormat) {
            // video format may not come, use the previous one instead
            SDLLogD(@"Video capability received, no supported formats, trying to fix");
            videoCapability.supportedFormats = @[self.videoFormat];
        } else {
            // continue streaming though core may expect something different
            SDLLogD(@"Video capability received, no supported formats, ignore it (do not restart)");
            return;
        }
    }

    self.videoStreamingCapabilityUpdated = videoCapability;
    __weak typeof(self) weakSelf = self;
    // restart video session on capability update
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.shouldAutoResume = YES;
        [weakSelf.videoStreamStateMachine transitionToState:SDLVideoStreamManagerStateShuttingDown];
        // videoStreamingCapability will be applied later when video resumes
    });
}

- (NSArray<SDLVideoStreamingCapability *>* __nullable)matchVideoCapability:(SDLVideoStreamingCapability *)videoStreamingCapability {
    if (!videoStreamingCapability) {
        return @[];
    }

    NSArray <SDLVideoStreamingCapability*> *allCapabilities = [videoStreamingCapability allVideoStreamingCapabilities];
    NSMutableArray *matchCapabilities = [NSMutableArray arrayWithCapacity:allCapabilities.count];
    for (SDLVideoStreamingCapability *nextCapability in allCapabilities) {
        SDLImageResolution *imageResolution = [nextCapability makeImageResolution];
        BOOL isMatch = NO;
        switch (imageResolution.kind) {
            case SDLImageResolutionKindLandscape:
                isMatch = [self sdl_isCapability:nextCapability inRange:self.supportedLandscapeStreamingRange];
                break;

            case SDLImageResolutionKindPortrait:
                isMatch = [self sdl_isCapability:nextCapability inRange:self.supportedPortraitStreamingRange];
                break;

            case SDLImageResolutionKindSquare:
                isMatch = [self sdl_isCapability:nextCapability inRange:self.supportedLandscapeStreamingRange] ||
                            [self sdl_isCapability:nextCapability inRange:self.supportedPortraitStreamingRange];
                break;

            case SDLImageResolutionKindUndefined:
            default:
                // wrong capability, filter it out
                break;
        }

        if (isMatch) {
            [matchCapabilities addObject:nextCapability];
        }
    }

    return matchCapabilities;
}

- (BOOL)sdl_isCapability:(SDLVideoStreamingCapability *)capability inRange:(SDLVideoStreamingRange *)range {
    if (!capability) {
        // sanity check, zero capability wont make through
        return NO;
    }
    if (!range) {
        // no range, no restriction - any capability will do
        return YES;
    }

    // 1. resolution test: min <= resolution <= max
    if ([self sdl_isImageResolutionRangeValid:range]) {
        SDLImageResolution *imageResolution = [capability makeImageResolution];
        if (![range isImageResolutionInRange:imageResolution]) {
            return NO;
        }
    }

    // 2. diagonal test: diagonal is above or equal to the minimumDiagonal
    if (capability.diagonalScreenSize) {
        const float diagonal = capability.diagonalScreenSize.floatValue;
        if ((0 < diagonal) && (0 < range.minimumDiagonal)) {
            if (diagonal < range.minimumDiagonal) {
                return NO;
            }
        }
    }

    // 3. diagonal test: aspect ratio is within the specified range
    if (capability.preferredResolution) {
        const float ratio = capability.preferredResolution.normalizedAspectRatio;
        if (1 <= ratio) {
            if (![range isAspectRatioInRange:ratio]) {
                return NO;
            }
        }
    }
    // by this point the capability has passed all the restrictions
    return YES;
}

- (BOOL)sdl_isImageResolutionRangeValid:(SDLVideoStreamingRange *)range {
    return (range.minimumResolution != nil || range.maximumResolution != nil);
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
    SDLLogV(@"DisplayLink frame fired, duration: %f, last frame timestamp: %f, target timestamp: %f", displayLink.duration, displayLink.timestamp, displayLink.targetTimestamp);

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

/**
 Pull the current format / resolution out of our preferred resolutions and craft a start video service payload out of it, then send a start service. If the format isn't one that we support, we're going to try the next format.
 */
- (void)sdl_sendVideoStartService {
    SDLLogV(@"Attempting to find preferred format");
    while (self.preferredFormatIndex < self.preferredFormats.count) {
        SDLVideoStreamingFormat *format = self.preferredFormats[self.preferredFormatIndex];
        if ([self.supportedFormats containsObject:format]) {
            SDLLogV(@"Preferred format index found: %lu", self.preferredFormatIndex);
            break;
        }
        self.preferredFormatIndex++;
    }

    // If this fails we have no known formats to use
    if (self.preferredFormatIndex >= self.preferredFormats.count
        || self.preferredResolutionIndex >= self.preferredResolutions.count) {
        SDLLogE(@"No preferred format or no preferred resolution found that works: format index %lu, resolution index %lu", (unsigned long)self.preferredFormatIndex, (unsigned long)self.preferredResolutionIndex);
        self.shouldAutoResume = NO;
        [self.videoStreamStateMachine transitionToState:SDLVideoStreamManagerStateStopped];
        return;
    }

    SDLVideoStreamingFormat *preferredFormat = self.preferredFormats[self.preferredFormatIndex];
    SDLImageResolution *preferredResolution = self.preferredResolutions[self.preferredResolutionIndex];

    SDLControlFramePayloadVideoStartService *startVideoPayload = [[SDLControlFramePayloadVideoStartService alloc] initWithVideoHeight:preferredResolution.resolutionHeight.intValue width:preferredResolution.resolutionWidth.intValue protocol:preferredFormat.protocol codec:preferredFormat.codec];

    // Decide if we need to start a secure service or not
    NSString *connectedVehicleMake = self.connectionManager.systemInfo.vehicleType.make;
    if ((self.requestedEncryptionType != SDLStreamingEncryptionFlagNone) && ([self.secureMakes containsObject:connectedVehicleMake])) {
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

- (void)sdl_applyVideoCapability:(SDLVideoStreamingCapability *)capability {
    assert(capability != nil);

    self.videoStreamingCapability = capability;
    self.focusableItemManager.enableHapticDataRequests = capability.hapticSpatialDataSupported.boolValue;
    self.videoScaleManager.scale = capability.scale.floatValue;
    self.videoScaleManager.displayViewportResolution = capability.preferredResolution.makeSize;

    if (capability.maxBitrate != nil) {
        const uint64_t bitrate = capability.maxBitrate.unsignedLongLongValue * 1000;
        self.videoEncoderSettings[(id)kVTCompressionPropertyKey_AverageBitRate] = @(bitrate);
    }
    if (capability.preferredFPS != nil) {
        self.videoEncoderSettings[(id)kVTCompressionPropertyKey_ExpectedFrameRate] = capability.preferredFPS;
    }

    // Apply customEncoderSettings here. Note that value from HMI (such as maxBitrate) will be overwritten by custom settings
    // (Exception: ExpectedFrameRate, AverageBitRate)
    for (id key in self.customEncoderSettings.keyEnumerator) {
        // Do *not* override framerate or average bitrate if custom setting is higher than current setting.
        // See SDL 0323 (https://github.com/smartdevicelink/sdl_evolution/blob/master/proposals/0323-align-VideoStreamingParameter-with-capability.md) for details.
        if (([(NSString *)key isEqualToString:(__bridge NSString *)kVTCompressionPropertyKey_ExpectedFrameRate] && capability.preferredFPS != nil) ||
            ([(NSString *)key isEqualToString:(__bridge NSString *)kVTCompressionPropertyKey_AverageBitRate] && capability.maxBitrate != nil)) {
            NSNumber *customEncoderSettings = (NSNumber *)self.customEncoderSettings[key];
            NSNumber *videoEncoderSettings = (NSNumber *)self.videoEncoderSettings[key];
            if (customEncoderSettings.doubleValue < videoEncoderSettings.doubleValue) {
                self.videoEncoderSettings[key] = customEncoderSettings;
            }
        } else {
            self.videoEncoderSettings[key] = [self.customEncoderSettings valueForKey:key];
        }
    }

    // If we got a response, get the head unit's preferred formats and resolutions
    NSArray<SDLImageResolution *> *resolutions = [capability allImageResolutionsScaled];
    NSArray<SDLVideoStreamingFormat *> *supportedFormats = capability.supportedFormats;
    if (self.dataSource) {
        SDLLogV(@"Calling data source for modified preferred resolutions");
        self.preferredResolutions = [self.dataSource resolutionFromHeadUnitPreferredResolution:resolutions.firstObject];
        SDLLogD(@"Got specialized video resolutions: %@", self.preferredResolutions);

        SDLLogV(@"Calling data source for modified preferred formats");
        self.preferredFormats = [self.dataSource preferredVideoFormatOrderFromHeadUnitPreferredOrder:supportedFormats];
    } else {
        self.preferredResolutions = resolutions;
        self.preferredFormats = supportedFormats;
    }

    SDLLogD(@"Got specialized video capabilites, preferred formats: %@, haptics %@", self.preferredFormats, (capability.hapticSpatialDataSupported.boolValue ? @"enabled" : @"disabled"));
}

- (SDLVideoStreamingCapability *)sdl_defaultVideoCapability {
    SDLVideoStreamingFormat *format = self.supportedFormats.firstObject;
    SDLImageResolution *resolution = self.videoScaleManager.makeScaledResolution;
    SDLVideoStreamingCapability *defaultCapability = [[SDLVideoStreamingCapability alloc] initWithPreferredResolution:resolution maxBitrate:nil supportedFormats:@[format] hapticSpatialDataSupported:nil diagonalScreenSize:nil pixelPerInch:nil scale:@(self.videoScaleManager.scale) preferredFPS:nil];
    return defaultCapability;
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

NS_ASSUME_NONNULL_END
