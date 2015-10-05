//  SDLShowResponse.h
//


#import "SDLRPCResponse.h"

/**
 * Show Response is sent, when Show has been called
 *
 * Since SmartDeviceLink 1.0
 */
@interface SDLShowResponse : SDLRPCResponse {
}

/**
 * @abstract Constructs a new SDLShowResponse object
 */
- (instancetype)init;
/**
 * @abstract Constructs a new SDLShowResponse object indicated by the NSMutableDictionary
 * parameter
 * @param dict The dictionary to use
 */
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

@end
