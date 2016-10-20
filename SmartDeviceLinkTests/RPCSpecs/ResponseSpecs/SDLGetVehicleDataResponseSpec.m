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
        testResponse.fuelLevel_State = SDLComponentVolumeStatusFault;
        testResponse.instantFuelConsumption = @40.7;
        testResponse.externalTemperature = @0;
        testResponse.vin = @"6574839201";
        testResponse.prndl = SDLPRNDLPark;
        testResponse.tirePressure = tires;
        testResponse.odometer = @70000;
        testResponse.beltStatus = belt;
        testResponse.bodyInformation = body;
        testResponse.deviceStatus = device;
        testResponse.driverBraking = SDLVehicleDataEventStatusNoEvent;
        testResponse.wiperStatus = SDLWiperStatusAutomaticHigh;
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
        expect(testResponse.fuelLevel_State).to(equal(SDLComponentVolumeStatusFault));
        expect(testResponse.instantFuelConsumption).to(equal(@40.7));
        expect(testResponse.externalTemperature).to(equal(@0));
        expect(testResponse.vin).to(equal(@"6574839201"));
        expect(testResponse.prndl).to(equal(SDLPRNDLPark));
        expect(testResponse.tirePressure).to(equal(tires));
        expect(testResponse.odometer).to(equal(@70000));
        expect(testResponse.beltStatus).to(equal(belt));
        expect(testResponse.bodyInformation).to(equal(body));
        expect(testResponse.deviceStatus).to(equal(device));
        expect(testResponse.driverBraking).to(equal(SDLVehicleDataEventStatusNoEvent));
        expect(testResponse.wiperStatus).to(equal(SDLWiperStatusAutomaticHigh));
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
        NSMutableDictionary* dict = [@{SDLNameNotification:
                                           @{SDLNameParameters:
                                                 @{SDLNameGPS:gps,
                                                   SDLNameSpeed:@100,
                                                   SDLNameRPM:@3,
                                                   SDLNameFuelLevel:@99.9999,
                                                   SDLNameFuelLevelState:SDLComponentVolumeStatusFault,
                                                   SDLNameInstantFuelConsumption:@40.7,
                                                   SDLNameExternalTemperature:@0,
                                                   SDLNameVIN:@"6574839201",
                                                   SDLNamePRNDL:SDLPRNDLPark,
                                                   SDLNameTirePressure:tires,
                                                   SDLNameOdometer:@70000,
                                                   SDLNameBeltStatus:belt,
                                                   SDLNameBodyInformation:body,
                                                   SDLNameDeviceStatus:device,
                                                   SDLNameDriverBraking:SDLVehicleDataEventStatusNoEvent,
                                                   SDLNameWiperStatus:SDLWiperStatusAutomaticHigh,
                                                   SDLNameHeadLampStatus:headLamp,
                                                   SDLNameEngineTorque:@630.4,
                                                   SDLNameAccelerationPedalPosition:@0,
                                                   SDLNameSteeringWheelAngle:@-1500,
                                                   SDLNameECallInfo:eCall,
                                                   SDLNameAirbagStatus:airbag,
                                                   SDLNameEmergencyEvent:event,
                                                   SDLNameClusterModeStatus:clusterMode,
                                                   SDLNameMyKey:myKey},
                                             SDLNameOperationName:SDLNameGetVehicleData}} mutableCopy];
        SDLGetVehicleDataResponse* testResponse = [[SDLGetVehicleDataResponse alloc] initWithDictionary:dict];
        
        expect(testResponse.gps).to(equal(gps));
        expect(testResponse.speed).to(equal(@100));
        expect(testResponse.rpm).to(equal(@3));
        expect(testResponse.fuelLevel).to(equal(@99.9999));
        expect(testResponse.fuelLevel_State).to(equal(SDLComponentVolumeStatusFault));
        expect(testResponse.instantFuelConsumption).to(equal(@40.7));
        expect(testResponse.externalTemperature).to(equal(@0));
        expect(testResponse.vin).to(equal(@"6574839201"));
        expect(testResponse.prndl).to(equal(SDLPRNDLPark));
        expect(testResponse.tirePressure).to(equal(tires));
        expect(testResponse.odometer).to(equal(@70000));
        expect(testResponse.beltStatus).to(equal(belt));
        expect(testResponse.bodyInformation).to(equal(body));
        expect(testResponse.deviceStatus).to(equal(device));
        expect(testResponse.driverBraking).to(equal(SDLVehicleDataEventStatusNoEvent));
        expect(testResponse.wiperStatus).to(equal(SDLWiperStatusAutomaticHigh));
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
