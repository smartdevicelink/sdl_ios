//  SDLClusterModeStatus.h
//  SyncProxy
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <AppLink/SDLRPCMessage.h>

#import <AppLink/SDLPowerModeQualificationStatus.h>
#import <AppLink/SDLCarModeStatus.h>
#import <AppLink/SDLPowerModeStatus.h>

@interface SDLClusterModeStatus : SDLRPCStruct {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) NSNumber* powerModeActive;
@property(strong) SDLPowerModeQualificationStatus* powerModeQualificationStatus;
@property(strong) SDLCarModeStatus* carModeStatus;
@property(strong) SDLPowerModeStatus* powerModeStatus;

@end
