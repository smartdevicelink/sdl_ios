//  SDLSubscribeVehicleData.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCRequest.h>

@interface SDLSubscribeVehicleData : SDLRPCRequest {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) NSNumber* gps;
@property(strong) NSNumber* speed;
@property(strong) NSNumber* rpm;
@property(strong) NSNumber* fuelLevel;
@property(strong) NSNumber* fuelLevel_State;
@property(strong) NSNumber* instantFuelConsumption;
@property(strong) NSNumber* externalTemperature;
@property(strong) NSNumber* prndl;
@property(strong) NSNumber* tirePressure;
@property(strong) NSNumber* odometer;
@property(strong) NSNumber* beltStatus;
@property(strong) NSNumber* bodyInformation;
@property(strong) NSNumber* deviceStatus;
@property(strong) NSNumber* driverBraking;
@property(strong) NSNumber* wiperStatus;
@property(strong) NSNumber* headLampStatus;
@property(strong) NSNumber* engineTorque;
@property(strong) NSNumber* accPedalPosition;
@property(strong) NSNumber* steeringWheelAngle;
@property(strong) NSNumber* eCallInfo;
@property(strong) NSNumber* airbagStatus;
@property(strong) NSNumber* emergencyEvent;
@property(strong) NSNumber* clusterModeStatus;
@property(strong) NSNumber* myKey;

@end
