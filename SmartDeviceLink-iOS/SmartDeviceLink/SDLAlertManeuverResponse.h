//  SDLAlertManeuverResponse.h
//



#import "SDLRPCResponse.h"

/** SDLAlertManeuverResponse is sent, when SDLAlertManeuver has been called.
 * @since SmartDeviceLink 1.0
 */
@interface SDLAlertManeuverResponse : SDLRPCResponse {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@end
