//  SDLEmergencyEvent.h
//  SyncProxy
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <AppLink/SDLRPCMessage.h>

#import <AppLink/SDLEmergencyEventType.h>
#import <AppLink/SDLFuelCutoffStatus.h>
#import <AppLink/SDLVehicleDataEventStatus.h>

@interface SDLEmergencyEvent : SDLRPCStruct {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) SDLEmergencyEventType* emergencyEventType;
@property(strong) SDLFuelCutoffStatus* fuelCutoffStatus;
@property(strong) SDLVehicleDataEventStatus* rolloverEvent;
@property(strong) NSNumber* maximumChangeVelocity;
@property(strong) SDLVehicleDataEventStatus* multipleEvents;

@end
