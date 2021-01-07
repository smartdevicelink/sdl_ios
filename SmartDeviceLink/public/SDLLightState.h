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

#import <UIKit/UIKit.h>

#import "SDLRPCMessage.h"
#import "SDLLightName.h"
#import "SDLLightStatus.h"

@class SDLRGBColor;

NS_ASSUME_NONNULL_BEGIN

/// Current light control state
///
/// @since RPC 5.0
@interface SDLLightState : SDLRPCStruct

/**
 * @param idParam - idParam
 * @param status - status
 * @return A SDLLightState object
 */
- (instancetype)initWithIdParam:(SDLLightName)idParam status:(SDLLightStatus)status;

/**
 * @param idParam - idParam
 * @param status - status
 * @param density - density
 * @param color - color
 * @return A SDLLightState object
 */
- (instancetype)initWithIdParam:(SDLLightName)idParam status:(SDLLightStatus)status density:(nullable NSNumber<SDLFloat> *)density color:(nullable SDLRGBColor *)color;

/**
 Constructs a newly allocated SDLLightState object with given parameters

 @param id The name of a light or a group of lights
 @param status Reflects the status of Light.
 @return An instance of the SDLLightState class
 */
- (instancetype)initWithId:(SDLLightName)id status:(SDLLightStatus)status __deprecated_msg("Use initWithIdParam:status: instead");

/**
 Constructs a newly allocated SDLLightState object with given parameters

 @param id The name of a light or a group of lights
 @param status Reflects the status of Light.
 @param density Reflects the density of Light.
 @param color Reflects the color of Light.
 @return An instance of the SDLLightState class
 */
- (instancetype)initWithId:(SDLLightName)id status:(SDLLightStatus)status density:(double)density color:(SDLRGBColor *)color __deprecated_msg("Use initWithIdParam:status: instead");

/**
 Constructs a newly allocated SDLLightState object with given parameters

 @param id The name of a light or a group of lights
 @param lightStatus Reflects the status of Light.
 @param lightDensity Reflects the density of Light.
 @param lightColor Reflects the color of Light.
 @return An instance of the SDLLightState class
 */
- (instancetype)initWithId:(SDLLightName)id lightStatus:(SDLLightStatus)lightStatus lightDensity:(double)lightDensity lightColor:(UIColor *)lightColor __deprecated_msg("Use initWithIdParam:status: instead");

/**
 * The name of a light or a group of lights.
 */
@property (strong, nonatomic) SDLLightName idParam;

/**
 * @abstract The name of a light or a group of lights
 *
 * Required, SDLLightName
 */
@property (strong, nonatomic) SDLLightName id __deprecated_msg("Use idParam instead");

/**
 * @abstract Reflects the status of Light.
 *
 * Required, SDLLightStatus
 */
@property (strong, nonatomic) SDLLightStatus status;

/**
 * @abstract Reflects the density of Light.
 *
 * Optional, Float type with minValue: 0 maxValue:1
 */
@property (nullable, copy, nonatomic) NSNumber<SDLFloat> *density;

/**
 * @abstract Reflects the color of Light.
 *
 * Optional, SDLLightStatus
 */
@property (nullable, strong, nonatomic) SDLRGBColor *color;

@end

NS_ASSUME_NONNULL_END
