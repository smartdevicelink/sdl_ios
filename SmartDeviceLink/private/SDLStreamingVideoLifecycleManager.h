//
//  SDLStreamingVideoLifecycleManager.h
//  SmartDeviceLink
//
//  Created by Joel Fischer on 6/19/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <VideoToolbox/VideoToolbox.h>

#import "SDLHMILevel.h"
#import "SDLProtocolDelegate.h"
#import "SDLStreamingMediaManagerConstants.h"
#import "SDLVideoStreamingFormat.h"
#import "SDLVideoStreamingState.h"

@class SDLCarWindow;
@class SDLConfiguration;
@class SDLImageResolution;
@class SDLProtocol;
@class SDLStateMachine;
@class SDLStreamingVideoScaleManager;
@class SDLSystemCapabilityManager;
@class SDLTouchManager;

@protocol SDLConnectionManagerType;
@protocol SDLFocusableItemLocatorType;
@protocol SDLStreamingMediaManagerDataSource;


NS_ASSUME_NONNULL_BEGIN

@interface SDLStreamingVideoLifecycleManager : NSObject <SDLProtocolDelegate>

@property (strong, nonatomic, readonly) SDLStateMachine *videoStreamStateMachine;
@property (strong, nonatomic, readonly) SDLVideoStreamManagerState *currentVideoStreamState;

@property (strong, nonatomic, readonly) SDLStateMachine *appStateMachine;
@property (strong, nonatomic, readonly) SDLAppState *currentAppState;
@property (copy, nonatomic, nullable) SDLHMILevel hmiLevel;
@property (copy, nonatomic, nullable) SDLVideoStreamingState videoStreamingState;

/**
 *  Touch Manager responsible for providing touch event notifications.
 */
@property (nonatomic, strong, readonly) SDLTouchManager *touchManager;
@property (nonatomic, strong, nullable) UIViewController *rootViewController;
@property (strong, nonatomic, readonly, nullable) SDLCarWindow *carWindow;

/**
 A haptic interface that can be updated to reparse views within the window you've provided. Send a `SDLDidUpdateProjectionView` notification or call the `updateInterfaceLayout` method to reparse. The "output" of this haptic interface occurs in the `touchManager` property where it will call the delegate.
 */
@property (nonatomic, strong, readonly, nullable) id<SDLFocusableItemLocatorType> focusableItemManager;

/**
 A data source for the streaming manager's preferred resolutions and preferred formats.
 */
@property (weak, nonatomic, nullable) id<SDLStreamingMediaManagerDataSource> dataSource;

/// Whether or not video/audio streaming is supported
/// @discussion If connected to a module pre-SDL v4.5 there is no way to check if streaming is supported so `YES` is returned by default even though the module may not support video/audio streaming.
@property (assign, nonatomic, readonly, getter=isStreamingSupported) BOOL streamingSupported;

/**
 *  Whether or not the video session is connected.
 */
@property (assign, nonatomic, readonly, getter=isVideoConnected) BOOL videoConnected;

/**
 *  Whether or not the video session is encrypted. This may be different than the requestedEncryptionType.
 */
@property (assign, nonatomic, readonly, getter=isVideoEncrypted) BOOL videoEncrypted;

/**
 *  Whether or not the video stream is paused due to either the application being backgrounded, the HMI state being either NONE or BACKGROUND, or the video stream not being ready.
 */
@property (assign, nonatomic, readonly, getter=isVideoStreamingPaused) BOOL videoStreamingPaused;

/**
 Handles the logic of scaling between the view controller's coordinate system and the display's coordinate system
 */
@property (strong, nonatomic, readonly) SDLStreamingVideoScaleManager *videoScaleManager;

/**
 This is the agreed upon format of video encoder that is in use, or nil if not currently connected.
 */
@property (strong, nonatomic, readonly, nullable) SDLVideoStreamingFormat *videoFormat;

/**
 A list of all supported video formats by this manager
 */
@property (strong, nonatomic, readonly) NSArray<SDLVideoStreamingFormat *> *supportedFormats;

/**
 The decided upon preferred formats to try and connect with between the head unit and developer
 */
@property (strong, nonatomic) NSArray<SDLVideoStreamingFormat *> *preferredFormats;

/**
 The current attempt index for trying to connect with `preferredFormats`
 */
@property (assign, nonatomic) NSUInteger preferredFormatIndex;

/**
 The decided upon preferred resolutions to try and connect with between the head unit and the developer
 */
@property (strong, nonatomic) NSArray<SDLImageResolution *> *preferredResolutions;

