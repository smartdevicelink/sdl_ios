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

#import "SDLRPCRequest.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * A weather service manifest.
 * @added in SmartDeviceLink 5.1.0
 */
@interface SDLWeatherServiceManifest : SDLRPCStruct

/**
 * @param currentForecastSupported - currentForecastSupported
 * @param maxMultidayForecastAmount - maxMultidayForecastAmount
 * @param maxHourlyForecastAmount - maxHourlyForecastAmount
 * @param maxMinutelyForecastAmount - maxMinutelyForecastAmount
 * @param weatherForLocationSupported - weatherForLocationSupported
 * @return A SDLWeatherServiceManifest object
 */
- (instancetype)initWithCurrentForecastSupportedParam:(nullable NSNumber<SDLBool> *)currentForecastSupported maxMultidayForecastAmount:(nullable NSNumber<SDLInt> *)maxMultidayForecastAmount maxHourlyForecastAmount:(nullable NSNumber<SDLInt> *)maxHourlyForecastAmount maxMinutelyForecastAmount:(nullable NSNumber<SDLInt> *)maxMinutelyForecastAmount weatherForLocationSupported:(nullable NSNumber<SDLBool> *)weatherForLocationSupported __deprecated_msg("Eventually an initializer without param will be added");

/**
 *  Convenience init for all parameters.
 *
 *  @param currentForecastSupported     Whether or not the current forcast is supported.
 *  @param maxMultidayForecastAmount    The maximum number of day-by-day forecasts.
 *  @param maxHourlyForecastAmount      The maximum number of hour-by-hour forecasts.
 *  @param maxMinutelyForecastAmount    The maximum number of minute-by-minute forecasts.
 *  @param weatherForLocationSupported  Whether or not the weather for location is supported.
 *  @return                             A SDLWeatherServiceManifest object
 */
- (instancetype)initWithCurrentForecastSupported:(BOOL)currentForecastSupported maxMultidayForecastAmount:(UInt32)maxMultidayForecastAmount maxHourlyForecastAmount:(UInt32)maxHourlyForecastAmount maxMinutelyForecastAmount:(UInt32)maxMinutelyForecastAmount weatherForLocationSupported:(BOOL)weatherForLocationSupported __deprecated_msg("Eventually an initializer with different types will be added");

/**
 *  Whether or not the current forcast is supported.
 *
 *  Boolean, Optional
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *currentForecastSupported;

/**
 *  The maximum number of day-by-day forecasts.
 *
 *  Integer, Optional
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *maxMultidayForecastAmount;

/**
 *  The maximum number of hour-by-hour forecasts.
 *
 *  Integer, Optional
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *maxHourlyForecastAmount;

/**
 *  The maximum number of minute-by-minute forecasts.
 *
 *  Integer, Optional
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *maxMinutelyForecastAmount;

/**
 *  Whether or not the weather for location is supported.
 *
 *  Boolean, Optional
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *weatherForLocationSupported;

@end

NS_ASSUME_NONNULL_END
