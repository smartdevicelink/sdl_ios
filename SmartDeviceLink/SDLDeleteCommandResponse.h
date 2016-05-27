//  SDLDeleteCommandResponse.h
//


#import "SDLRPCResponse.h"

/**
 * SDLDeleteCommandResponse is sent, when SDLDeleteCommand has been called
 *
 * Since <b>SmartDeviceLink 1.0</b><br>
 */
@interface SDLDeleteCommandResponse : SDLRPCResponse {
}

- (instancetype)init;
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

@end
