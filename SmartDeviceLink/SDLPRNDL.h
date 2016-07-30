//  SDLPRNDL.h
//


#import "SDLEnum.h"

/**
 * The selected gear the car is in.
 *
 * @since SDL 2.0
 */
@interface SDLPRNDL : SDLEnum {
}

/**
 * @abstract get SDLPRNDL according value string
 *
 * @param value The value of the string to get an object for
 *
 * @return SDLPRNDL object
 */
+ (SDLPRNDL *)valueOf:(NSString *)value;

/**
 * @abstract declare an array to store all possible SDLPRNDL values
 *
 * @return the array
 */
+ (NSArray *)values;

/**
 *  @abstract Park
 *
 *  @return SDLPRNDL: *PARK*
 */
+ (SDLPRNDL *)PARK;

/**
 *  @abstract Reverse gear
 *
 *  @return SDLPRNDL: *REVERSE*
 */
+ (SDLPRNDL *)REVERSE;

/**
 *  @abstract No gear
 *
 *  @return SDLPRNDL: *NEUTRAL*
 */
+ (SDLPRNDL *)NEUTRAL;

/**
 *  @abstract: Drive gear
 *
 *  @return SDLPRNDL: *DRIVE*
 */
+ (SDLPRNDL *)DRIVE;

/**
 * @abstract Drive Sport mode
 *
 * @return SDLPRNDL: *SPORT*
 */
+ (SDLPRNDL *)SPORT;

/**
 * @abstract 1st gear hold
 *
 * @return SDLPRNDL: *LOWGEAR*
 */
+ (SDLPRNDL *)LOWGEAR;

/**
 * @abstract First gear
 *
 * @return SDLPRNDL: *FIRST*
 */
+ (SDLPRNDL *)FIRST;

/**
 * @abstract Second gear
 *
 * @return SDLPRNDL: *SECOND*
 */
+ (SDLPRNDL *)SECOND;

/**
 * @abstract Third gear
 *
 * @return SDLPRNDL: *THIRD*
 */
+ (SDLPRNDL *)THIRD;

/**
 * @abstract Fourth gear
 *
 * @return SDLPRNDL: *FOURTH*
 */
+ (SDLPRNDL *)FOURTH;

/**
 * @abstract Fifth gear
 *
 * @return SDLPRNDL: *FIFTH*
 */
+ (SDLPRNDL *)FIFTH;

/**
 * @abstract Sixth gear
 *
 * @return SDLPRNDL: *SIXTH*
 */
+ (SDLPRNDL *)SIXTH;

/**
 * @abstract Seventh gear
 *
 * @return SDLPRNDL: *SEVENTH*
 */
+ (SDLPRNDL *)SEVENTH;

/**
 * @abstract Eighth gear
 *
 * @return SDLPRNDL: *EIGHTH*
 */
+ (SDLPRNDL *)EIGHTH;

/**
 * @abstract Unknown
 *
 * @return SDLPRNDL: *UNKNOWN*
 */
+ (SDLPRNDL *)UNKNOWN;

/**
 * @abstract Fault
 *
 * @return SDLPRNDL: *FAULT*
 */
+ (SDLPRNDL *)FAULT;

@end
