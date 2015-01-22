//  SDLAlertManeuverResponse.h
//
// 

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCResponse.h>

/** SDLAlertManeuverResponse is sent, when SDLAlertManeuver has been called.
 *<p>
 * Since<b>SmartDeviceLink 1.0</b>
 */
@interface SDLAlertManeuverResponse : SDLRPCResponse {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@end
