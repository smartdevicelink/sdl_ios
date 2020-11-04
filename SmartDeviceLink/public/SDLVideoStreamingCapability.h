/*
 * Copyright (c) 2020, SmartDeviceLink Consortium, Inc.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * Redistributions of source code must retain the above copyright notice, this
 * list of conditions and the following disclaimer.
 *
 * Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following
 * disclaimer in the documentation and/or other materials provided with the
 * distribution.
 *
 * Neither the name of the SmartDeviceLink Consortium Inc. nor the names of
 * its contributors may be used to endorse or promote products derived
 * from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */

#import "SDLRPCMessage.h"

@class SDLImageResolution;
@class SDLVideoStreamingFormat;

NS_ASSUME_NONNULL_BEGIN

/**
 Contains information about this system's video streaming capabilities

 @added in SmartDeviceLink 4.5.0
 */
@interface SDLVideoStreamingCapability : SDLRPCStruct

/**
 * @param preferredResolution - preferredResolution
 * @param maxBitrate - maxBitrate
 * @param supportedFormats - supportedFormats
 * @param hapticSpatialDataSupported - hapticSpatialDataSupported
 * @param diagonalScreenSize - diagonalScreenSize
 * @param pixelPerInch - pixelPerInch
 * @param scale - scale
 * @return A SDLVideoStreamingCapability object
 */
- (instancetype)initWithPreferredResolution:(nullable SDLImageResolution *)preferredResolution maxBitrate:(nullable NSNumber<SDLUInt> *)maxBitrate supportedFormats:(nullable NSArray<SDLVideoStreamingFormat *> *)supportedFormats hapticSpatialDataSupported:(nullable NSNumber<SDLBool> *)hapticSpatialDataSupported diagonalScreenSize:(nullable NSNumber<SDLFloat> *)diagonalScreenSize pixelPerInch:(nullable NSNumber<SDLFloat> *)pixelPerInch scale:(nullable NSNumber<SDLFloat> *)scale;

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
- (instancetype)initWithPreferredResolution:(nullable SDLImageResolution *)preferredResolution maxBitrate:(int32_t)maxBitrate supportedFormats:(nullable NSArray<SDLVideoStreamingFormat *> *)supportedFormats hapticDataSupported:(BOOL)hapticDataSupported diagonalScreenSize:(float)diagonalScreenSize pixelPerInch:(float)pixelPerInch scale:(float)scale __deprecated_msg("Use initWithPreferredResolution:maxBitrate:supportedFormats:hapticSpatialDataSupported:diagonalScreenSize:pixelPerInch:scale: instead");

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

@end

NS_ASSUME_NONNULL_END
