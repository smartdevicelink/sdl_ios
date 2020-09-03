//
//  SDLWeatherData.h
//  SmartDeviceLink
//
//  Created by Nicole on 2/7/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLRPCRequest.h"

@class SDLDateTime;
@class SDLImage;
@class SDLTemperature;


NS_ASSUME_NONNULL_BEGIN

/// Contains information about the current weather
///
/// @since RPC 5.1
@interface SDLWeatherData : SDLRPCStruct

/**
 *  Convenience init for all parameters
 *
 *  @param currentTemperature       The current temperature
 *  @param temperatureHigh          The predicted high temperature for the day
 *  @param temperatureLow           The predicted low temperature for the day
 *  @param apparentTemperature      The apparent temperature
 *  @param apparentTemperatureHigh  The predicted high apparent temperature for the day
 *  @param apparentTemperatureLow   The predicted low apparent temperature for the day
 *  @param weatherSummary           A summary of the weather
 *  @param time                     The time this data refers to
 *  @param humidity                 From 0 to 1, percentage humidity
 *  @param cloudCover               From 0 to 1, percentage cloud cover
 *  @param moonPhase                From 0 to 1, percentage of the moon seen, e.g. 0 = no moon, 0.25 = quarter moon
 *  @param windBearing              In degrees, true north at 0 degrees
 *  @param windGust                 In km/hr
 *  @param windSpeed                In km/hr
 *  @param nearestStormBearing      In degrees, true north at 0 degrees
 *  @param nearestStormDistance     In km
 *  @param precipAccumulation       In cm
 *  @param precipIntensity          In cm of water per hour
 *  @param precipProbability        From 0 to 1, percentage chance
 *  @param precipType               A description of the precipitation type (e.g. "rain", "snow", "sleet", "hail")
 *  @param visibility               In km
 *  @param weatherIcon              The weather icon image
 *  @return                         A SDLWeatherData object
 */
- (instancetype)initWithCurrentTemperature:(nullable SDLTemperature *)currentTemperature temperatureHigh:(nullable SDLTemperature *)temperatureHigh temperatureLow:(nullable SDLTemperature *)temperatureLow apparentTemperature:(nullable SDLTemperature *)apparentTemperature apparentTemperatureHigh:(nullable SDLTemperature *)apparentTemperatureHigh apparentTemperatureLow:(nullable SDLTemperature *)apparentTemperatureLow weatherSummary:(nullable NSString *)weatherSummary time:(nullable SDLDateTime *)time humidity:(nullable NSNumber<SDLFloat> *)humidity cloudCover:(nullable NSNumber<SDLFloat> *)cloudCover moonPhase:(nullable NSNumber<SDLFloat> *)moonPhase windBearing:(nullable NSNumber<SDLInt> *)windBearing windGust:(nullable NSNumber<SDLFloat> *)windGust windSpeed:(nullable NSNumber<SDLFloat> *)windSpeed nearestStormBearing:(nullable NSNumber<SDLInt> *)nearestStormBearing nearestStormDistance:(nullable NSNumber<SDLInt> *)nearestStormDistance precipAccumulation:(nullable NSNumber<SDLFloat> *)precipAccumulation precipIntensity:(nullable NSNumber<SDLFloat> *)precipIntensity precipProbability:(nullable NSNumber<SDLFloat> *)precipProbability precipType:(nullable NSString *)precipType visibility:(nullable NSNumber<SDLFloat> *)visibility weatherIcon:(nullable SDLImage *)weatherIcon;

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
 *  The time this data refers to.
 *
 *  SDLDateTime, Optional
 */
@property (nullable, strong, nonatomic) SDLDateTime *time;

/**
 *  From 0 to 1, percentage humidity.
 *
 *  Float, Optional, minvalue="0" maxvalue="1"
 */
@property (nullable, strong, nonatomic) NSNumber<SDLFloat> *humidity;

/**
 *  From 0 to 1, percentage cloud cover.
 *
 *  Float, Optional, minvalue="0" maxvalue="1"
 */
@property (nullable, strong, nonatomic) NSNumber<SDLFloat> *cloudCover;

/**
 *  From 0 to 1, percentage of the moon seen, e.g. 0 = no moon, 0.25 = quarter moon
 *
 *  Float, Optional, minvalue="0" maxvalue="1"
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
 *  Float, Optional, minvalue="0" maxvalue="1"
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
 *  The weather icon image.
 *
 *  SDLImage, Optional
 */
@property (nullable, strong, nonatomic) SDLImage *weatherIcon;

@end

NS_ASSUME_NONNULL_END
