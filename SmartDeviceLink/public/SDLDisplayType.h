//  SDLDisplayType.h
//


#import "SDLEnum.h"

/**
 Identifies the various display types used by SDL. Used in DisplayCapabilities.

 @warning This should not be used to identify features of a display, this is a deprecated parameter.

 @since SDL 1.0
 */
typedef SDLEnum SDLDisplayType SDL_SWIFT_ENUM;

/**
 * This display type provides a 2-line x 20 character "dot matrix" display.
 */
extern SDLDisplayType const SDLDisplayTypeCID;

/**
 * Display type 2
 */
extern SDLDisplayType const SDLDisplayTypeType2;

/**
 * Display type 5
 */
extern SDLDisplayType const SDLDisplayTypeType5;

/**
 * This display type provides an 8 inch touchscreen display.
 */
extern SDLDisplayType const SDLDisplayTypeNGN;

/**
 * Display type Gen 28 DMA
 */
extern SDLDisplayType const SDLDisplayTypeGen28DMA;

/**
 * Display type Gen 26 DMA
 */
extern SDLDisplayType const SDLDisplayTypeGen26DMA;

/**
 * Display type MFD3
 */
extern SDLDisplayType const SDLDisplayTypeMFD3;

/**
 * Display type MFD4
 */
extern SDLDisplayType const SDLDisplayTypeMFD4;

/**
 * Display type MFD5
 */
extern SDLDisplayType const SDLDisplayTypeMFD5;

/**
 * Display type Gen 3 8-inch
 */
extern SDLDisplayType const SDLDisplayTypeGen38Inch;

/**
 * Display type Generic
 */
extern SDLDisplayType const SDLDisplayTypeGeneric;
