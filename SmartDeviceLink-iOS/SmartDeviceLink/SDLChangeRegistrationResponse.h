//  SDLChangeRegistrationResponse.h
//


#import "SDLRPCResponse.h"

/**
 * SDLChangeRegistrationResponse is sent, when SDLChangeRegistration has been called
 *
 * Since <b>SmartDeviceLink 2.0
 */
@interface SDLChangeRegistrationResponse : SDLRPCResponse {
}

- (id)init;
- (id)initWithDictionary:(NSMutableDictionary *)dict;

@end
