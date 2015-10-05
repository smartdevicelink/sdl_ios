//  SDLImageType.h
//


#import "SDLEnum.h"

/**
* Contains information about the type of image.
*
* @since SDL 2.0
*/
@interface SDLImageType : SDLEnum {
}

/**
 * @abstract return SDLImageType (STATIC / DYNAMIC)
 *
 * @param value The value of the string to get an object for
 *
 * @return An SDLImageType
 */
+ (SDLImageType *)valueOf:(NSString *)value;

/**
 * @abstract store all possible SDLImageType values
 *
 * @return An array with all possible SDLImageType values inside
 */
+ (NSArray *)values;

/**
 * @abstract Just the static hex icon value to be used
 *
 * @return The Image Type with value *STATIC*
 */
+ (SDLImageType *)STATIC;

/**
 * @abstract Binary image file to be used (identifier to be sent by SDLPutFile)
 *
 * @see SDLPutFile
 *
 * @return The Image Type with value *DYNAMIC*
 */
+ (SDLImageType *)DYNAMIC;

@end
