//  SDLUnregisterAppInterfaceResponse.h
//


#import "SDLRPCResponse.h"

/**
 * Unregister AppInterface Response is sent, when SDLUnregisterAppInterface has been called
 *
 * @since SmartDeviceLink 1.0
 */
@interface SDLUnregisterAppInterfaceResponse : SDLRPCResponse {
}

/**
 * @abstract Constructs a new SDLUnregisterAppInterfaceResponse object
 */
- (instancetype)init;
/**
 * @abstract Constructs a new SDLUnregisterAppInterfaceResponse object indicated by the NSMutableDictionary
 * parameter
 * @param dict The dictionary to use
 */
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

@end
