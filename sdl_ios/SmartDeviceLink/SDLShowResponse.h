//  SDLShowResponse.h
//
//  

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCResponse.h>

/**
 * Show Response is sent, when Show has been called
 *
 * Since SmartDeviceLink 1.0
 */
@interface SDLShowResponse : SDLRPCResponse {}

/**
 * @abstract Constructs a new SDLShowResponse object
 */
-(id) init;
/**
 * @abstract Constructs a new SDLShowResponse object indicated by the NSMutableDictionary
 * parameter
 * @param dict The NSMutableDictionary to use
 */
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@end
