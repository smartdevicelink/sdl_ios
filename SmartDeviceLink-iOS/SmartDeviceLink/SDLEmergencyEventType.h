//  SDLEmergencyEventType.h
//


#import "SDLEnum.h"

/** Reflects the emergency event status of the vehicle.
 *<b> Since:</b> SmartDeviceLink 2.0
 *<p>
 */

@interface SDLEmergencyEventType : SDLEnum {
}

+ (SDLEmergencyEventType *)valueOf:(NSString *)value;
+ (NSArray *)values;

/** No emergency event has happened.
 */

+ (SDLEmergencyEventType *)NO_EVENT;

/** Frontal collision has happened.
 */

+ (SDLEmergencyEventType *)FRONTAL;

/** Side collision has happened.
 */

+ (SDLEmergencyEventType *)SIDE;

/**Rear collision has happened.
 */

+ (SDLEmergencyEventType *)REAR;

/** A rollover event has happened.
 */

+ (SDLEmergencyEventType *)ROLLOVER;

/** The signal is not supported
 */

+ (SDLEmergencyEventType *)NOT_SUPPORTED;

/** Emergency status cannot be determined
 */

+ (SDLEmergencyEventType *)FAULT;

@end
