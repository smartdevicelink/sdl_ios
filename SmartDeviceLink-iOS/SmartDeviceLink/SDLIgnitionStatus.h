//  SDLIgnitionStatus.h
//



#import "SDLEnum.h"

/**
 * Reflects the status of ignition..
 *
 * This enum is avaliable since <font color=red><b> SmartDeviceLink 2.0 </b></font>
 */
@interface SDLIgnitionStatus : SDLEnum {}

/*!
 @abstract return SDLIgnitionStatus ( UNKNOWN / OFF / ACCESSORY / RUN / START / INVALID )
 @param value NSString
 @result return SDLIgnitionStatus
 */
+(SDLIgnitionStatus*) valueOf:(NSString*) value;
/*!
 @abstract store all possible SDLIgnitionStatus values
 @result return an array with all possible SDLIgnitionStatus values inside
 */
+(NSMutableArray*) values;

/**
 * @abstract Ignition status currently unknown
 * @result return Ignition Status with value of <font color=gray><i> UNKNOWN </i></font>
 */
+(SDLIgnitionStatus*) UNKNOWN;
/**
 * @abstract Ignition is off
 * @result return Ignition Status with value of <font color=gray><i> OFF </i></font>
 */
+(SDLIgnitionStatus*) OFF;
/**
 * @abstract Ignition is in mode accessory
 * @result return Ignition Status with value of <font color=gray><i> ACCESSORY </i></font>
 */
+(SDLIgnitionStatus*) ACCESSORY;
/**
 * @abstract Ignition is in mode run
 * @result return Ignition Status with value of <font color=gray><i> RUN </i></font>
 */
+(SDLIgnitionStatus*) RUN;
/**
 * @abstract Ignition is in mode run
 * @result return Ignition Status with value of <font color=gray><i> START </i></font>
 */
+(SDLIgnitionStatus*) START;
/**
 * @abstract Signal is invalid
 * @result return Ignition Status with value of <font color=gray><i> INVALID </i></font>
 */
+(SDLIgnitionStatus*) INVALID;

@end
