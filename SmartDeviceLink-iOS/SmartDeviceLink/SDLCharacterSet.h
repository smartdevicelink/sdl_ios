//  SDLCharacterSet.h
//


#import "SDLEnum.h"

/**
 * Character sets supported by SDL.
 *
 * @since SDL 1.0
 */
@interface SDLCharacterSet : SDLEnum {
}

/**
 * @abstract Convert String to SDLCharacterSet
 *
 * @param value The value of the string to get an object for
 *
 * @return SDLCharacterSet
 */
+ (SDLCharacterSet *)valueOf:(NSString *)value;

/**
 * @abstract Store the enumeration of all possible SDLCharacterSet
 *
 * @return an array that store all possible SDLCharacterSet
 */
+ (NSArray *)values;

+ (SDLCharacterSet *)TYPE2SET;

+ (SDLCharacterSet *)TYPE5SET;

+ (SDLCharacterSet *)CID1SET;

+ (SDLCharacterSet *)CID2SET;

@end
