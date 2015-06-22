//  SDLSetAppIconResponse.h
//


#import "SDLRPCResponse.h"

/** SDLSetAppIconResponse is sent, when SDLSetAppIcon has been called.
 * Since<b>SmartDeviceLink 2.0</b>
 */
@interface SDLSetAppIconResponse : SDLRPCResponse {
}

- (instancetype)init;
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

@end
