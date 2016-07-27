//  SDLUpdateTurnListResponse.h
//

#import "SDLRPCResponse.h"


/** SDLUpdateTurnListResponse is sent, when SDLUpdateTurnList has been called.
 * Since<b>SmartDeviceLink 2.0</b>
 */
@interface SDLUpdateTurnListResponse : SDLRPCResponse {
}

- (instancetype)init;
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

@end
