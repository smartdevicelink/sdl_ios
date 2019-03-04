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
 *  Convenience init for all parameters.
 *
 *  @param currentForecastSupported     Whether or not the current forcast is supported.
 *  @param maxMultidayForecastAmount    The maximum number of day-by-day forecasts.
 *  @param maxHourlyForecastAmount      The maximum number of hour-by-hour forecasts.
 *  @param maxMinutelyForecastAmount    The maximum number of minute-by-minute forecasts.
 *  @param weatherForLocationSupported  Whether or not the weather for location is supported.
 *  @return                             A SDLWeatherServiceManifest object
 */
- (instancetype)initWithCurrentForecastSupported:(BOOL)currentForecastSupported maxMultidayForecastAmount:(UInt32)maxMultidayForecastAmount maxHourlyForecastAmount:(UInt32)maxHourlyForecastAmount maxMinutelyForecastAmount:(UInt32)maxMinutelyForecastAmount weatherForLocationSupported:(BOOL)weatherForLocationSupported;

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
