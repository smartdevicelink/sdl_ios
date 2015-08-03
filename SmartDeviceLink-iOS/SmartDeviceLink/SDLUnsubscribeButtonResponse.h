//  SDLUnsubscribeButtonResponse.h
//


#import "SDLRPCResponse.h"

/**
 * Unsubscribe Button Response is sent, when SDLUnsubscribeButton has been called
 *
 * @since SmartDeviceLink 1.0
 */
@interface SDLUnsubscribeButtonResponse : SDLRPCResponse {
}

/**
 * @abstract Constructs a new SDLUnsubscribeButtonResponse object
 */
- (instancetype)init;
/**
 * @abstract Constructs a new SDLUnsubscribeButtonResponse object indicated by the NSMutableDictionary
 * parameter
 * @param dict The dictionary to use
 */
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

@end
