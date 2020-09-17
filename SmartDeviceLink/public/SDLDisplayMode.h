//  SDLDisplayMode.h
//

#import "SDLEnum.h"

/**
 * Identifies the various display types used by SDL.
 *
 * @since SDL 1.0
 */
typedef SDLEnum SDLDisplayMode NS_TYPED_ENUM;

/**
 * @abstract Display Mode : DAY
 */
extern SDLDisplayMode const SDLDisplayModeDay;

/**
 * @abstract Display Mode : NIGHT.
 */
extern SDLDisplayMode const SDLDisplayModeNight;

/**
 * @abstract Display Mode : AUTO.
 */
extern SDLDisplayMode const SDLDisplayModeAuto;
