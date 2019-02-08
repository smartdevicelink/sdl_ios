//
//  SDLWeatherServiceManifest.h
//  SmartDeviceLink
//
//  Created by Nicole on 2/8/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLRPCRequest.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  A weather service manifest.
 */
@interface SDLWeatherServiceManifest : SDLRPCStruct

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
