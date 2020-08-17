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

/**
Convenience init for creating a video streaming capability.

@param preferredResolution The preferred resolution of a video stream for decoding and rendering on HMI
@param maxBitrate The maximum bitrate of video stream that is supported, in kbps
@param supportedFormats Detailed information on each format supported by this system, in its preferred order
@param hapticDataSupported True if the system can utilize the haptic spatial data from the source being streamed
@return A SDLVideoStreamingCapability object
*/
- (instancetype)initWithPreferredResolution:(nullable SDLImageResolution *)preferredResolution maxBitrate:(int32_t)maxBitrate supportedFormats:(nullable NSArray<SDLVideoStreamingFormat *> *)supportedFormats hapticDataSupported:(BOOL)hapticDataSupported __deprecated_msg("Use initWithPreferredResolution:maxBitrate:supportedFormats:hapticDataSupported:diagonalScreenSize:pixelPerInch:scale: instead");

/**
 Convenience init for creating a video streaming capability with all parameters.

 @param preferredResolution The preferred resolution of a video stream for decoding and rendering on HMI
 @param maxBitrate The maximum bitrate of video stream that is supported, in kbps
 @param supportedFormats Detailed information on each format supported by this system, in its preferred order
 @param hapticDataSupported True if the system can utilize the haptic spatial data from the source being streamed
 @param diagonalScreenSize The diagonal screen size in inches
 @param pixelPerInch The diagonal resolution in pixels divided by the diagonal screen size in inches
 @param scale The scaling factor the app should use to change the size of the projecting view
 @return A SDLVideoStreamingCapability object
 */
- (instancetype)initWithPreferredResolution:(nullable SDLImageResolution *)preferredResolution maxBitrate:(int32_t)maxBitrate supportedFormats:(nullable NSArray<SDLVideoStreamingFormat *> *)supportedFormats hapticDataSupported:(BOOL)hapticDataSupported diagonalScreenSize:(float)diagonalScreenSize pixelPerInch:(float)pixelPerInch scale:(float)scale;

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
 
 Float, Optional, minvalue="0"
 @since SDL 6.0
 */
@property (nullable, strong, nonatomic) NSNumber<SDLFloat> *diagonalScreenSize;

/**
 The diagonal resolution in pixels divided by the diagonal screen size in inches.
 
 Float, Optional, minvalue="0"
 @since SDL 6.0
 */
@property (nullable, strong, nonatomic) NSNumber<SDLFloat> *pixelPerInch;

/**
 The scaling factor the app should use to change the size of the projecting view.
 
 Float, Optional, minvalue="1" maxvalue="10"
 @since SDL 6.0
 */
@property (nullable, strong, nonatomic) NSNumber<SDLFloat> *scale;

// note: it can be a recursion under certain circumstances
@property (nullable, strong, nonatomic) NSArray <SDLVideoStreamingCapability*> *additionalVideoStreamingCapabilities;

// this returns a copy array of all capabilities including itself but with no recursion
// in the result objects the .additionalVideoStreamingCapabilities will be nil
- (NSArray <SDLVideoStreamingCapability*>*)allVideoStreamingCapabilitiesPlain;

- (SDLImageResolution *)makeImageResolution;

@end

NS_ASSUME_NONNULL_END
