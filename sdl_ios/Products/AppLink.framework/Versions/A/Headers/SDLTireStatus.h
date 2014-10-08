//  SDLTireStatus.h
//  SyncProxy
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <AppLink/SDLRPCMessage.h>

#import <AppLink/SDLWarningLightStatus.h>
#import <AppLink/SDLSingleTireStatus.h>

@interface SDLTireStatus : SDLRPCStruct {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) SDLWarningLightStatus* pressureTelltale;
@property(strong) SDLSingleTireStatus* leftFront;
@property(strong) SDLSingleTireStatus* rightFront;
@property(strong) SDLSingleTireStatus* leftRear;
@property(strong) SDLSingleTireStatus* rightRear;
@property(strong) SDLSingleTireStatus* innerLeftRear;
@property(strong) SDLSingleTireStatus* innerRightRear;

@end
