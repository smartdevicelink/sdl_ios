//
//  SDLWeatherServiceData.h
//  SmartDeviceLink
//
//  Created by Nicole on 2/7/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLRPCRequest.h"

#import "SDLLocationDetails.h"
#import "SDLWeatherData.h"
#import "SDLWeatherAlert.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  This data is related to what a weather service would provide.
 */
@interface SDLWeatherServiceData : SDLRPCStruct

/**
 *  Convenience init for required parameters.
 *
 *  @param location         The location
 *  @return                 A SDLWeatherServiceData object
 */
- (instancetype)initWithLocation:(SDLLocationDetails *)location NS_DESIGNATED_INITIALIZER;

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
