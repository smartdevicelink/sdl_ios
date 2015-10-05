//  SDLSystemRequestResponse.h
//


#import "SDLRPCResponse.h"

/** SDLSystemRequestResponse is sent, when SDLSystemRequest has been called.
 * Since<b>SmartDeviceLink 3.0</b>
 */
@interface SDLSystemRequestResponse : SDLRPCResponse {
}

- (instancetype)init;
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

@end
