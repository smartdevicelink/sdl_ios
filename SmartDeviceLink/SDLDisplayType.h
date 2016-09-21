//  SDLDisplayType.h
//


#import "SDLEnum.h"

/**
 * Identifies the various display types used by SDL.
 *
 * @since SDL 1.0
 */
typedef SDLEnum SDLDisplayType NS_EXTENSIBLE_STRING_ENUM;

/**
 * @abstract This display type provides a 2-line x 20 character "dot matrix" display.
 */
extern SDLDisplayType const SDLDisplayTypeCid;

extern SDLDisplayType const SDLDisplayTypeType2;

extern SDLDisplayType const SDLDisplayTypeType5;

/**
 * @abstract This display type provides an 8 inch touchscreen display.
 */
extern SDLDisplayType const SDLDisplayTypeNgn;

extern SDLDisplayType const SDLDisplayTypeGen28Dma;

extern SDLDisplayType const SDLDisplayTypeGen26Dma;

extern SDLDisplayType const SDLDisplayTypeMfd3;

extern SDLDisplayType const SDLDisplayTypeMfd4;

extern SDLDisplayType const SDLDisplayTypeMfd5;

extern SDLDisplayType const SDLDisplayTypeGen38Inch;
