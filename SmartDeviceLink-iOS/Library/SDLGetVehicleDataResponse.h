//  SDLGetVehicleDataResponse.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.


#import "SDLRPCResponse.h"

#import "SDLGPSData.h"
#import "SDLComponentVolumeStatus.h"
#import "SDLPRNDL.h"
#import "SDLTireStatus.h"
#import "SDLBeltStatus.h"
#import "SDLBodyInformation.h"
#import "SDLDeviceStatus.h"
#import "SDLVehicleDataEventStatus.h"
#import "SDLWiperStatus.h"
#import "SDLHeadLampStatus.h"
#import "SDLECallInfo.h"
#import "SDLAirbagStatus.h"
#import "SDLEmergencyEvent.h"
#import "SDLClusterModeStatus.h"
#import "SDLMyKey.h"

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
