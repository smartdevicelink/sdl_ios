//  SDLResetGlobalPropertiesResponse.h
//


#import "SDLRPCResponse.h"

/**
 * Reset Global Properties Response is sent, when SDLResetGlobalProperties has been called
 *
 * Since SmartDeviceLink 1.0
 */
@interface SDLResetGlobalPropertiesResponse : SDLRPCResponse {
}

/**
 * @abstract Constructs a new SDLResetGlobalPropertiesResponse object
 */
- (instancetype)init;
/**
 * @abstract Constructs a new SDLResetGlobalPropertiesResponse object indicated by the NSMutableDictionary
 * parameter
 * @param dict The dictionary to use
 */
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

@end
