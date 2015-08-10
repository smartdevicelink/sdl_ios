//  SDLCompassDirection.h
//


#import "SDLEnum.h"

/**
 * The list of potential compass directions.
 *
 * @since SDL 2.0
 */
@interface SDLCompassDirection : SDLEnum {
}

/**
 * @abstract Convert String to SDLCompassDirection
 * @param value The value of the string to get an object for
 * @return SDLCompassDirection
 */
+ (SDLCompassDirection *)valueOf:(NSString *)value;

/**
 * @abstract Store the enumeration of all possible SDLCompassDirection
 * @return An array that store all possible SDLCompassDirection
 */
+ (NSArray *)values;

/**
 * @abstract Direction North
 * @return A SDLCompassDirection with the value of *NORTH*
 */
+ (SDLCompassDirection *)NORTH;

/**
 * @abstract Direction Northwest
 * @return A SDLCompassDirection with the value of *NORTHWEST*
 */
+ (SDLCompassDirection *)NORTHWEST;

/**
 * @abstract Direction West
 * @return A SDLCompassDirection with the value of *WEST*
 */
+ (SDLCompassDirection *)WEST;

/**
 * @abstract Direction Southwest
 * @return A SDLCompassDirection with the value of *SOUTHWEST*
 */
+ (SDLCompassDirection *)SOUTHWEST;

/**
 * @abstract Direction South
 * @return A SDLCompassDirection with the value of *SOUTH*
 */
+ (SDLCompassDirection *)SOUTH;

/**
 * @abstract Direction Southeast
 * @return A SDLCompassDirection with the value of *SOUTHEAST*
 */
+ (SDLCompassDirection *)SOUTHEAST;

/**
 * @abstract Direction East
 * @return A SDLCompassDirection with the value of *EAST*
 */
+ (SDLCompassDirection *)EAST;

/**
 * @abstract Direction Northeast
 * @return A SDLCompassDirection with the value of *NORTHEAST*
 */
+ (SDLCompassDirection *)NORTHEAST;

@end
