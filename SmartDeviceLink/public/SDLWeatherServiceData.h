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

#import "SDLLocationDetails.h"
#import "SDLWeatherData.h"
#import "SDLWeatherAlert.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * This data is related to what a weather service would provide.
 *
 * @added in SmartDeviceLink 5.1.0
 */
@interface SDLWeatherServiceData : SDLRPCStruct

/**
 *  Convenience init for required parameters.
 *
 *  @param location         The location
 *  @return                 A SDLWeatherServiceData object
 */
- (instancetype)initWithLocation:(SDLLocationDetails *)location;

/**
 *  Convenience init for all parameters.
 *
 *  @param location         The location
 *  @param currentForecast  The current forecast
 *  @param minuteForecast   A minute-by-minute array of forecasts
 *  @param hourlyForecast   An hour-by-hour array of forecasts
 *  @param multidayForecast A day-by-day array of forecasts
 *  @param alerts           An array of weather alerts
 *  @return                 A SDLWeatherServiceData object
 */
- (instancetype)initWithLocation:(SDLLocationDetails *)location currentForecast:(nullable SDLWeatherData *)currentForecast minuteForecast:(nullable NSArray<SDLWeatherData *> *)minuteForecast hourlyForecast:(nullable NSArray<SDLWeatherData *> *)hourlyForecast multidayForecast:(nullable NSArray<SDLWeatherData *> *)multidayForecast alerts:(nullable NSArray<SDLWeatherAlert *> *)alerts;

/**
 *  The location.
 *
 *  SDLLocationDetails, Required
 */
@property (strong, nonatomic) SDLLocationDetails *location;

/**
 *  The current forecast.
 *
 *  SDLWeatherData, Optional
 */
@property (nullable, strong, nonatomic) SDLWeatherData *currentForecast;

/**
 *  A minute-by-minute array of forecasts.
 *
 *  Array of SDLWeatherData, Optional, minsize="15" maxsize="60"
 */
@property (nullable, strong, nonatomic) NSArray<SDLWeatherData *> *minuteForecast;

/**
 *  An hour-by-hour array of forecasts.
 *
 *  Array of SDLWeatherData, Optional, minsize="1" maxsize="96"
 */
@property (nullable, strong, nonatomic) NSArray<SDLWeatherData *> *hourlyForecast;

/**
 *  A day-by-day array of forecasts.
 *
 *  Array of SDLWeatherData, Optional, minsize="1" maxsize="30"
 */
@property (nullable, strong, nonatomic) NSArray<SDLWeatherData *> *multidayForecast;

/**
 *  An array of weather alerts. This array should be ordered with the first object being the current day.
 *
 *  Array of SDLWeatherData, Optional, minsize="1" maxsize="10"
 */
@property (nullable, strong, nonatomic) NSArray<SDLWeatherAlert *> *alerts;

@end

NS_ASSUME_NONNULL_END
