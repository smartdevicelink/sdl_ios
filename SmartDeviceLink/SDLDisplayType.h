//  SDLDisplayType.h
//


#import "SDLEnum.h"

/**
 * Identifies the various display types used by SDL.
 *
 * @since SDL 1.0
 */
@interface SDLDisplayType : SDLEnum {
}

/**
 * Convert String to SDLDisplayType
 *
 * @param value The value of the string to get an object for
 *
 * @return SDLDisplayType
 */
+ (SDLDisplayType *)valueOf:(NSString *)value;

/**
 * @abstract Store the enumeration of all possible SDLDisplayType
 *
 * @return an array that store all possible SDLDisplayType
 */
+ (NSArray *)values;

/**
 * @abstract This display type provides a 2-line x 20 character "dot matrix" display.
 *
 * @return SDLDisplayType with value of *CID*
 */
+ (SDLDisplayType *)CID;

+ (SDLDisplayType *)TYPE2;

+ (SDLDisplayType *)TYPE5;

/**
 * @abstract This display type provides an 8 inch touchscreen display.
 *
 * @return SDLDisplayType with value of *NGN*
 */
+ (SDLDisplayType *)NGN;

+ (SDLDisplayType *)GEN2_8_DMA;

+ (SDLDisplayType *)GEN2_6_DMA;

+ (SDLDisplayType *)MFD3;

+ (SDLDisplayType *)MFD4;

+ (SDLDisplayType *)MFD5;

+ (SDLDisplayType *)GEN3_8_INCH;

+ (SDLDisplayType *)GENERIC;

@end
