//  SDLClusterModeStatus.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.


#import "SDLRPCMessage.h"

#import "SDLPowerModeQualificationStatus.h"
#import "SDLCarModeStatus.h"
#import "SDLPowerModeStatus.h"

@interface SDLClusterModeStatus : SDLRPCStruct {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) NSNumber* powerModeActive;
@property(strong) SDLPowerModeQualificationStatus* powerModeQualificationStatus;
@property(strong) SDLCarModeStatus* carModeStatus;
@property(strong) SDLPowerModeStatus* powerModeStatus;

@end
