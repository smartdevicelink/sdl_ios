//
//  SDLStreamingDataManager.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 8/11/15.
//  Copyright (c) 2015 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>
@import VideoToolbox;

#import "SDLProtocolListener.h"

@class SDLAbstractProtocol;
@class SDLDisplayCapabilities;
@class SDLTouchManager;


NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SDLStreamingEncryptionFlag) {
    SDLStreamingEncryptionFlagNone,
    SDLStreamingEncryptionFlagAuthenticateOnly,
    SDLStreamingEncryptionFlagAuthenticateAndEncrypt
};

extern CGSize const SDLDefaultScreenSize;

extern NSString *const SDLVideoStreamDidStartNotification;
extern NSString *const SDLVideoStreamDidStopNotification;

extern NSString *const SDLAudioStreamDidStartNotification;
extern NSString *const SDLAudioStreamDidStopNotification;

#pragma mark - Interface

@interface SDLStreamingMediaManager : NSObject <SDLProtocolListener>

/**
 *  Touch Manager responsible for providing touch event notifications.
 */
@property (nonatomic, strong, readonly, nonnull) SDLTouchManager *touchManager;

/**
 *  Whether or not video streaming is supported
 *
 *  @see SDLRegisterAppInterface SDLDisplayCapabilities
 */
@property (assign, nonatomic, readonly, getter=isVideoStreamingSupported) BOOL videoStreamingSupported;

/**
 *  Whether or not audio streaming is supported. Currently this is the same as videoStreamingSupported.
 */
@property (assign, nonatomic, readonly, getter=isAudioStreamingSupported) BOOL audioStreamingSupported;

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
 *  This is the current screen size of a connected display. This will be the size the video encoder uses to encode the raw image data.
 */
@property (assign, nonatomic, readonly) CGSize screenSize;

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

/**
 *  Creates a streaming manager with a default encryption type of SDLStreamingEncryptionFlagAuthenticateAndEncrypt.
 *
 *  @return An instance of SDLStreamingMediaManager
 */
- (instancetype)init;

/**
 *  Creates a streaming manager with a specified encryption type.
 *
 *  @param encryption The encryption type requested when starting to stream.
 *
 *  @return An instance of SDLStreamingMediaManager
 */
- (instancetype)initWithEncryption:(SDLStreamingEncryptionFlag)encryption NS_DESIGNATED_INITIALIZER;

/**
 *  Start the manager with a completion block that will be called when startup completes. This is used internally. To use an SDLStreamingMediaManager, you should use the manager found on `SDLManager`.
 *
 *  @param completionHandler The block to be called when the manager's setup is complete.
 */
- (void)startWithProtocol:(nonnull SDLAbstractProtocol*)protocol completionHandler:(void (^)(BOOL success, NSError *__nullable error))completionHandler;

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
- (BOOL)sendVideoData:(CV_NONNULL CVImageBufferRef)imageBuffer;

/**
 *  This method receives PCM audio data and will attempt to send that data across to the head unit for immediate playback
 *
 *  @param audioData The data in PCM audio format, to be played
 *
 *  @return Whether or not the data was successfully sent.
 */
- (BOOL)sendAudioData:(nonnull NSData *)audioData;


@end

NS_ASSUME_NONNULL_END
