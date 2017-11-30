//  SDLTextAlignment.h
//


#import "SDLEnum.h"

/**
 * The list of possible alignments of text in a field. May only work on some display types.
 *
 * @since SDL 1.0
 */
typedef SDLEnum SDLTextAlignment SDL_SWIFT_ENUM;

/**
 * @abstract Text aligned left.
 */
extern SDLTextAlignment const SDLTextAlignmentLeft;

/**
 * @abstract Text aligned right.
 */
extern SDLTextAlignment const SDLTextAlignmentRight;

/**
 * @abstract Text aligned centered.
 */
extern SDLTextAlignment const SDLTextAlignmentCenter;
