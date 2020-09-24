//  SDLTextAlignment.h
//


#import "SDLEnum.h"

/**
 * The list of possible alignments of text in a field. May only work on some display types. used in Show.
 *
 * @since SDL 1.0
 */
typedef SDLEnum SDLTextAlignment NS_TYPED_ENUM;

/**
 * Text aligned left.
 */
extern SDLTextAlignment const SDLTextAlignmentLeft;

/**
 * Text aligned right.
 */
extern SDLTextAlignment const SDLTextAlignmentRight;

/**
 * Text aligned centered.
 */
extern SDLTextAlignment const SDLTextAlignmentCenter;
