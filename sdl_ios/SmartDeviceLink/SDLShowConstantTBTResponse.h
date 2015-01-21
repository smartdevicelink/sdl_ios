//  SDLShowConstantTBTResponse.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCResponse.h>

/** SDLShowConstantTBTResponse is sent, when SDLShowConstantTBT has been called.
 * Since<b>AppLink 2.0</b>
 */
@interface SDLShowConstantTBTResponse : SDLRPCResponse {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@end
