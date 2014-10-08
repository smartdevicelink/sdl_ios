//  SDLUnsubscribeVehicleDataResponse.h
//  SyncProxy
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCResponse.h>

#import <SmartDeviceLink/SDLVehicleDataResult.h>

@interface SDLUnsubscribeVehicleDataResponse : SDLRPCResponse {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) SDLVehicleDataResult* gps;
@property(strong) SDLVehicleDataResult* speed;
@property(strong) SDLVehicleDataResult* rpm;
@property(strong) SDLVehicleDataResult* fuelLevel;
@property(strong) SDLVehicleDataResult* fuelLevel_State;
@property(strong) SDLVehicleDataResult* instantFuelConsumption;
@property(strong) SDLVehicleDataResult* externalTemperature;
@property(strong) SDLVehicleDataResult* prndl;
@property(strong) SDLVehicleDataResult* tirePressure;
@property(strong) SDLVehicleDataResult* odometer;
@property(strong) SDLVehicleDataResult* beltStatus;
@property(strong) SDLVehicleDataResult* bodyInformation;
@property(strong) SDLVehicleDataResult* deviceStatus;
@property(strong) SDLVehicleDataResult* driverBraking;
@property(strong) SDLVehicleDataResult* wiperStatus;
@property(strong) SDLVehicleDataResult* headLampStatus;
@property(strong) SDLVehicleDataResult* engineTorque;
@property(strong) SDLVehicleDataResult* accPedalPosition;
@property(strong) SDLVehicleDataResult* steeringWheelAngle;
@property(strong) SDLVehicleDataResult* eCallInfo;
@property(strong) SDLVehicleDataResult* airbagStatus;
@property(strong) SDLVehicleDataResult* emergencyEvent;
@property(strong) SDLVehicleDataResult* clusterModes;
@property(strong) SDLVehicleDataResult* myKey;

@end
