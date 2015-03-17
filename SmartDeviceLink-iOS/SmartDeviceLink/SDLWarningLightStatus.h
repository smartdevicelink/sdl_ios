//  SDLWarningLightStatus.h
//



#import "SDLEnum.h"

/**
 * Reflects the status of a cluster instrument warning light.
 *
 * Avaliable since <font color=red><b> SmartDeviceLink 2.0 </b></font>
 */
@interface SDLWarningLightStatus : SDLEnum {}

/**
 * Convert String to SDLWarningLightStatus
 * @param value String
 * @return SDLWarningLightStatus
 */
+(SDLWarningLightStatus*) valueOf:(NSString*) value;
/*!
 @abstract Store the enumeration of all possible SDLWarningLightStatus
 @result return an array that store all possible SDLWarningLightStatus
 */
+(NSMutableArray*) values;

/*!
 @abstract Warninglight Off
 @result return SDLWarningLightStatus instance with value of <font color=gray><i> OFF </i></font>
 */
+(SDLWarningLightStatus*) OFF;
/*!
 @abstract Warninglight On
 @result return SDLWarningLightStatus instance with value of <font color=gray><i> ON </i></font>
 */
+(SDLWarningLightStatus*) ON;
/*!
 @abstract Warninglight is flashing
 @result return SDLWarningLightStatus instance with value of <font color=gray><i> FLASH </i></font>
 */
+(SDLWarningLightStatus*) FLASH;
/*!
 @abstract Not used
 @result return SDLWarningLightStatus instance with value of <font color=gray><i> NOT_USED </i></font>
 */
+(SDLWarningLightStatus*) NOT_USED;

@end

