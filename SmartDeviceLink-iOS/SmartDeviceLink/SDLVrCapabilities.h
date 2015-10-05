//  SDLVRCapabilities.h
//


#import "SDLEnum.h"

/**
 * The VR capabilities of the connected SDL platform.
 *
 * @since SDL 1.0
 */
@interface SDLVRCapabilities : SDLEnum {
}

/**
 * Convert String to SDLVRCapabilities
 * @param value The value of the string to get an object for
 * @return SDLVRCapabilities
 */
+ (SDLVRCapabilities *)valueOf:(NSString *)value;

/**
 * @abstract Store the enumeration of all possible SDLVRCapabilities
 * @return an array that store all possible SDLVRCapabilities
 */
+ (NSArray *)values;

/**
 * @abstract The SDL platform is capable of recognizing spoken text in the current language.
 * @return an SDLVRCapabilities instance pointer with value of *TEXT*
 */
+ (SDLVRCapabilities *)TEXT;

@end
