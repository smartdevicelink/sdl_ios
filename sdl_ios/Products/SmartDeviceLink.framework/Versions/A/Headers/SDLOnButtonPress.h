//  SDLOnButtonPress.h
//  SyncProxy
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCNotification.h>

#import <SmartDeviceLink/SDLButtonName.h>
#import <SmartDeviceLink/SDLButtonPressMode.h>

@interface SDLOnButtonPress : SDLRPCNotification {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) SDLButtonName* buttonName;
@property(strong) SDLButtonPressMode* buttonPressMode;
@property(strong) NSNumber* customButtonID;

@end
