//  SDLHeadLampStatus.h
//  SyncProxy
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <AppLink/SDLRPCMessage.h>

#import <AppLink/SDLAmbientLightStatus.h>

@interface SDLHeadLampStatus : SDLRPCStruct {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) NSNumber* lowBeamsOn;
@property(strong) NSNumber* highBeamsOn;
@property(strong) SDLAmbientLightStatus* ambientLightSensorStatus;

@end
