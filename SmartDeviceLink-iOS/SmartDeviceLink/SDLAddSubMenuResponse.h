//  SDLAddSubMenuResponse.h


#import "SDLRPCResponse.h"

/**
 * SDLAddSubMenuResponse is sent, when SDLAddSubMenu has been called
 * Since <b>SmartDeviceLink 1.0</b>
 */
@interface SDLAddSubMenuResponse : SDLRPCResponse {
}

- (instancetype)init;
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

@end
