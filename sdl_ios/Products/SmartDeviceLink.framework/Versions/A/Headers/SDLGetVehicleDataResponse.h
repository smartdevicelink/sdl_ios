//  SDLGetVehicleDataResponse.h
//  SyncProxy
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCResponse.h>

#import <SmartDeviceLink/SDLGPSData.h>
#import <SmartDeviceLink/SDLComponentVolumeStatus.h>
#import <SmartDeviceLink/SDLPRNDL.h>
#import <SmartDeviceLink/SDLTireStatus.h>
#import <SmartDeviceLink/SDLBeltStatus.h>
#import <SmartDeviceLink/SDLBodyInformation.h>
#import <SmartDeviceLink/SDLDeviceStatus.h>
#import <SmartDeviceLink/SDLVehicleDataEventStatus.h>
#import <SmartDeviceLink/SDLWiperStatus.h>
#import <SmartDeviceLink/SDLHeadLampStatus.h>
#import <SmartDeviceLink/SDLECallInfo.h>
#import <SmartDeviceLink/SDLAirbagStatus.h>
#import <SmartDeviceLink/SDLEmergencyEvent.h>
#import <SmartDeviceLink/SDLClusterModeStatus.h>
#import <SmartDeviceLink/SDLMyKey.h>

@interface SDLGetVehicleDataResponse : SDLRPCResponse {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) SDLGPSData* gps;
@property(strong) NSNumber* speed;
@property(strong) NSNumber* rpm;
@property(strong) NSNumber* fuelLevel;
@property(strong) SDLComponentVolumeStatus* fuelLevel_State;
@property(strong) NSNumber* instantFuelConsumption;
@property(strong) NSNumber* externalTemperature;
@property(strong) NSString* vin;
@property(strong) SDLPRNDL* prndl;
@property(strong) SDLTireStatus* tirePressure;
@property(strong) NSNumber* odometer;
@property(strong) SDLBeltStatus* beltStatus;
@property(strong) SDLBodyInformation* bodyInformation;
@property(strong) SDLDeviceStatus* deviceStatus;
@property(strong) SDLVehicleDataEventStatus* driverBraking;
@property(strong) SDLWiperStatus* wiperStatus;
@property(strong) SDLHeadLampStatus* headLampStatus;
@property(strong) NSNumber* engineTorque;
@property(strong) NSNumber* accPedalPosition;
@property(strong) NSNumber* steeringWheelAngle;
@property(strong) SDLECallInfo* eCallInfo;
@property(strong) SDLAirbagStatus* airbagStatus;
@property(strong) SDLEmergencyEvent* emergencyEvent;
@property(strong) SDLClusterModeStatus* clusterModeStatus;
@property(strong) SDLMyKey* myKey;

@end
