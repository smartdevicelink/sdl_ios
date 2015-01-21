//  SDLSetAppIconResponse.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCResponse.h>

/** SDLSetAppIconResponse is sent, when SDLSetAppIcon has been called.
 * Since<b>AppLink 2.0</b>
 */
@interface SDLSetAppIconResponse : SDLRPCResponse {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@end
