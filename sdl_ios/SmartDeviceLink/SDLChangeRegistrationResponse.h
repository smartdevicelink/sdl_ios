//  SDLChangeRegistrationResponse.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCResponse.h>

/**
 * SDLChangeRegistrationResponse is sent, when SDLChangeRegistration has been called
 *
 * Since <b>AppLink 2.0</b>
 */
@interface SDLChangeRegistrationResponse : SDLRPCResponse {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@end
