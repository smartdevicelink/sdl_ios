//  SDLDeleteSubMenuResponse.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCResponse.h>

/**
 * SDLDeleteSubMenuResponse is sent, when SDLDeleteSubMenu has been called
 *
 * Since <b>AppLink 1.0</b>
 */
@interface SDLDeleteSubMenuResponse : SDLRPCResponse {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@end
