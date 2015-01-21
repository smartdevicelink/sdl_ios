//  SDLGenericResponse.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCResponse.h>

/**
 * Generic Response is sent, when the name of a received msg cannot be
 * retrieved. Only used in case of an error. Currently, only resultCode
 * INVALID_DATA is used.
 */
@interface SDLGenericResponse : SDLRPCResponse {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@end
