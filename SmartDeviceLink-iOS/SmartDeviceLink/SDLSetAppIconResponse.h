//  SDLSetAppIconResponse.h
//



#import "SDLRPCResponse.h"

/** SDLSetAppIconResponse is sent, when SDLSetAppIcon has been called.
 * Since<b>SmartDeviceLink 2.0</b>
 */
@interface SDLSetAppIconResponse : SDLRPCResponse {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@end
