//  SDLBodyInformation.h
//  SyncProxy
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <AppLink/SDLRPCMessage.h>

#import <AppLink/SDLIgnitionStableStatus.h>
#import <AppLink/SDLIgnitionStatus.h>

@interface SDLBodyInformation : SDLRPCStruct {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) NSNumber* parkBrakeActive;
@property(strong) SDLIgnitionStableStatus* ignitionStableStatus;
@property(strong) SDLIgnitionStatus* ignitionStatus;
@property(strong) NSNumber* driverDoorAjar;
@property(strong) NSNumber* passengerDoorAjar;
@property(strong) NSNumber* rearLeftDoorAjar;
@property(strong) NSNumber* rearRightDoorAjar;

@end
