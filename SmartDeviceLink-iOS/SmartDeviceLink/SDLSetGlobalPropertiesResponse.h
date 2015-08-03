//  SDLSetGlobalPropertiesResponse.h
//


#import "SDLRPCResponse.h"

/**
 * Set Global Properties Response is sent, when SDLSetGlobalProperties has been called
 *
 * Since SmartDeviceLink 1.0
 */
@interface SDLSetGlobalPropertiesResponse : SDLRPCResponse {
}

/**
 * @abstract Constructs a new SDLSetGlobalPropertiesResponse object
 */
- (instancetype)init;
/**
 * @abstract Constructs a new SDLSetGlobalPropertiesResponse object indicated by the NSMutableDictionary
 * parameter
 * @param dict The dictionary to use
 */
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

@end
