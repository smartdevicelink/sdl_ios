//
//  SDLOnVehicleDataSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SmartDeviceLink.h"
#import "SDLNames.h"


QuickSpecBegin(SDLOnVehicleDataSpec)

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
        SDLOnVehicleData* testNotification = [[SDLOnVehicleData alloc] init];
        
        testNotification.gps = gps;
        testNotification.speed = @70.1;
        testNotification.rpm = @4242;
        testNotification.fuelLevel = @10.3;
        testNotification.fuelLevel_State = SDLComponentVolumeStatusAlert;
        testNotification.instantFuelConsumption = @4000.63;
        testNotification.externalTemperature = @-10;
        testNotification.vin = @"222222222722";
        testNotification.prndl = SDLPRNDLDrive;
        testNotification.tirePressure = tires;
        testNotification.odometer = @100050;
        testNotification.beltStatus = belt;
        testNotification.bodyInformation = body;
        testNotification.deviceStatus = device;
        testNotification.driverBraking = SDLVehicleDataEventStatusYes;
        testNotification.wiperStatus = SDLWiperStatusStalled;
        testNotification.headLampStatus = headLamp;
        testNotification.engineTorque = @-200.124;
        testNotification.accPedalPosition = @99.99999999;
        testNotification.steeringWheelAngle = @0.000000001;
        testNotification.eCallInfo = eCall;
        testNotification.airbagStatus = airbag;
        testNotification.emergencyEvent = event;
        testNotification.clusterModeStatus = clusterMode;
        testNotification.myKey = myKey;
        
        expect(testNotification.gps).to(equal(gps));
        expect(testNotification.speed).to(equal(@70.1));
        expect(testNotification.rpm).to(equal(@4242));
        expect(testNotification.fuelLevel).to(equal(@10.3));
        expect(testNotification.fuelLevel_State).to(equal(SDLComponentVolumeStatusAlert));
        expect(testNotification.instantFuelConsumption).to(equal(@4000.63));
        expect(testNotification.externalTemperature).to(equal(@-10));
        expect(testNotification.vin).to(equal(@"222222222722"));
        expect(testNotification.prndl).to(equal(SDLPRNDLDrive));
        expect(testNotification.tirePressure).to(equal(tires));
        expect(testNotification.odometer).to(equal(@100050));
        expect(testNotification.beltStatus).to(equal(belt));
        expect(testNotification.bodyInformation).to(equal(body));
        expect(testNotification.deviceStatus).to(equal(device));
        expect(testNotification.driverBraking).to(equal(SDLVehicleDataEventStatusYes));
        expect(testNotification.wiperStatus).to(equal(SDLWiperStatusStalled));
        expect(testNotification.headLampStatus).to(equal(headLamp));
        expect(testNotification.engineTorque).to(equal(@-200.124));
        expect(testNotification.accPedalPosition).to(equal(@99.99999999));
        expect(testNotification.steeringWheelAngle).to(equal(@0.000000001));
        expect(testNotification.eCallInfo).to(equal(eCall));
        expect(testNotification.airbagStatus).to(equal(airbag));
        expect(testNotification.emergencyEvent).to(equal(event));
        expect(testNotification.clusterModeStatus).to(equal(clusterMode));
        expect(testNotification.myKey).to(equal(myKey));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{SDLNameNotification:
                                           @{SDLNameParameters:
                                                 @{SDLNameGPS:gps,
                                                   SDLNameSpeed:@70.1,
                                                   SDLNameRPM:@4242,
                                                   SDLNameFuelLevel:@10.3,
                                                   SDLNameFuelLevelState:SDLComponentVolumeStatusAlert,
                                                   SDLNameInstantFuelConsumption:@4000.63,
                                                   SDLNameExternalTemperature:@-10,
                                                   SDLNameVIN:@"222222222722",
                                                   SDLNamePRNDL:SDLPRNDLDrive,
                                                   SDLNameTirePressure:tires,
                                                   SDLNameOdometer:@100050,
                                                   SDLNameBeltStatus:belt,
                                                   SDLNameBodyInformation:body,
                                                   SDLNameDeviceStatus:device,
                                                   SDLNameDriverBraking:SDLVehicleDataEventStatusYes,
                                                   SDLNameWiperStatus:SDLWiperStatusStalled,
                                                   SDLNameHeadLampStatus:headLamp,
                                                   SDLNameEngineTorque:@-200.124,
                                                   SDLNameAccelerationPedalPosition:@99.99999999,
                                                   SDLNameSteeringWheelAngle:@0.000000001,
                                                   SDLNameECallInfo:eCall,
                                                   SDLNameAirbagStatus:airbag,
                                                   SDLNameEmergencyEvent:event,
                                                   SDLNameClusterModeStatus:clusterMode,
                                                   SDLNameMyKey:myKey},
                                             SDLNameOperationName:SDLNameOnVehicleData}} mutableCopy];
        SDLOnVehicleData* testNotification = [[SDLOnVehicleData alloc] initWithDictionary:dict];
        
        expect(testNotification.gps).to(equal(gps));
        expect(testNotification.speed).to(equal(@70.1));
        expect(testNotification.rpm).to(equal(@4242));
        expect(testNotification.fuelLevel).to(equal(@10.3));
        expect(testNotification.fuelLevel_State).to(equal(SDLComponentVolumeStatusAlert));
        expect(testNotification.instantFuelConsumption).to(equal(@4000.63));
        expect(testNotification.externalTemperature).to(equal(@-10));
        expect(testNotification.vin).to(equal(@"222222222722"));
        expect(testNotification.prndl).to(equal(SDLPRNDLDrive));
        expect(testNotification.tirePressure).to(equal(tires));
        expect(testNotification.odometer).to(equal(@100050));
        expect(testNotification.beltStatus).to(equal(belt));
        expect(testNotification.bodyInformation).to(equal(body));
        expect(testNotification.deviceStatus).to(equal(device));
        expect(testNotification.driverBraking).to(equal(SDLVehicleDataEventStatusYes));
        expect(testNotification.wiperStatus).to(equal(SDLWiperStatusStalled));
        expect(testNotification.headLampStatus).to(equal(headLamp));
        expect(testNotification.engineTorque).to(equal(@-200.124));
        expect(testNotification.accPedalPosition).to(equal(@99.99999999));
        expect(testNotification.steeringWheelAngle).to(equal(@0.000000001));
        expect(testNotification.eCallInfo).to(equal(eCall));
        expect(testNotification.airbagStatus).to(equal(airbag));
        expect(testNotification.emergencyEvent).to(equal(event));
        expect(testNotification.clusterModeStatus).to(equal(clusterMode));
        expect(testNotification.myKey).to(equal(myKey));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLOnVehicleData* testNotification = [[SDLOnVehicleData alloc] init];
        
        expect(testNotification.gps).to(beNil());
        expect(testNotification.speed).to(beNil());
        expect(testNotification.rpm).to(beNil());
        expect(testNotification.fuelLevel).to(beNil());
        expect(testNotification.fuelLevel_State).to(beNil());
        expect(testNotification.instantFuelConsumption).to(beNil());
        expect(testNotification.externalTemperature).to(beNil());
        expect(testNotification.vin).to(beNil());
        expect(testNotification.prndl).to(beNil());
        expect(testNotification.tirePressure).to(beNil());
        expect(testNotification.odometer).to(beNil());
        expect(testNotification.beltStatus).to(beNil());
        expect(testNotification.bodyInformation).to(beNil());
        expect(testNotification.deviceStatus).to(beNil());
        expect(testNotification.driverBraking).to(beNil());
        expect(testNotification.wiperStatus).to(beNil());
        expect(testNotification.headLampStatus).to(beNil());
        expect(testNotification.engineTorque).to(beNil());
        expect(testNotification.accPedalPosition).to(beNil());
        expect(testNotification.steeringWheelAngle).to(beNil());
        expect(testNotification.eCallInfo).to(beNil());
        expect(testNotification.airbagStatus).to(beNil());
        expect(testNotification.emergencyEvent).to(beNil());
        expect(testNotification.clusterModeStatus).to(beNil());
        expect(testNotification.myKey).to(beNil());
    });
});

QuickSpecEnd
