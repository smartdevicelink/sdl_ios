//
//  SDLWeatherData.h
//  SmartDeviceLink
//
//  Created by Nicole on 2/7/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLRPCRequest.h"

#import "SDLDateTime.h"
#import "SDLTemperature.h"


NS_ASSUME_NONNULL_BEGIN

@interface SDLWeatherData : SDLRPCStruct

/**
 *  The current temperature.
 *
 *  SDLTemperature, Optional
 */
@property (nullable, strong, nonatomic) SDLTemperature *currentTemperature;

/**
 *  The predicted high temperature for the day.
 *
 *  SDLTemperature, Optional
 */
@property (nullable, strong, nonatomic) SDLTemperature *temperatureHigh;

/**
 *  The predicted low temperature for the day.
 *
 *  SDLTemperature, Optional
 */
@property (nullable, strong, nonatomic) SDLTemperature *temperatureLow;

/**
 *  The apparent temperature.
 *
 *  SDLTemperature, Optional
 */
@property (nullable, strong, nonatomic) SDLTemperature *apparentTemperature;

/**
 *  The predicted high apparent temperature for the day.
 *
 *  SDLTemperature, Optional
 */
@property (nullable, strong, nonatomic) SDLTemperature *apparentTemperatureHigh;

/**
 *  The predicted low apparent temperature for the day.
 *
 *  SDLTemperature, Optional
 */
@property (nullable, strong, nonatomic) SDLTemperature *apparentTemperatureLow;

/**
 *  A summary of the weather.
 *
 *  String, Optional
 */
@property (nullable, strong, nonatomic) NSString *weatherSummary;

/**
 *  The time.
 *
 *  SDLDateTime, Optional
 */
@property (nullable, strong, nonatomic) SDLDateTime *time;

/**
 *  From 0 to 1, percentage humidity.
 *
 *  Float, Optional
 */
@property (nullable, strong, nonatomic) NSNumber<SDLFloat> *humidity;

/**
 *  From 0 to 1, percentage cloud cover.
 *
 *  Float, Optional
 */
@property (nullable, strong, nonatomic) NSNumber<SDLFloat> *cloudCover;

/**
 *  From 0 to 1, percentage of the moon seen, e.g. 0 = no moon, 0.25 = quarter moon
 *
 *  Float, Optional
 */
@property (nullable, strong, nonatomic) NSNumber<SDLFloat> *moonPhase;

/**
 *  In degrees, true north at 0 degrees.
 *
 *  Integer, Optional
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *windBearing;

/**
 *  In km/hr
 *
 *  Float, Optional
 */
@property (nullable, strong, nonatomic) NSNumber<SDLFloat> *windGust;

/**
 *  In km/hr
 *
 *  Float, Optional
 */
@property (nullable, strong, nonatomic) NSNumber<SDLFloat> *windSpeed;

/**
 *  In degrees, true north at 0 degrees.
 *
 *  Integer, Optional
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *nearestStormBearing;

/**
 *  In km
 *
 *  Integer, Optional
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *nearestStormDistance;

/**
 *  In cm
 *
 *  Float, Optional
 */
@property (nullable, strong, nonatomic) NSNumber<SDLFloat> *precipAccumulation;

/**
 *  In cm of water per hour.
 *
 *  Float, Optional
 */
@property (nullable, strong, nonatomic) NSNumber<SDLFloat> *precipIntensity;

/**
 *  From 0 to 1, percentage chance.
 *
 *  Float, Optional
 */
@property (nullable, strong, nonatomic) NSNumber<SDLFloat> *precipProbability;

/**
 *  A description of the precipitation type (e.g. "rain", "snow", "sleet", "hail")
 *
 *  String, Optional
 */
@property (nullable, strong, nonatomic) NSString *precipType;

/**
 *  In km
 *
 *  Float, Optional
 */
@property (nullable, strong, nonatomic) NSNumber<SDLFloat> *visibility;

/**
 *  Name of the icon
 *
 *  String, Optional
 */
@property (nullable, strong, nonatomic) NSString *weatherIconImageName;

@end

NS_ASSUME_NONNULL_END
