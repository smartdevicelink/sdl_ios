//  SDLSubscribeButtonResponse.h
//


#import "SDLRPCResponse.h"

/**
 * SubscribeButton Response is sent, when SDLSubscribeButton has been called
 *
 * Since SmartDeviceLink 1.0
 */
@interface SDLSubscribeButtonResponse : SDLRPCResponse {
}

/**
 * @abstract Constructs a new SDLSubscribeButtonResponse object
 */
- (instancetype)init;
/**
 * @abstract Constructs a new SDLSubscribeButtonResponse object indicated by the NSMutableDictionary
 * parameter
 * @param dict The dictionary to use
 */
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

@end
