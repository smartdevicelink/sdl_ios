//  SDLOnTouchEvent.h
//  SyncProxy
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCNotification.h>

#import <SmartDeviceLink/SDLTouchType.h>

@interface SDLOnTouchEvent : SDLRPCNotification {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) SDLTouchType* type;
@property(strong) NSMutableArray* event;

@end
