//  SDLCreateInteractionChoiceSetResponse.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCResponse.h>

/**
 * SDLCreateInteractionChoiceSetResponse is sent, when SDLCreateInteractionChoiceSet
 * has been called
 *
 * Since <b>AppLink 1.0</b>
 */
@interface SDLCreateInteractionChoiceSetResponse : SDLRPCResponse {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@end
