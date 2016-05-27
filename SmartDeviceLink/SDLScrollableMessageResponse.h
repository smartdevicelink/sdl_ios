//  SDLScrollableMessageResponse.h
//


#import "SDLRPCResponse.h"

/**
 * Scrollable Message Response is sent, when SDLScrollableMessage has been called
 *
 * Since SmartDeviceLink 2.0
 */
@interface SDLScrollableMessageResponse : SDLRPCResponse {
}

/**
 * @abstract Constructs a new SDLScrollableMessageResponse object
 */
- (instancetype)init;
/**
 * @abstract Constructs a new SDLScrollableMessageResponse object indicated by the NSMutableDictionary
 * parameter
 * @param dict The dictionary to use
 */
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

@end
