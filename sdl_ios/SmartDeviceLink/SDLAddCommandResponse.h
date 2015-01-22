//  SDLAddCommandResponse.h
//
//  

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCResponse.h>

/**
 * SDLAddCommandResponse is sent, when SDLAddCommand has been called
 *
 * Since <b>SmartDeviceLink 1.0</b>
 */
@interface SDLAddCommandResponse : SDLRPCResponse {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@end
