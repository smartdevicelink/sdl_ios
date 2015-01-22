//  SDLChangeRegistrationResponse.h
//
// 

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCResponse.h>

/**
 * SDLChangeRegistrationResponse is sent, when SDLChangeRegistration has been called
 *
 * Since <b>SmartDeviceLink 2.0</b>
 */
@interface SDLChangeRegistrationResponse : SDLRPCResponse {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@end
