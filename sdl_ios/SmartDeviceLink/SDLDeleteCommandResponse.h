//  SDLDeleteCommandResponse.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCResponse.h>

/**
 * SDLDeleteCommandResponse is sent, when SDLDeleteCommand has been called
 *
 * Since <b>AppLink 1.0</b><br>
 */
@interface SDLDeleteCommandResponse : SDLRPCResponse {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@end
