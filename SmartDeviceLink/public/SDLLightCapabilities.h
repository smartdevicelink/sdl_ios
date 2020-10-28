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

#import "SDLLightName.h"

NS_ASSUME_NONNULL_BEGIN

/// Current Light capabilities.
///
/// @since RPC 5.0
@interface SDLLightCapabilities : SDLRPCStruct

/**
 * @param nameParam - nameParam
 * @return A SDLLightCapabilities object
 */
- (instancetype)initWithNameParam:(SDLLightName)nameParam;

/**
 * @param nameParam - nameParam
 * @param statusAvailable - statusAvailable
 * @param densityAvailable - densityAvailable
 * @param rgbColorSpaceAvailable - rgbColorSpaceAvailable
 * @return A SDLLightCapabilities object
 */
- (instancetype)initWithNameParam:(SDLLightName)nameParam statusAvailable:(nullable NSNumber<SDLBool> *)statusAvailable densityAvailable:(nullable NSNumber<SDLBool> *)densityAvailable rgbColorSpaceAvailable:(nullable NSNumber<SDLBool> *)rgbColorSpaceAvailable;

/**
 Constructs a newly allocated SDLLightCapabilities object with the name of the light or group of lights

 @param name The name of a light or a group of lights
 @return An instance of the SDLLightCapabilities class
 */
- (instancetype)initWithName:(SDLLightName)name __deprecated_msg("Use initWithNameParam: instead");

/**
 Constructs a newly allocated SDLLightCapabilities object with given parameters

 @param name The name of a light or a group of lights
 @param densityAvailable light's density can be set remotely
 @param colorAvailable Light's color can be set remotely by using the RGB color space
 @param statusAvailable whether status is available

 @return An instance of the SDLLightCapabilities class
 */
- (instancetype)initWithName:(SDLLightName)name densityAvailable:(BOOL)densityAvailable colorAvailable:(BOOL)colorAvailable statusAvailable:(BOOL)statusAvailable __deprecated_msg("Use initWithNameParam: instead");

/**
 * @abstract The name of a light or a group of lights
 *
 * Required, SDLLightName
 */
@property (strong, nonatomic) SDLLightName nameParam;

/**
 * @abstract The name of a light or a group of lights
 *
 * Required, SDLLightName
 */
@property (strong, nonatomic) SDLLightName name __deprecated_msg("Use nameParam instead");

/**
 * @abstract  Indicates if the light's density can be set remotely (similar to a dimmer).
 *
 * Optional, Boolean
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *densityAvailable;

/**
 * Indicates if the light's color can be set remotely by using the sRGB color space.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *rgbColorSpaceAvailable;

/**
 * @abstract Indicates if the light's color can be set remotely by using the RGB color space.
 *
 * Optional, Boolean
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *colorAvailable __deprecated_msg("Use rgbColorSpaceAvailable instead");

/**
 * @abstract Indicates if the status (ON/OFF) can be set remotely.
 * App shall not use read-only values (RAMP_UP/RAMP_DOWN/UNKNOWN/INVALID) in a setInteriorVehicleData request.
 *
 * Optional, Boolean
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *statusAvailable;

@end

NS_ASSUME_NONNULL_END
