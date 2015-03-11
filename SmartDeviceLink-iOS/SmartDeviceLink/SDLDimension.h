//  SDLDimension.h
//


#import "SDLEnum.h"

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLEnum.h>

/**
 * The supported dimensions of the GPS.
 *
 * This enum is avaliable since <font color=red><b>SmartDeviceLink 2.0</b></font>
 */
@interface SDLDimension : SDLEnum {}

/**
 * Convert String to SDLDimension
 * @param value String
 * @return SDLDimension
 */
+(SDLDimension*) valueOf:(NSString*) value;
/*!
 @abstract Store the enumeration of all possible SDLDimension
 @result return an array that store all possible SDLDimension
 */
+(NSArray*) values;

/*!
 @abstract No GPS at all
 @result return the dimension with value of <font color=gray><i> NO_FIX </i></font>
 */
+(SDLDimension*) NO_FIX;
/*!
 @abstract Longitude and latitude
 @result return the dimension with value of <font color=gray><i> 2D </i></font>
 */
+(SDLDimension*) _2D;
/*!
 @abstract Longitude and latitude and altitude
 @result return the dimension with value of <font color=gray><i> 3D </i></font>
 */
+(SDLDimension*) _3D;

@end
