//  SDLIgnitionStableStatus.h
//


#import "SDLEnum.h"

/**
 * Reflects the ignition switch stability.
 *
 * This enum is avaliable since <font color=red><b> SmartDeviceLink 2.0 </b></font>
 */
@interface SDLIgnitionStableStatus : SDLEnum {
}

/*!
 @abstract return SDLIgnitionStableStatus (IGNITION_SWITCH_NOT_STABLE / IGNITION_SWITCH_STABLE)
 @param value NSString
 @result return SDLIgnitionStableStatus
 */
+ (SDLIgnitionStableStatus *)valueOf:(NSString *)value;
/*!
 @abstract store all possible SDLIgnitionStableStatus values
 @result return an array with all possible SDLIgnitionStableStatus values inside
 */
+ (NSMutableArray *)values;

/**
 * @abstract The current ignition switch status is considered not to be stable.
 * @result return the Ignition Stable Status with value of <font color=gray><i> IGNITION_SWITCH_NOT_STABLE </i></font>
 */
+ (SDLIgnitionStableStatus *)IGNITION_SWITCH_NOT_STABLE;
/**
 * @abstract The current ignition switch status is considered to be stable.
 * @result return the Ignition Stable Status with value of <font color=gray><i> IGNITION_SWITCH_STABLE </i></font>
 */
+ (SDLIgnitionStableStatus *)IGNITION_SWITCH_STABLE;
+ (SDLIgnitionStableStatus *)MISSING_FROM_TRANSMITTER;

@end
