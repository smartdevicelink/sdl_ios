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
#import "SDLTemperatureUnit.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  Struct representing a temperature.
 */
@interface SDLTemperature : SDLRPCStruct

/**
 * @param unit - unit
 * @param valueParam - @(valueParam)
 * @return A SDLTemperature object
 */
- (instancetype)initWithUnit:(SDLTemperatureUnit)unit valueParam:(float)valueParam;

/**
 *  Convenience init for a fahrenheit temperature value.
 *
 *  @param value    Temperature value in fahrenheit
 *  @return         A SDLTemperature object
 */
+ (instancetype)fahrenheitTemperature:(float)value;

/**
 *  Convenience init for a celsius temperature value.
 *
 *  @param value    Temperature value in celsius
 *  @return         A SDLTemperature object
 */
+ (instancetype)celsiusTemperature:(float)value;

/**
 *  Convenience init for a fahrenheit temperature value.
 *
 *  @param value    Temperature value in fahrenheit
 *  @return         A SDLTemperature object
 */
- (instancetype)initWithFahrenheitValue:(float)value __deprecated_msg("Use fahrenheitTemperature: instead");

/**
 *  Convenience init for a celsius temperature value.
 *
 *  @param value    Temperature value in celsius
 *  @return         A SDLTemperature object
 */
- (instancetype)initWithCelsiusValue:(float)value __deprecated_msg("Use celsiusTemperature: instead");

/**
 *  Convenience init for all parameters.
 *
 *  @param unit     Temperature unit
 *  @param value    Temperature value in specified unit
 *  @return         A SDLTemperature object
 */
- (instancetype)initWithUnit:(SDLTemperatureUnit)unit value:(float)value __deprecated_msg("Use initWithUnit:valueParam:");

/**
 *  Temperature unit
 *
 *  Required, float
 */
@property (strong, nonatomic) SDLTemperatureUnit unit;

/**
 * Temperature Value in TemperatureUnit specified unit. Range depends on OEM and is not checked by SDL.
 * {"num_min_value": null, "num_max_value": null}
 */
@property (strong, nonatomic) NSNumber<SDLFloat> *valueParam;

/**
 *  Temperature value in specified unit. Range depends on OEM and is not checked by SDL.
 *
 *  Required, float
 */
@property (strong, nonatomic) NSNumber<SDLFloat> *value __deprecated_msg("Use valueParam instead");

@end

NS_ASSUME_NONNULL_END
