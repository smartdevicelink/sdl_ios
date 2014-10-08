//  SDLOnButtonEvent.h
//  SyncProxy
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <AppLink/SDLRPCNotification.h>

#import <AppLink/SDLButtonName.h>
#import <AppLink/SDLButtonEventMode.h>

@interface SDLOnButtonEvent : SDLRPCNotification {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) SDLButtonName* buttonName;
@property(strong) SDLButtonEventMode* buttonEventMode;
@property(strong) NSNumber* customButtonID;

@end
