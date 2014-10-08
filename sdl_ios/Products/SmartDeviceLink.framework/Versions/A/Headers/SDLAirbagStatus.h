//  SDLAirbagStatus.h
//  SyncProxy
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCMessage.h>

#import <SmartDeviceLink/SDLVehicleDataEventStatus.h>

@interface SDLAirbagStatus : SDLRPCStruct {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) SDLVehicleDataEventStatus* driverAirbagDeployed;
@property(strong) SDLVehicleDataEventStatus* driverSideAirbagDeployed;
@property(strong) SDLVehicleDataEventStatus* driverCurtainAirbagDeployed;
@property(strong) SDLVehicleDataEventStatus* passengerAirbagDeployed;
@property(strong) SDLVehicleDataEventStatus* passengerCurtainAirbagDeployed;
@property(strong) SDLVehicleDataEventStatus* driverKneeAirbagDeployed;
@property(strong) SDLVehicleDataEventStatus* passengerSideAirbagDeployed;
@property(strong) SDLVehicleDataEventStatus* passengerKneeAirbagDeployed;

@end
