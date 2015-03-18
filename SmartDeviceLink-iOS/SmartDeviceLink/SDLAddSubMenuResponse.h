//  SDLAddSubMenuResponse.h


#import "SDLRPCResponse.h"

/**
 * SDLAddSubMenuResponse is sent, when SDLAddSubMenu has been called
 * Since <b>SmartDeviceLink 1.0</b>
 */
@interface SDLAddSubMenuResponse : SDLRPCResponse {
}

- (id)init;
- (id)initWithDictionary:(NSMutableDictionary *)dict;

@end
