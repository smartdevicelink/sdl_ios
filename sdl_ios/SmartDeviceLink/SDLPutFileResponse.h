//  SDLPutFileResponse.h
//
// 

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCResponse.h>

/**
 * Put File Response is sent, when SDLPutFile has been called
 *
 * Since SmartDeviceLink 2.0
 */
@interface SDLPutFileResponse : SDLRPCResponse {}

/**
 * @abstract Constructs a new SDLPutFileResponse object
 */
-(id) init;
/**
 * @abstract Constructs a new SDLPutFileResponse object indicated by the NSMutableDictionary parameter
 * @param dict The NSMutableDictionary to use
 */
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) NSNumber* spaceAvailable;

@end
