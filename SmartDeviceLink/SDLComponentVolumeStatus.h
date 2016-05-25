//  SDLComponentVolumeStatus.h
//


#import "SDLEnum.h"

/**
 * The volume status of a vehicle component.
 *
 * @since SDL 2.0
 */
@interface SDLComponentVolumeStatus : SDLEnum {
}

/**
 * @abstract Convert String to SDLComponentVolumeStatus
 * @param value The value of the string to get an object for
 * @return SDLComponentVolumeStatus
 */
+ (SDLComponentVolumeStatus *)valueOf:(NSString *)value;

/**
 * @abstract Store the enumeration of all possible SDLComponentVolumeStatus
 * @return An array that store all possible SDLComponentVolumeStatus
 */
+ (NSArray *)values;

/**
 * @abstract Unknown SDLComponentVolumeStatus
 * @return a SDLComponentVolumeStatus with the value of *UNKNOWN*
 */
+ (SDLComponentVolumeStatus *)UNKNOWN;

/**
 * @abstract Normal SDLComponentVolumeStatus
 * @return a SDLComponentVolumeStatus with the value of *NORMAL*
 */
+ (SDLComponentVolumeStatus *)NORMAL;

/**
 * @abstract Low SDLComponentVolumeStatus
 * @return a SDLComponentVolumeStatus with the value of *LOW*
 */
+ (SDLComponentVolumeStatus *)LOW;

/**
 * @abstract Fault SDLComponentVolumeStatus
 * @return a SDLComponentVolumeStatus with the value of *FAULT*
 */
+ (SDLComponentVolumeStatus *)FAULT;

/**
 * @abstract Alert SDLComponentVolumeStatus
 * @return a SDLComponentVolumeStatus with the value of *ALERT*
 */
+ (SDLComponentVolumeStatus *)ALERT;

/**
 * @abstract Not supported SDLComponentVolumeStatus
 * @return a SDLComponentVolumeStatus with the value of *NOT_SUPPORTED*
 */
+ (SDLComponentVolumeStatus *)NOT_SUPPORTED;

@end
