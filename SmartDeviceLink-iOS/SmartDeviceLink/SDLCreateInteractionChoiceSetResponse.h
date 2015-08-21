//  SDLCreateInteractionChoiceSetResponse.h
//


#import "SDLRPCResponse.h"

/**
 * SDLCreateInteractionChoiceSetResponse is sent, when SDLCreateInteractionChoiceSet
 * has been called
 *
 * Since <b>SmartDeviceLink 1.0</b>
 */
@interface SDLCreateInteractionChoiceSetResponse : SDLRPCResponse {
}

- (instancetype)init;
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

@end
