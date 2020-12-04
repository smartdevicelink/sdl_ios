//
//  SDLTemperature.h
//

#import "SDLRPCMessage.h"
#import "SDLTemperatureUnit.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  Struct representing a temperature.
 */
@interface SDLTemperature : SDLRPCStruct

/**
 *  Convenience init for a fahrenheit temperature value.
 *
 *  @param value    Temperature value in fahrenheit
 *  @return         A SDLTemperature object
 */
- (instancetype)initWithFahrenheitValue:(float)value;

/**
 *  Convenience init for a celsius temperature value.
 *
 *  @param value    Temperature value in celsius
 *  @return         A SDLTemperature object
 */
- (instancetype)initWithCelsiusValue:(float)value;

/**
 *  Convenience init for all parameters.
 *
 *  @param unit     Temperature unit
 *  @param value    Temperature value in specified unit
 *  @return         A SDLTemperature object
 */
- (instancetype)initWithUnit:(SDLTemperatureUnit)unit value:(float)value NS_DESIGNATED_INITIALIZER;

/**
 *  Temperature unit
 *
 *  Required, float
 */
@property (strong, nonatomic) SDLTemperatureUnit unit;

/**
 *  Temperature value in specified unit. Range depends on OEM and is not checked by SDL.
 *
 *  Required, float
 */
@property (strong, nonatomic) NSNumber<SDLFloat> *value;

@end

NS_ASSUME_NONNULL_END
