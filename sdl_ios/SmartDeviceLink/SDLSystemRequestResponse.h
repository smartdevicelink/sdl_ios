//  SDLSystemRequestResponse.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCResponse.h>

/** SDLSystemRequestResponse is sent, when SDLSystemRequest has been called.
 * Since<b>AppLink 3.0</b>
 */
@interface SDLSystemRequestResponse : SDLRPCResponse {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@end
