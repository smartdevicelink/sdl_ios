//  SDLButtonCapabilities.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCMessage.h>

#import <SmartDeviceLink/SDLButtonName.h>

@interface SDLButtonCapabilities : SDLRPCStruct {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) SDLButtonName* name;
@property(strong) NSNumber* shortPressAvailable;
@property(strong) NSNumber* longPressAvailable;
@property(strong) NSNumber* upDownAvailable;

@end
