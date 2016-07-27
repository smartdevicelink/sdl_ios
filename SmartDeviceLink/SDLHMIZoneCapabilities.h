//  SDLHmiZoneCapabilities.h
//


#import "SDLEnum.h"

/**
 * Specifies HMI Zones in the vehicle.
 *
 * @since SDL 1.0
 */
@interface SDLHMIZoneCapabilities : SDLEnum {
}

/**
 * @abstract SDLHMIZoneCapabilities
 * @param value The value of the string to get an object for
 * @return SDLHMIZoneCapabilities
 */
+ (SDLHMIZoneCapabilities *)valueOf:(NSString *)value;

/**
 * @abstract store all possible SDLHMIZoneCapabilities values
 * @return an array with all possible SDLHMIZoneCapabilities values inside
 */
+ (NSArray *)values;

/**
 * @abstract Indicates HMI available for front seat passengers.
 * @return a SDLHMIZoneCapabilities with value of *FRONT*
 */
+ (SDLHMIZoneCapabilities *)FRONT;
/**
 * @abstract Indicates HMI available for rear seat passengers.
 * @return a SDLHMIZoneCapabilities with value of *BACK*
 */
+ (SDLHMIZoneCapabilities *)BACK;

@end
