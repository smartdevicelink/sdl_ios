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
 *  Array of SDLWeatherData, Optional, minSize="15" maxSize="60"
 */
@property (nullable, strong, nonatomic) NSArray<SDLWeatherData *> *minuteForecast;

/**
 *  An hour-by-hour array of forecasts.
 *
 *  Array of SDLWeatherData, Optional, minsize="1" maxSize="96"
 */
@property (nullable, strong, nonatomic) NSArray<SDLWeatherData *> *hourlyForecast;

/**
 *  An day-by-day array of forecasts.
 *
 *  Array of SDLWeatherData, Optional, minsize="1" maxSize="30"
 */
@property (nullable, strong, nonatomic) NSArray<SDLWeatherData *> *multidayForecast;

/**
 *  An array of weather alerts. This array should be ordered with the first object being the current day.
 *
 *  Array of SDLWeatherData, Optional, minsize="1" maxSize="10"
 */
@property (nullable, strong, nonatomic) NSArray<SDLWeatherAlert *> *alerts;

@end

NS_ASSUME_NONNULL_END
