//  SDLDimension.h
//


#import "SDLEnum.h"

#import <Foundation/Foundation.h>

/**
 * The supported dimensions of the GPS.
 *
 * @since SDL 2.0
 */
@interface SDLDimension : SDLEnum {
}

/**
 * Convert String to SDLDimension
 *
 * @param value The value of the string to get an object for
 *
 * @return SDLDimension
 */
+ (SDLDimension *)valueOf:(NSString *)value;

/**
 * @abstract Store the enumeration of all possible SDLDimension
 *
 * @return An array that store all possible SDLDimension
 */
+ (NSArray *)values;

/**
 * @abstract No GPS at all
 * @return the dimension with value of *NO_FIX*
 */
+ (SDLDimension *)NO_FIX;

/**
 * @abstract Longitude and latitude of the GPS
 * @return the dimension with value of *2D*
 */
+ (SDLDimension *)_2D;

/**
 * @abstract Longitude and latitude and altitude of the GPS
 * @return the dimension with value of *3D*
 */
+ (SDLDimension *)_3D;

@end
