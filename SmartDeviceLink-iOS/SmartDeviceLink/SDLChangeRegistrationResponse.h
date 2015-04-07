//  SDLChangeRegistrationResponse.h
//



#import "SDLRPCResponse.h"

/**
 * SDLChangeRegistrationResponse is sent, when SDLChangeRegistration has been called
 *
 * Since <b>SmartDeviceLink 2.0
 */
@interface SDLChangeRegistrationResponse : SDLRPCResponse {}

-(instancetype) init;
-(instancetype) initWithDictionary:(NSMutableDictionary*) dict;

@end
