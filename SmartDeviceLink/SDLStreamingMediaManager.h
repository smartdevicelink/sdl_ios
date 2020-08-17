//
//  SDLStreamingDataManager.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 8/11/15.
//  Copyright (c) 2015 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <VideoToolbox/VideoToolbox.h>

#import "SDLStreamingAudioManagerType.h"
#import "SDLStreamingMediaManagerConstants.h"

@class SDLAudioStreamManager;
@class SDLConfiguration;
@class SDLProtocol;
@class SDLSecondaryTransportManager;
@class SDLSystemCapabilityManager;
@class SDLTouchManager;
@class SDLVideoStreamingFormat;

@protocol SDLFocusableItemLocatorType;
@protocol SDLConnectionManagerType;


NS_ASSUME_NONNULL_BEGIN


/// Manager to help control streaming (video and audio) media services.
@interface SDLStreamingMediaManager : NSObject <SDLStreamingAudioManagerType>

/**
 *  Touch Manager responsible for providing touch event notifications.
 */
@property (nonatomic, strong, readonly) SDLTouchManager *touchManager;

/**
 *  Audio Manager responsible for managing streaming audio.
 */
@property (nonatomic, strong, readonly) SDLAudioStreamManager *audioManager;

/**
 This property is used for SDLCarWindow, the ability to stream any view controller. To start, you must set an initial view controller on `SDLStreamingMediaConfiguration` `rootViewController`. After streaming begins, you can replace that view controller with a new root by placing the new view controller into this property.
 */
@property (nonatomic, strong, nullable) UIViewController *rootViewController;

/**
 A haptic interface that can be updated to reparse views within the window you've provided. Send a `SDLDidUpdateProjectionView` notification or call the `updateInterfaceLayout` method to reparse. The "output" of this haptic interface occurs in the `touchManager` property where it will call the delegate.
 */
@property (nonatomic, strong, readonly, nullable) id<SDLFocusableItemLocatorType> focusableItemManager;

/**
 *  Whether or not video streaming is supported
 *
 *  @see SDLRegisterAppInterface SDLDisplayCapabilities
 */
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
 *  Whether or not the audio session is connected.
 */
@property (assign, nonatomic, readonly, getter=isAudioConnected) BOOL audioConnected;

/**
 *  Whether or not the audio session is encrypted. This may be different than the requestedEncryptionType.
 */
@property (assign, nonatomic, readonly, getter=isAudioEncrypted) BOOL audioEncrypted;

/**
 *  Whether or not the video stream is paused due to either the application being backgrounded, the HMI state being either NONE or BACKGROUND, or the video stream not being ready.
 */
@property (assign, nonatomic, readonly, getter=isVideoStreamingPaused) BOOL videoStreamingPaused;

/**
 *  The current screen resolution of the connected display in pixels.
 */
@property (assign, nonatomic, readonly) CGSize screenSize;

/**
 This is the agreed upon format of video encoder that is in use, or nil if not currently connected.
 */
@property (strong, nonatomic, readonly, nullable) SDLVideoStreamingFormat *videoFormat;

/**
 A list of all supported video formats by this manager
 */
@property (strong, nonatomic, readonly) NSArray<SDLVideoStreamingFormat *> *supportedFormats;

/**
 *  The pixel buffer pool reference returned back from an active VTCompressionSessionRef encoder.
 *
 *  @warning This will only return a valid pixel buffer pool after the encoder has been initialized (when the video session has started).
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


#pragma mark - Lifecycle

/// Initializer unavailable
- (instancetype)init NS_UNAVAILABLE;

/// Create a new streaming media manager for navigation and projection apps with a specified configuration.
/// @param connectionManager The pass-through for RPCs
/// @param configuration This session's configuration
- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager configuration:(SDLConfiguration *)configuration __deprecated_msg("Use initWithConnectionManager:configuration:systemCapabilityManager: instead");

/// Create a new streaming media manager for navigation and projection apps with a specified configuration.
/// @param connectionManager The pass-through for RPCs
/// @param configuration This session's configuration
/// @param systemCapabilityManager The system capability manager object for reading window capabilities
- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager configuration:(SDLConfiguration *)configuration systemCapabilityManager:(nullable SDLSystemCapabilityManager *)systemCapabilityManager NS_DESIGNATED_INITIALIZER;

/**
 *  Start the manager. This is used internally. To use an SDLStreamingMediaManager, you should use the manager found on `SDLManager`.
 */
- (void)startWithProtocol:(SDLProtocol *)protocol;

/**
 *  Stop the manager. This method is used internally.
 */
- (void)stop;

/**
 *  Stop the audio feature of the manager. This method is used internally.
 */
- (void)stopAudio;

/**
 *  Stop the video feature of the manager. This method is used internally.
 */
- (void)stopVideo;

#pragma mark - Data Transfer

/**
 *  This method receives raw image data and will run iOS8+'s hardware video encoder to turn the data into a video stream, which will then be passed to the connected head unit.
 *
 *  @param imageBuffer A CVImageBufferRef to be encoded by Video Toolbox
 *
 *  @return Whether or not the data was successfully encoded and sent.
 */
- (BOOL)sendVideoData:(CVImageBufferRef)imageBuffer;

/**
 *  This method receives raw image data and will run iOS8+'s hardware video encoder to turn the data into a video stream, which will then be passed to the connected head unit.
 *
 *  @param imageBuffer A CVImageBufferRef to be encoded by Video Toolbox
 *  @param presentationTimestamp A presentation timestamp for the frame, or kCMTimeInvalid if timestamp is unknown. If it's valid, it must be greater than the previous one.
 *
 *  @return Whether or not the data was successfully encoded and sent.
 */
- (BOOL)sendVideoData:(CVImageBufferRef)imageBuffer presentationTimestamp:(CMTime)presentationTimestamp;

/**
 *  This method receives PCM audio data and will attempt to send that data across to the head unit for immediate playback.
 *
 *  NOTE: See the `.audioManager` (SDLAudioStreamManager) `pushWithData:` method for a more modern API.
 *
 *  @param audioData The data in PCM audio format, to be played
 *
 *  @return Whether or not the data was successfully sent.
 */
- (BOOL)sendAudioData:(NSData *)audioData;

#pragma mark - Deprecated Methods

 /**
  *  Start the audio feature of the manager. This is used internally. To use an SDLStreamingMediaManager, you should use the manager found on `SDLManager`.
  */
- (void)startAudioWithProtocol:(SDLProtocol *)protocol __deprecated_msg("Use startWithProtocol: instead");

 /**
  *  Start the video feature of the manager. This is used internally. To use an SDLStreamingMediaManager, you should use the manager found on `SDLManager`.
  */
- (void)startVideoWithProtocol:(SDLProtocol *)protocol __deprecated_msg("Use startWithProtocol: instead");

@end

NS_ASSUME_NONNULL_END
