//  SDLAddCommandResponse.h


#import "SDLRPCResponse.h"


/**
 * SDLAddCommandResponse is sent, when SDLAddCommand has been called
 *
 * Since <b>SmartDeviceLink 1.0</b>
 */
@interface SDLAddCommandResponse : SDLRPCResponse {
}

- (instancetype)init;
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

@end
