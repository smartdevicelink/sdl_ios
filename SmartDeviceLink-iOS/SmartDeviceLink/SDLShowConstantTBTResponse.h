//  SDLShowConstantTBTResponse.h
//


#import "SDLRPCResponse.h"

/** SDLShowConstantTBTResponse is sent, when SDLShowConstantTBT has been called.
 * Since<b>SmartDeviceLink 2.0</b>
 */
@interface SDLShowConstantTBTResponse : SDLRPCResponse {
}

- (instancetype)init;
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

@end
