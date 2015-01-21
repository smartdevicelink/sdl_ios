//  SDLAddCommandResponse.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCResponse.h>

/**
 * SDLAddCommandResponse is sent, when SDLAddCommand has been called
 *
 * Since <b>AppLink 1.0</b>
 */
@interface SDLAddCommandResponse : SDLRPCResponse {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@end
