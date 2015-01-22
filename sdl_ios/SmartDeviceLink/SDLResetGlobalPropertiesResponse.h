//  SDLResetGlobalPropertiesResponse.h
//
// 

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCResponse.h>

/**
 * Reset Global Properties Response is sent, when SDLResetGlobalProperties has been called
 *
 * Since SmartDeviceLink 1.0
 */
@interface SDLResetGlobalPropertiesResponse : SDLRPCResponse {}

/**
 * @abstract Constructs a new SDLResetGlobalPropertiesResponse object
 */
-(id) init;
/**
 * @abstract Constructs a new SDLResetGlobalPropertiesResponse object indicated by the NSMutableDictionary
 * parameter
 * @param dict The NSMutableDictionary to use
 */
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@end
