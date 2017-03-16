//
//  SDLVideoEncoder.h
//  SmartDeviceLink-iOS
//
//  Created by Muller, Alexander (A.) on 12/5/16.
//  Copyright © 2016 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <VideoToolbox/VideoToolbox.h>
#import "SDLMacros.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SDLVideoEncoderError) {
    SDLVideoEncoderErrorConfigurationCompressionSessionCreationFailure = 0,
    SDLVideoEncoderErrorConfigurationAllocationFailure = 1,
    SDLVideoEncoderErrorConfigurationCompressionSessionSetPropertyFailure = 2
};

extern NSString *const SDLErrorDomainVideoEncoder;

@class SDLVideoEncoder;

@protocol SDLVideoEncoderDelegate <NSObject>

- (void)videoEncoder:(SDLVideoEncoder *)encoder hasEncodedFrame:(NSData*)encodedVideo;

@end

@interface SDLVideoEncoder : NSObject

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithDimensions:(CGSize)dimensions properties:(NSDictionary<NSString *, id> *)properties delegate:(id<SDLVideoEncoderDelegate> __nullable)delegate error:(NSError **)error NS_DESIGNATED_INITIALIZER;

- (void)stop;

- (BOOL)encodeFrame:(CVImageBufferRef)imageBuffer;

/**
 *  Creates a new pixel buffer using the pixelBufferPool property.
 */
- (CVPixelBufferRef CV_NULLABLE)pixelBuffer;

@property (nonatomic, weak, nullable) id<SDLVideoEncoderDelegate> delegate;

/**
 *  The settings used in a VTCompressionSessionRef encoder. These will be verified when the video stream is started. Acceptable properties for this are located in VTCompressionProperties.
 *
 */
@property (strong, nonatomic, readonly) NSDictionary<NSString *, id> *videoEncoderSettings;

/**
 *  Provides default video encoder settings used.
 */
#if SDL_SUPPORTS_CLASS_PROPERTIES
@property (class, strong, nonatomic, readonly) NSDictionary<NSString *, id> *defaultVideoEncoderSettings;
#else
+ (NSDictionary<NSString *, id>*)defaultVideoEncoderSettings;
#endif

/**
 *  The pixel buffer pool reference returned back from an active VTCompressionSessionRef encoder.
 *
 *  @warning This will only return a valid pixel buffer pool after the encoder has been initialized (when the video     session has started).
 *  @discussion Clients may call this once and retain the resulting pool, this call is cheap enough that it's OK to call it once per frame.
 */
@property (assign, nonatomic, readonly) CVPixelBufferPoolRef CV_NULLABLE pixelBufferPool;

@end

NS_ASSUME_NONNULL_END
