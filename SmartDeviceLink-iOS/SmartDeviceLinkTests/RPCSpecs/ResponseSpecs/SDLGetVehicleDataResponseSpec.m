//
//  SDLGetVehicleDataResponseSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SmartDeviceLink.h"
#import "SDLNames.h"


QuickSpecBegin(SDLGetVehicleDataResponseSpec)

SDLGPSData* gps = [[SDLGPSData alloc] init];
SDLTireStatus* tires = [[SDLTireStatus alloc] init];
SDLBeltStatus* belt = [[SDLBeltStatus alloc] init];
SDLBodyInformation* body = [[SDLBodyInformation alloc] init];
SDLDeviceStatus* device = [[SDLDeviceStatus alloc] init];
SDLHeadLampStatus* headLamp = [[SDLHeadLampStatus alloc] init];
SDLECallInfo* eCall = [[SDLECallInfo alloc] init];
SDLAirbagStatus* airbag = [[SDLAirbagStatus alloc] init];
SDLEmergencyEvent* event = [[SDLEmergencyEvent alloc] init];
SDLClusterModeStatus* clusterMode = [[SDLClusterModeStatus alloc] init];
SDLMyKey* myKey = [[SDLMyKey alloc] init];

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLGetVehicleDataResponse* testResponse = [[SDLGetVehicleDataResponse alloc] init];
        
        testResponse.gps = gps;
        testResponse.speed = @100;
        testResponse.rpm = @3;
        testResponse.fuelLevel = @99.9999;
        testResponse.fuelLevel_State = [SDLComponentVolumeStatus FAULT];
        testResponse.instantFuelConsumption = @40.7;
        testResponse.externalTemperature = @0;
        testResponse.vin = @"6574839201";
        testResponse.prndl = [SDLPRNDL PARK];
        testResponse.tirePressure = tires;
        testResponse.odometer = @70000;
        testResponse.beltStatus = belt;
        testResponse.bodyInformation = body;
        testResponse.deviceStatus = device;
        testResponse.driverBraking = [SDLVehicleDataEventStatus NO_EVENT];
        testResponse.wiperStatus = [SDLWiperStatus AUTO_HIGH];
        testResponse.headLampStatus = headLamp;
        testResponse.engineTorque = @630.4;
        testResponse.accPedalPosition = @0;
        testResponse.steeringWheelAngle = @-1500;
        testResponse.eCallInfo = eCall;
        testResponse.airbagStatus = airbag;
        testResponse.emergencyEvent = event;
        testResponse.clusterModeStatus = clusterMode;
        testResponse.myKey = myKey;
        
        expect(testResponse.gps).to(equal(gps));
        expect(testResponse.speed).to(equal(@100));
        expect(testResponse.rpm).to(equal(@3));
        expect(testResponse.fuelLevel).to(equal(@99.9999));
        expect(testResponse.fuelLevel_State).to(equal([SDLComponentVolumeStatus FAULT]));
        expect(testResponse.instantFuelConsumption).to(equal(@40.7));
        expect(testResponse.externalTemperature).to(equal(@0));
        expect(testResponse.vin).to(equal(@"6574839201"));
        expect(testResponse.prndl).to(equal([SDLPRNDL PARK]));
        expect(testResponse.tirePressure).to(equal(tires));
        expect(testResponse.odometer).to(equal(@70000));
        expect(testResponse.beltStatus).to(equal(belt));
        expect(testResponse.bodyInformation).to(equal(body));
        expect(testResponse.deviceStatus).to(equal(device));
        expect(testResponse.driverBraking).to(equal([SDLVehicleDataEventStatus NO_EVENT]));
        expect(testResponse.wiperStatus).to(equal([SDLWiperStatus AUTO_HIGH]));
        expect(testResponse.headLampStatus).to(equal(headLamp));
        expect(testResponse.engineTorque).to(equal(@630.4));
        expect(testResponse.accPedalPosition).to(equal(@0));
        expect(testResponse.steeringWheelAngle).to(equal(@-1500));
        expect(testResponse.eCallInfo).to(equal(eCall));
        expect(testResponse.airbagStatus).to(equal(airbag));
        expect(testResponse.emergencyEvent).to(equal(event));
        expect(testResponse.clusterModeStatus).to(equal(clusterMode));
        expect(testResponse.myKey).to(equal(myKey));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{NAMES_notification:
                                           @{NAMES_parameters:
                                                 @{NAMES_gps:gps,
                                                   NAMES_speed:@100,
                                                   NAMES_rpm:@3,
                                                   NAMES_fuelLevel:@99.9999,
                                                   NAMES_fuelLevel_State:[SDLComponentVolumeStatus FAULT],
                                                   NAMES_instantFuelConsumption:@40.7,
                                                   NAMES_externalTemperature:@0,
                                                   NAMES_vin:@"6574839201",
                                                   NAMES_prndl:[SDLPRNDL PARK],
                                                   NAMES_tirePressure:tires,
                                                   NAMES_odometer:@70000,
                                                   NAMES_beltStatus:belt,
                                                   NAMES_bodyInformation:body,
                                                   NAMES_deviceStatus:device,
                                                   NAMES_driverBraking:[SDLVehicleDataEventStatus NO_EVENT],
                                                   NAMES_wiperStatus:[SDLWiperStatus AUTO_HIGH],
                                                   NAMES_headLampStatus:headLamp,
                                                   NAMES_engineTorque:@630.4,
                                                   NAMES_accPedalPosition:@0,
                                                   NAMES_steeringWheelAngle:@-1500,
                                                   NAMES_eCallInfo:eCall,
                                                   NAMES_airbagStatus:airbag,
                                                   NAMES_emergencyEvent:event,
                                                   NAMES_clusterModeStatus:clusterMode,
                                                   NAMES_myKey:myKey},
                                             NAMES_operation_name:NAMES_GetVehicleData}} mutableCopy];
        SDLGetVehicleDataResponse* testResponse = [[SDLGetVehicleDataResponse alloc] initWithDictionary:dict];
        
        expect(testResponse.gps).to(equal(gps));
        expect(testResponse.speed).to(equal(@100));
        expect(testResponse.rpm).to(equal(@3));
        expect(testResponse.fuelLevel).to(equal(@99.9999));
        expect(testResponse.fuelLevel_State).to(equal([SDLComponentVolumeStatus FAULT]));
        expect(testResponse.instantFuelConsumption).to(equal(@40.7));
        expect(testResponse.externalTemperature).to(equal(@0));
        expect(testResponse.vin).to(equal(@"6574839201"));
        expect(testResponse.prndl).to(equal([SDLPRNDL PARK]));
        expect(testResponse.tirePressure).to(equal(tires));
        expect(testResponse.odometer).to(equal(@70000));
        expect(testResponse.beltStatus).to(equal(belt));
        expect(testResponse.bodyInformation).to(equal(body));
        expect(testResponse.deviceStatus).to(equal(device));
        expect(testResponse.driverBraking).to(equal([SDLVehicleDataEventStatus NO_EVENT]));
        expect(testResponse.wiperStatus).to(equal([SDLWiperStatus AUTO_HIGH]));
        expect(testResponse.headLampStatus).to(equal(headLamp));
        expect(testResponse.engineTorque).to(equal(@630.4));
        expect(testResponse.accPedalPosition).to(equal(@0));
        expect(testResponse.steeringWheelAngle).to(equal(@-1500));
        expect(testResponse.eCallInfo).to(equal(eCall));
        expect(testResponse.airbagStatus).to(equal(airbag));
        expect(testResponse.emergencyEvent).to(equal(event));
        expect(testResponse.clusterModeStatus).to(equal(clusterMode));
        expect(testResponse.myKey).to(equal(myKey));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLGetVehicleDataResponse* testResponse = [[SDLGetVehicleDataResponse alloc] init];
        
        expect(testResponse.gps).to(beNil());
        expect(testResponse.speed).to(beNil());
        expect(testResponse.rpm).to(beNil());
        expect(testResponse.fuelLevel).to(beNil());
        expect(testResponse.fuelLevel_State).to(beNil());
        expect(testResponse.instantFuelConsumption).to(beNil());
        expect(testResponse.externalTemperature).to(beNil());
        expect(testResponse.vin).to(beNil());
        expect(testResponse.prndl).to(beNil());
        expect(testResponse.tirePressure).to(beNil());
        expect(testResponse.odometer).to(beNil());
        expect(testResponse.beltStatus).to(beNil());
        expect(testResponse.bodyInformation).to(beNil());
        expect(testResponse.deviceStatus).to(beNil());
        expect(testResponse.driverBraking).to(beNil());
        expect(testResponse.wiperStatus).to(beNil());
        expect(testResponse.headLampStatus).to(beNil());
        expect(testResponse.engineTorque).to(beNil());
        expect(testResponse.accPedalPosition).to(beNil());
        expect(testResponse.steeringWheelAngle).to(beNil());
        expect(testResponse.eCallInfo).to(beNil());
        expect(testResponse.airbagStatus).to(beNil());
        expect(testResponse.emergencyEvent).to(beNil());
        expect(testResponse.clusterModeStatus).to(beNil());
        expect(testResponse.myKey).to(beNil());
    });
});

QuickSpecEnd