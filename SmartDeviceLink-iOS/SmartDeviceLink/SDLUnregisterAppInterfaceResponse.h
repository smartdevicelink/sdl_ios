//  SDLUnregisterAppInterfaceResponse.h
//



#import "SDLRPCResponse.h"

/**
 * Unregister AppInterface Response is sent, when SDLUnregisterAppInterface has been called
 *
 * @since SmartDeviceLink 1.0
 */
@interface SDLUnregisterAppInterfaceResponse : SDLRPCResponse {}

/**
 * @abstract Constructs a new SDLUnregisterAppInterfaceResponse object
 */
-(id) init;
/**
 * @abstract Constructs a new SDLUnregisterAppInterfaceResponse object indicated by the NSMutableDictionary
 * parameter
 * @param dict The NSMutableDictionary to use
 */
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@end
