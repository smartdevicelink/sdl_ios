//  SDLTextAlignment.h
//


#import "SDLEnum.h"

/**
 * The list of possible alignments of text in a field. May only work on some display types.
 *
 * @since SDL 1.0
 */
@interface SDLTextAlignment : SDLEnum {
}

/**
 * Convert String to SDLTextAlignment
 *
 * @param value The value of the string to get an object for
 *
 * @return SDLTextAlignment
 */
+ (SDLTextAlignment *)valueOf:(NSString *)value;

/**
 * @abstract Store the enumeration of all possible SDLTextAlignment
 *
 * @return an array that store all possible SDLTextAlignment
 */
+ (NSArray *)values;

/**
 * @abstract Text aligned left.
 *
 * @return A SDLTextAlignment object with value of *LEFT_ALIGNED*
 */
+ (SDLTextAlignment *)LEFT_ALIGNED;

/**
 * @abstract Text aligned right.
 *
 * @return A SDLTextAlignment object with value of *RIGHT_ALIGNED*
 */
+ (SDLTextAlignment *)RIGHT_ALIGNED;

/**
 * @abstract Text aligned centered.
 *
 * @return A SDLTextAlignment object with value of *CENTERED*
 */
+ (SDLTextAlignment *)CENTERED;

@end
