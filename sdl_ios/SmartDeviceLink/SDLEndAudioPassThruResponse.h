//  SDLEndAudioPassThruResponse.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCResponse.h>

/**
 * SDLEndAudioPassThruResponse is sent, when SDLEndAudioPassThru has been called
 *
 * Since <b>AppLink 2.0</b>
 */
@interface SDLEndAudioPassThruResponse : SDLRPCResponse {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@end
