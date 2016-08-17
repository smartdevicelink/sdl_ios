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

typedef NS_ENUM(NSInteger, SDLStreamingVideoError) {
    SDLStreamingVideoErrorHeadUnitNACK = 0,
    SDLSTreamingVideoErrorInvalidOperatingSystemVersion __deprecated_enum_msg("Use SDLStreamingVideoErrorInvalidOperatingSystemVersion instead") = 1,
    SDLStreamingVideoErrorInvalidOperatingSystemVersion = 1,
    SDLStreamingVideoErrorConfigurationCompressionSessionCreationFailure = 2,
    SDLStreamingVideoErrorConfigurationAllocationFailure = 3,
    SDLStreamingVideoErrorConfigurationCompressionSessionSetPropertyFailure = 4
};

typedef NS_ENUM(NSInteger, SDLEncryptionFlag) {
    SDLEncryptionFlagNone,
    SDLEncryptionFlagAuthenticateOnly,
    SDLEncryptionFlagAuthenticateAndEncrypt
};

typedef NS_ENUM(NSInteger, SDLStreamingAudioError) {
    SDLStreamingAudioErrorHeadUnitNACK
};

extern NSString *const SDLErrorDomainStreamingMediaVideo;
extern NSString *const SDLErrorDomainStreamingMediaAudio;

extern CGSize const SDLDefaultScreenSize;

typedef void (^SDLStreamingStartBlock)(BOOL success, NSError *__nullable error);
typedef void (^SDLStreamingEncryptionStartBlock)(BOOL success, BOOL encryption, NSError *__nullable error);


#pragma mark - Interface

@interface SDLStreamingMediaManager : NSObject <SDLProtocolListener>

@property (assign, nonatomic, readonly) BOOL videoSessionConnected;
@property (assign, nonatomic, readonly) BOOL audioSessionConnected;

@property (assign, nonatomic, readonly) BOOL videoSessionEncrypted;
@property (assign, nonatomic, readonly) BOOL audioSessionEncrypted;

/**
 *  Touch Manager responsible for providing touch event notifications.
 */
@property (nonatomic, strong, readonly) SDLTouchManager *touchManager;

/**
 *  The settings used in a VTCompressionSessionRef encoder. These will be verified when the video stream is started. Acceptable properties for this are located in VTCompressionProperties. If set to nil, the defaultVideoEncoderSettings will be used.
 *
 *  @warning Video streaming must not be connected to update the encoder properties. If it is running, issue a stopVideoSession before updating.
 */
@property (strong, nonatomic, null_resettable) NSDictionary *videoEncoderSettings;

/**
 *  Display capabilties that will set the screenSize property. If set to nil, the SDLDefaultScreenSize will be used.
 *
 *  @warning Video streaming must not be connected to update the encoder properties. If it is running, issue a stopVideoSession before updating.
 */
@property (strong, nonatomic, null_resettable) SDLDisplayCapabilities *displayCapabilties;

/**
 *  Provides default video encoder settings used.
 */
@property (strong, nonatomic, readonly) NSDictionary *defaultVideoEncoderSettings;

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


- (instancetype)initWithProtocol:(SDLAbstractProtocol *)protocol __deprecated_msg(("Please use initWithProtocol:displayCapabilities: instead"));

- (instancetype)initWithProtocol:(SDLAbstractProtocol *)protocol displayCapabilities:(SDLDisplayCapabilities *)displayCapabilities;

/**
 *  This method will attempt to start a streaming video session. It will set up iOS's video encoder,  and call out to the head unit asking if it will start a video session. This will not use encryption.
 *
 *  @warning If this method is called on an 8.0 device, it will assert (in debug), or return a failure immediately to your block (in release).
 *
 *  @param startBlock A block that will be called with the result of attempting to start a video session
 */
- (void)startVideoSessionWithStartBlock:(SDLStreamingStartBlock)startBlock;

/**
 *  Start a video session either with with no encryption (the default), with authentication but no encryption (this will attempt a TLS authentication with the other side, but will not physically encrypt the data after that), or authentication and encryption, which will encrypt all video data being sent.
 *
 *  @param encryptionFlag Whether and how much security to apply to the video session.
 *  @param startBlock     A block that will be called with the result of attempting to start a video session
 */
- (void)startVideoSessionWithTLS:(SDLEncryptionFlag)encryptionFlag startBlock:(SDLStreamingEncryptionStartBlock)startBlock;

/**
 *  This method will stop a running video session if there is one running.
 */
- (void)stopVideoSession;

/**
 *  This method receives raw image data and will run iOS8+'s hardware video encoder to turn the data into a video stream, which will then be passed to the connected head unit.
 *
 *  @param imageBuffer A CVImageBufferRef to be encoded by Video Toolbox
 *
 *  @return Whether or not the data was successfully encoded and sent.
 */
- (BOOL)sendVideoData:(CVImageBufferRef)imageBuffer;

/**
 *  This method will attempt to start an audio session
 *
 *  @param startBlock A block that will be called with the result of attempting to start an audio session
 */
- (void)startAudioSessionWithStartBlock:(SDLStreamingStartBlock)startBlock;

// TODO: Documentation
- (void)startAudioSessionWithTLS:(SDLEncryptionFlag)encryptionFlag startBlock:(SDLStreamingEncryptionStartBlock)startBlock;

/**
 *  This method will stop a running audio session if there is one running.
 */
- (void)stopAudioSession;

/**
 *  This method receives PCM audio data and will attempt to send that data across to the head unit for immediate playback
 *
 *  @param pcmAudioData The data in PCM audio format, to be played
 *
 *  @return Whether or not the data was successfully sent.
 */
- (BOOL)sendAudioData:(NSData *)pcmAudioData;

@end

NS_ASSUME_NONNULL_END
