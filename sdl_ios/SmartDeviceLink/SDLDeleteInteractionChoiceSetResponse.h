//  SDLDeleteInteractionChoiceSetResponse.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCResponse.h>

/**
 * SDLDeleteInteractionChoiceSetResponse is sent, when SDLDeleteInteractionChoiceSet has been called
 *
 * Since <b>AppLink 1.0</b>
 */
@interface SDLDeleteInteractionChoiceSetResponse : SDLRPCResponse {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@end
