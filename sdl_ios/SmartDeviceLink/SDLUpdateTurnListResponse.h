//  SDLUpdateTurnListResponse.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCResponse.h>

/** SDLUpdateTurnListResponse is sent, when SDLUpdateTurnList has been called.
 * Since<b>AppLink 2.0</b>
 */
@interface SDLUpdateTurnListResponse : SDLRPCResponse {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@end
