//  SDLHeadLampStatus.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.


#import "SDLRPCMessage.h"

#import "SDLAmbientLightStatus.h"

@interface SDLHeadLampStatus : SDLRPCStruct {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) NSNumber* lowBeamsOn;
@property(strong) NSNumber* highBeamsOn;
@property(strong) SDLAmbientLightStatus* ambientLightSensorStatus;

@end
