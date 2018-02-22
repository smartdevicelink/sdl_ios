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

@class SDLAbstractProtocol;
@class SDLAudioStreamManager;
@class SDLStreamingMediaConfiguration;
@class SDLTouchManager;
@class SDLVideoStreamingFormat;

@protocol SDLFocusableItemLocatorType;
@protocol SDLConnectionManagerType;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Interface

@interface SDLStreamingMediaManager : NSObject <SDLStreamingAudioManagerType>

/**
 *  Touch Manager responsible for providing touch event notifications.
 */
@property (nonatomic, strong, readonly) SDLTouchManager *touchManager;

@property (nonatomic, strong, readonly) SDLAudioStreamManager *audioManager;

/**
 This property is used for SDLCarWindow, the ability to stream any view controller. To start, you must set an initial view controller on `SDLStreamingMediaConfiguration` `rootViewController`. After streaming begins, you can replace that view controller with a new root by placing the new view controller into this property.
 */
@property (nonatomic, strong) UIViewController *rootViewController;

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
 *  This is the current screen size of a connected display. This will be the size the video encoder uses to encode the raw image data.
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
 *  @warning This will only return a valid pixel buffer pool after the encoder has been initialized (when the video     session has started).
 *  @discussion Clients may call this once and retain the resulting pool, this call is cheap enough that it's OK to call it once per frame.
 */
@property (assign, nonatomic, readonly, nullable) CVPixelBufferPoolRef pixelBufferPool;

/**
 *  The requested encryption type when a session attempts to connect. This setting applies to both video and audio sessions.
 *
 *  DEFAULT: SDLStreamingEncryptionFlagAuthenticateAndEncrypt
 */
@property (assign, nonatomic) SDLStreamingEncryptionFlag requestedEncryptionType;

- (instancetype)init NS_UNAVAILABLE;

/**
 Create a new streaming media manager for navigation and VPM apps with a specified configuration

 @param connectionManager The pass-through for RPCs
 @param configuration The configuration of this streaming media session
 @return A new streaming manager
 */
- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager configuration:(SDLStreamingMediaConfiguration *)configuration NS_DESIGNATED_INITIALIZER;

/**
 *  Start the manager with a completion block that will be called when startup completes. This is used internally. To use an SDLStreamingMediaManager, you should use the manager found on `SDLManager`.
 */
- (void)startWithProtocol:(SDLAbstractProtocol *)protocol;

/**
 *  Stop the manager. This method is used internally.
 */
- (void)stop;

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
 *  This method receives PCM audio data and will attempt to send that data across to the head unit for immediate playback
 *
 *  @param audioData The data in PCM audio format, to be played
 *
 *  @return Whether or not the data was successfully sent.
 */
- (BOOL)sendAudioData:(NSData *)audioData;


@end

NS_ASSUME_NONNULL_END
