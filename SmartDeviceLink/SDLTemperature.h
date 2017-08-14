//
//  SDLTemperature.h
//

#import "SDLRPCMessage.h"
#import  "SDLTemperatureUnit.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLTemperature : SDLRPCStruct

/**
 * @abstract Temperature Unit
 *
 */
@property (strong, nonatomic) SDLTemperatureUnit unit;

/**
 * @abstract Temperature Value in TemperatureUnit specified unit. Range depends on OEM and is not checked by SDL
 *
 * FLoat value
 */
@property (strong, nonatomic) NSNumber<SDLFloat> *value;

@end

NS_ASSUME_NONNULL_END
