//  SDLWiperStatus.h
//


#import "SDLEnum.h"

/**
 * Wiper Status
 */
@interface SDLWiperStatus : SDLEnum {
}

/**
 * Convert String to SDLWiperStatus
 * @param value The value of the string to get an object for
 * @return SDLWiperStatus
 */
+ (SDLWiperStatus *)valueOf:(NSString *)value;

/**
 * @abstract Store the enumeration of all possible SDLWiperStatus
 * @return An array that store all possible SDLWiperStatus
 */
+ (NSArray *)values;

/**
 * @abstract SDLWiperStatus: *OFF*
 */
+ (SDLWiperStatus *)OFF;

/**
 * @abstract SDLWiperStatus: *AUTO_OFF*
 */
+ (SDLWiperStatus *)AUTO_OFF;

/**
 * @abstract SDLWiperStatus: *OFF_MOVING*
 */
+ (SDLWiperStatus *)OFF_MOVING;

/**
 * @abstract SDLWiperStatus: *MAN_INT_OFF*
 */
+ (SDLWiperStatus *)MAN_INT_OFF;

/**
 * @abstract SDLWiperStatus: *MAN_INT_ON*
 */
+ (SDLWiperStatus *)MAN_INT_ON;

/**
 * @abstract SDLWiperStatus: *MAN_LOW*
 */
+ (SDLWiperStatus *)MAN_LOW;

/**
 * @abstract SDLWiperStatus: *MAN_HIGH*
 */
+ (SDLWiperStatus *)MAN_HIGH;

/**
 * @abstract SDLWiperStatus: *MAN_FLICK*
 */
+ (SDLWiperStatus *)MAN_FLICK;

/**
 * @abstract SDLWiperStatus: *WASH*
 */
+ (SDLWiperStatus *)WASH;

/**
 * @abstract SDLWiperStatus: *AUTO_LOW*
 */
+ (SDLWiperStatus *)AUTO_LOW;

/**
 * @abstract SDLWiperStatus: *AUTO_HIGH*
 */
+ (SDLWiperStatus *)AUTO_HIGH;

/**
 * @abstract SDLWiperStatus: *COURTESYWIPE*
 */
+ (SDLWiperStatus *)COURTESYWIPE;

/**
 * @abstract SDLWiperStatus: *AUTO_ADJUST*
 */
+ (SDLWiperStatus *)AUTO_ADJUST;

/**
 * @abstract SDLWiperStatus: *STALLED*
 */
+ (SDLWiperStatus *)STALLED;

/**
 * @abstract SDLWiperStatus: *NO_DATA_EXISTS*
 */
+ (SDLWiperStatus *)NO_DATA_EXISTS;

@end
