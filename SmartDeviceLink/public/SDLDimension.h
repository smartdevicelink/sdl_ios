//  SDLDimension.h
//


#import "SDLEnum.h"

/**
 * The supported dimensions of the GPS. Used in GPSData
 *
 * @since SDL 2.0
 */
typedef SDLEnum SDLDimension NS_TYPED_ENUM;

/**
 * No GPS at all
 */
extern SDLDimension const SDLDimensionNoFix;

/**
 * Longitude and latitude of the GPS
 */
extern SDLDimension const SDLDimension2D;

/**
 * Longitude and latitude and altitude of the GPS
 */
extern SDLDimension const SDLDimension3D;
