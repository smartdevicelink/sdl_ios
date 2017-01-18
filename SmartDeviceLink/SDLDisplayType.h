//  SDLDisplayType.h
//


#import "SDLEnum.h"

/**
 * Identifies the various display types used by SDL.
 *
 * @since SDL 1.0
 */
typedef SDLEnum SDLDisplayType SDL_SWIFT_ENUM;

/**
 * @abstract This display type provides a 2-line x 20 character "dot matrix" display.
 */
extern SDLDisplayType const SDLDisplayTypeCID;

extern SDLDisplayType const SDLDisplayTypeType2;

extern SDLDisplayType const SDLDisplayTypeType5;

/**
 * @abstract This display type provides an 8 inch touchscreen display.
 */
extern SDLDisplayType const SDLDisplayTypeNGN;

extern SDLDisplayType const SDLDisplayTypeGen28DMA;

extern SDLDisplayType const SDLDisplayTypeGen26DMA;

extern SDLDisplayType const SDLDisplayTypeMFD3;

extern SDLDisplayType const SDLDisplayTypeMFD4;

extern SDLDisplayType const SDLDisplayTypeMFD5;

extern SDLDisplayType const SDLDisplayTypeGen38Inch;

extern SDLDisplayType const SDLDisplayTypeGeneric;
