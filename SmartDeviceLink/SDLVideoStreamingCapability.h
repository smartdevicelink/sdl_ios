//
//  SDLVideoStreamingCapability.h
//  SmartDeviceLink-iOS
//
//  Created by Brett McIsaac on 7/31/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "SDLRPCMessage.h"

@class SDLImageResolution;
@class SDLVideoStreamingFormat;

NS_ASSUME_NONNULL_BEGIN

@interface SDLVideoStreamingCapability : SDLRPCStruct

- (instancetype)initWithPreferredResolution:(nullable SDLImageResolution *)preferredResolution maxBitrate:(int32_t)maxBitrate supportedFormats:(nullable NSArray<SDLVideoStreamingFormat *> *)supportedFormats hapticDataSupported:(BOOL)hapticDataSupported;

/**
 * @abstract The preferred resolution of a video stream for decoding and rendering on HMI, optional
 */
@property (nullable, strong, nonatomic) SDLImageResolution *preferredResolution;

/**
 * @abstract The maximum bitrate of video stream that is supported, in kbps, optional
 *
 * minvalue= 0
 *
 * maxvalue= 2147483647
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *maxBitrate;

/**
 * @abstract Detailed information on each format supported by this system, in its preferred order, optional
 */
@property (nullable, strong, nonatomic) NSArray<SDLVideoStreamingFormat *> *supportedFormats;

/**
 True if the system can utilize the haptic spatial data from the source being streamed.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *hapticSpatialDataSupported;

@end

NS_ASSUME_NONNULL_END
