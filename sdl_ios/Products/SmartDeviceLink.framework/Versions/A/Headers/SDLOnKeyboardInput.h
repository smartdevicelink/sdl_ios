//  SDLOnKeyboardInput.h
//  SyncProxy
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCNotification.h>

#import <SmartDeviceLink/SDLKeyboardEvent.h>

@interface SDLOnKeyboardInput : SDLRPCNotification {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) SDLKeyboardEvent* event;
@property(strong) NSString* data;

@end
