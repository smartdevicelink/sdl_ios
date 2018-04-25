//
//  SDLTemperature.h
//

#import "SDLRPCMessage.h"
#import "SDLTemperatureUnit.h"

NS_ASSUME_NONNULL_BEGIN

/**
 Struct using in Remote Control representing a temperature.
 */
@interface SDLTemperature : SDLRPCStruct

- (instancetype)initWithUnit:(SDLTemperatureUnit)unit value:(float)value;

/**
 Temperature Unit

 Required, float
 */
@property (strong, nonatomic) SDLTemperatureUnit unit;

/**
 Temperature Value in TemperatureUnit specified unit. Range depends on OEM and is not checked by SDL.

 Required, float
 */
@property (strong, nonatomic) NSNumber<SDLFloat> *value;

@end

NS_ASSUME_NONNULL_END