/**
 The current attempt index for trying to connect with `preferredResolutions`
 */
@property (assign, nonatomic) NSUInteger preferredResolutionIndex;

/**
 *  The pixel buffer pool reference returned back from an active VTCompressionSessionRef encoder.
 *
 *  @warning    This will only return a valid pixel buffer pool after the encoder has been initialized (when the video     session has started).
 *  @discussion Clients may call this once and retain the resulting pool, this call is cheap enough that it's OK to call it once per frame.
 */
@property (assign, nonatomic, readonly, nullable) CVPixelBufferPoolRef pixelBufferPool;

/**
 *  The requested encryption type when a session attempts to connect. This setting applies to both video and audio sessions.
 *
 *  DEFAULT: SDLStreamingEncryptionFlagAuthenticateAndEncrypt
 */
@property (assign, nonatomic) SDLStreamingEncryptionFlag requestedEncryptionType;

/**
 When YES, the StreamingMediaManager will send a black screen with "Video Backgrounded String". Defaults to YES.
 */
@property (assign, nonatomic) BOOL showVideoBackgroundDisplay;


- (instancetype)init NS_UNAVAILABLE;

/// Create a new streaming video manager for navigation and projection apps with a specified configuration.
/// @param connectionManager The pass-through for RPCs
/// @param configuration This session's configuration
/// @param systemCapabilityManager The system capability manager object for reading window capabilities
- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager configuration:(SDLConfiguration *)configuration systemCapabilityManager:(nullable SDLSystemCapabilityManager *)systemCapabilityManager NS_DESIGNATED_INITIALIZER;

/**
 *  Start the manager with a completion block that will be called when startup completes. This is used internally. To use an SDLStreamingMediaManager, you should use the manager found on `SDLManager`.
 */
- (void)startWithProtocol:(SDLProtocol *)protocol;

/// This method is used internally to stop the manager when the device disconnects from the module.
- (void)stop;

/// This method is used internally to stop the manager when video needs to be stopped on the secondary transport. The primary transport is still open.
/// 1. Since the primary transport is still open, do will not reset the `hmiLevel` and `videoStreamingState` because we can still get notifications from the module with the updated hmi status on the primary transport.
/// 2. We need to send an end video service control frame to the module to ensure that the video session is shut down correctly. In order to do this the protocol must be kept open and only destroyed after the module ACKs or NAKs our end video service request.
/// 3. Since the primary transport is still open, the video scale manager should not be reset because the default video dimensions are retrieved from the `RegisterAppInterfaceResponse`. Due to a bug with the video start service ACK sometimes returning a screen resolution of {0, 0} on subsequent request to start a video service, we need to keep the screen resolution from the very first start video service ACK. (This is not an issue if the head unit supports the `VideoStreamingCapability`).
/// @param videoEndedCompletionHandler Called when the module ACKs or NAKs to the request to end the video service.
- (void)endVideoServiceWithCompletionHandler:(void (^)(void))videoEndedCompletionHandler;

/// This method is used internally to stop video streaming when the secondary transport has been closed due to an connection error. The primary transport is still open.
/// 1. Since the transport has been closed, we can not send an end video service control frame to the module.
/// 2. Since the primary transport is still open, we will not reset the `hmiLevel`, `videoStreamingState` or the video scale manager. This lets us resume video streaming if the secondary transport can be reestablished during the same app session.
- (void)secondaryTransportDidDisconnect;

/**
 *  This method receives raw image data and will run iOS8+'s hardware video encoder to turn the data into a video stream, which will then be passed to the connected head unit.
 *
 *  @param imageBuffer  A CVImageBufferRef to be encoded by Video Toolbox
 *
 *  @return Whether or not the data was successfully encoded and sent.
 */
- (BOOL)sendVideoData:(CVImageBufferRef)imageBuffer;

/**
 *  This method receives raw image data and will run iOS8+'s hardware video encoder to turn the data into a video stream, which will then be passed to the connected head unit.
 *
 *  @param imageBuffer  A CVImageBufferRef to be encoded by Video Toolbox
 *  @param presentationTimestamp A presentation timestamp for the frame, or kCMTimeInvalid if timestamp is unknown. If it's valid, it must be greater than the previous one.
 *
 *  @return Whether or not the data was successfully encoded and sent.
 */
- (BOOL)sendVideoData:(CVImageBufferRef)imageBuffer presentationTimestamp:(CMTime)presentationTimestamp;

@end

NS_ASSUME_NONNULL_END
