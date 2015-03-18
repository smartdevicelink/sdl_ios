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
- (id)init;
/**
 * @abstract Constructs a new SDLSubscribeButtonResponse object indicated by the NSMutableDictionary
 * parameter
 * @param dict The NSMutableDictionary to use
 */
- (id)initWithDictionary:(NSMutableDictionary *)dict;

@end
