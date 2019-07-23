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

/**
 Contains information about this system's video streaming capabilities
 */
@interface SDLVideoStreamingCapability : SDLRPCStruct

- (instancetype)initWithPreferredResolution:(nullable SDLImageResolution *)preferredResolution maxBitrate:(int32_t)maxBitrate supportedFormats:(nullable NSArray<SDLVideoStreamingFormat *> *)supportedFormats hapticDataSupported:(BOOL)hapticDataSupported diagonalScreenSize:(float)diagonalScreenSize  pixelPerInch:(float)pixelPerInch scale:(float)scale;

/**
 The preferred resolution of a video stream for decoding and rendering on HMI

 Optional
 */
@property (nullable, strong, nonatomic) SDLImageResolution *preferredResolution;

/**
 The maximum bitrate of video stream that is supported, in kbps, optional

 Optional, minvalue= 0, maxvalue= 2147483647
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *maxBitrate;

/**
 Detailed information on each format supported by this system, in its preferred order

 Optional
 */
@property (nullable, strong, nonatomic) NSArray<SDLVideoStreamingFormat *> *supportedFormats;

/**
 True if the system can utilize the haptic spatial data from the source being streamed.

 Optional
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *hapticSpatialDataSupported;

/**
 The diagonal screen size in inches.
 
 Optional
 */
@property (nullable, strong, nonatomic) NSNumber<SDLFloat> *diagonalScreenSize;

/**
 PPI is the diagonal resolution in pixels divided by the diagonal screen size in inches.
 
 Optional
 */
@property (nullable, strong, nonatomic) NSNumber<SDLFloat> *pixelPerInch;

/**
 The scaling factor the app should use to change the size of the projecting view.
 
 Optional
 */
@property (nullable, strong, nonatomic) NSNumber<SDLFloat> *scale;

@end

NS_ASSUME_NONNULL_END
