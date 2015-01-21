//  SDLAlertResponse.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCResponse.h>

/**
 * SDLAlertResponse is sent, when SDLAlert has been called
 *
 * Since <b>AppLink 1.0</b>
 */
@interface SDLAlertResponse : SDLRPCResponse {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) NSNumber* tryAgainTime;

@end
