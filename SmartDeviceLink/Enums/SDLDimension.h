//  SDLDimension.h
//


#import "SDLEnum.h"

/**
 * The supported dimensions of the GPS.
 *
 * @since SDL 2.0
 */
typedef SDLEnum SDLDimension SDL_SWIFT_ENUM;

/**
 * @abstract No GPS at all
 */
extern SDLDimension const SDLDimensionNoFix;

/**
 * @abstract Longitude and latitude of the GPS
 */
extern SDLDimension const SDLDimension2D;

/**
 * @abstract Longitude and latitude and altitude of the GPS
 */
extern SDLDimension const SDLDimension3D;
