//  SDLWaypointType.h
//

#import "SDLEnum.h"

@interface SDLWaypointType : SDLEnum

/**
 * @abstract Convert String to SDLWayPointType
 *
 * @param value The value of the string to get an object for
 *
 * @return SDLWayPointType
 */
+ (SDLWaypointType *)valueOf:(NSString *)value;

/**
 * @abstract Store the enumeration of all possible SDLWayPointType
 *
 * @return an array that store all possible SDLWayPointType
 */
+ (NSArray *)values;

/**
 *
 * @return a SDLWayPointType with value of *PROMPT*
 */
+ (SDLWaypointType *)ALL;

/**
 *
 * @return a SDLWayPointType with value of *DESTINATION*
 */
+ (SDLWaypointType *)DESTINATION;

@end
