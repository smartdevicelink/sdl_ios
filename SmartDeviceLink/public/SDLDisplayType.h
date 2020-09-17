//  SDLDisplayType.h
//


#import "SDLEnum.h"

/**
 Identifies the various display types used by SDL. Used in DisplayCapabilities.

 @warning This should not be used to identify features of a display, this is a deprecated parameter.

 @deprecated
 @history SDL 1.0.0
 @since SDL 5.0.0
 */
typedef SDLEnum SDLDisplayType NS_TYPED_ENUM __deprecated;

/**
 * This display type provides a 2-line x 20 character "dot matrix" display.
 */
extern SDLDisplayType const SDLDisplayTypeCID __deprecated;

/**
 * Display type 2
 */
extern SDLDisplayType const SDLDisplayTypeType2 __deprecated;

/**
 * Display type 5
 */
extern SDLDisplayType const SDLDisplayTypeType5 __deprecated;

/**
 * This display type provides an 8 inch touchscreen display.
 */
extern SDLDisplayType const SDLDisplayTypeNGN __deprecated;

/**
 * Display type Gen 28 DMA
 */
extern SDLDisplayType const SDLDisplayTypeGen28DMA __deprecated;

/**
 * Display type Gen 26 DMA
 */
extern SDLDisplayType const SDLDisplayTypeGen26DMA __deprecated;

/**
 * Display type MFD3
 */
extern SDLDisplayType const SDLDisplayTypeMFD3 __deprecated;

/**
 * Display type MFD4
 */
extern SDLDisplayType const SDLDisplayTypeMFD4 __deprecated;

/**
 * Display type MFD5
 */
extern SDLDisplayType const SDLDisplayTypeMFD5 __deprecated;

/**
 * Display type Gen 3 8-inch
 */
extern SDLDisplayType const SDLDisplayTypeGen38Inch __deprecated;

/**
 * Display type Generic
 */
extern SDLDisplayType const SDLDisplayTypeGeneric __deprecated;
