//  SDLCompassDirection.h
//



#import "SDLEnum.h"

/**
 * The list of potential compass directions.
 *
 * This enum is avaliable since <font color=red><b>SmartDeviceLink 2.0</b></font>
 */
@interface SDLCompassDirection : SDLEnum {}

/**
 * @abstract Convert String to SDLCompassDirection
 * @param value NSString
 * @result SDLCompassDirection
 *
 */
+(SDLCompassDirection*) valueOf:(NSString*) value;

/*!
 @abstract Store the enumeration of all possible SDLCompassDirection
 @result return an array that store all possible SDLCompassDirection
 */
+(NSArray*) values;

/**
 * @abstract Direction North
 * @result return a SDLCompassDirection with the value of <font color=gray><i>NORTH</i></font>
 */
+(SDLCompassDirection*) NORTH;

/**
 * @abstract Direction Northwest
 * @result return a SDLCompassDirection with the value of <font color=gray><i>NORTHWEST</i></font>
 */
+(SDLCompassDirection*) NORTHWEST;

/**
 * @abstract Direction West
 * @result return a SDLCompassDirection with the value of <font color=gray><i>WEST</i></font>
 */
+(SDLCompassDirection*) WEST;

/**
 * @abstract Direction Southwest
 * @result return a SDLCompassDirection with the value of <font color=gray><i>SOUTHWEST</i></font>
 */
+(SDLCompassDirection*) SOUTHWEST;

/**
 * @abstract Direction South
 * @result return a SDLCompassDirection with the value of <font color=gray><i>SOUTH</i></font>
 */
+(SDLCompassDirection*) SOUTH;

/**
 * @abstract Direction Southeast
 * @result return a SDLCompassDirection with the value of <font color=gray><i>SOUTHEAST</i></font>
 */
+(SDLCompassDirection*) SOUTHEAST;

/**
 * @abstract Direction East
 * @result return a SDLCompassDirection with the value of <font color=gray><i>EAST</i></font>
 */
+(SDLCompassDirection*) EAST;

/**
 * @abstract Direction Northeast
 * @result return a SDLCompassDirection with the value of <font color=gray><i>NORTHEAST</i></font>
 */
+(SDLCompassDirection*) NORTHEAST;

@end
