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
SDLFuelRange* fuelRange = [[SDLFuelRange alloc] init];

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLOnVehicleData* testNotification = [[SDLOnVehicleData alloc] init];

        testNotification.accPedalPosition = @99.99999999;
        testNotification.airbagStatus = airbag;
        testNotification.beltStatus = belt;
        testNotification.bodyInformation = body;
        testNotification.clusterModeStatus = clusterMode;
        testNotification.deviceStatus = device;
        testNotification.driverBraking = SDLVehicleDataEventStatusYes;
        testNotification.eCallInfo = eCall;
        testNotification.electronicParkBrakeStatus = SDLElectronicParkBrakeStatusDriveActive;
        testNotification.emergencyEvent = event;
        testNotification.engineOilLife = @34.45;
        testNotification.engineTorque = @-200.124;
        testNotification.externalTemperature = @-10;
        testNotification.fuelLevel = @10.3;
        testNotification.fuelLevel_State = SDLComponentVolumeStatusAlert;
        testNotification.fuelRange = @[fuelRange, fuelRange];
        testNotification.gps = gps;
        testNotification.headLampStatus = headLamp;
        testNotification.instantFuelConsumption = @4000.63;
        testNotification.myKey = myKey;
        testNotification.odometer = @100050;
        testNotification.prndl = SDLPRNDLDrive;
        testNotification.rpm = @4242;
        testNotification.speed = @70.1;
        testNotification.steeringWheelAngle = @0.000000001;
        testNotification.tirePressure = tires;
        testNotification.turnSignal = SDLTurnSignalRight;
        testNotification.vin = @"222222222722";
        testNotification.wiperStatus = SDLWiperStatusStalled;

        expect(testNotification.accPedalPosition).to(equal(@99.99999999));
        expect(testNotification.airbagStatus).to(equal(airbag));
        expect(testNotification.beltStatus).to(equal(belt));
        expect(testNotification.bodyInformation).to(equal(body));
        expect(testNotification.clusterModeStatus).to(equal(clusterMode));
        expect(testNotification.deviceStatus).to(equal(device));
        expect(testNotification.driverBraking).to(equal(SDLVehicleDataEventStatusYes));
        expect(testNotification.eCallInfo).to(equal(eCall));
        expect(testNotification.electronicParkBrakeStatus).to(equal(SDLElectronicParkBrakeStatusDriveActive));
        expect(testNotification.emergencyEvent).to(equal(event));
        expect(testNotification.engineOilLife).to(equal(@34.45));
        expect(testNotification.engineTorque).to(equal(@-200.124));
        expect(testNotification.externalTemperature).to(equal(@-10));
        expect(testNotification.fuelLevel).to(equal(@10.3));
        expect(testNotification.fuelLevel_State).to(equal(SDLComponentVolumeStatusAlert));
        expect(testNotification.fuelRange).to(equal(@[fuelRange, fuelRange]));
        expect(testNotification.gps).to(equal(gps));
        expect(testNotification.headLampStatus).to(equal(headLamp));
        expect(testNotification.instantFuelConsumption).to(equal(@4000.63));
        expect(testNotification.myKey).to(equal(myKey));
        expect(testNotification.odometer).to(equal(@100050));
        expect(testNotification.prndl).to(equal(SDLPRNDLDrive));
        expect(testNotification.rpm).to(equal(@4242));
        expect(testNotification.speed).to(equal(@70.1));
        expect(testNotification.steeringWheelAngle).to(equal(@0.000000001));
        expect(testNotification.tirePressure).to(equal(tires));
        expect(testNotification.turnSignal).to(equal(SDLTurnSignalRight));
        expect(testNotification.vin).to(equal(@"222222222722"));
        expect(testNotification.wiperStatus).to(equal(SDLWiperStatusStalled));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSDictionary* dict = @{SDLNameNotification:
                                   @{SDLNameParameters:
                                         @{SDLNameAccelerationPedalPosition:@99.99999999,
                                           SDLNameAirbagStatus:airbag,
                                           SDLNameBeltStatus:belt,
                                           SDLNameBodyInformation:body,
                                           SDLNameClusterModeStatus:clusterMode,
                                           SDLNameDeviceStatus:device,
                                           SDLNameDriverBraking:SDLVehicleDataEventStatusYes,
                                           SDLNameECallInfo:eCall,
                                           SDLNameElectronicParkBrakeStatus:SDLElectronicParkBrakeStatusDriveActive,
                                           SDLNameEmergencyEvent:event,
                                           SDLNameEngineOilLife:@45.1,
                                           SDLNameEngineTorque:@-200.124,
                                           SDLNameExternalTemperature:@-10,
                                           SDLNameFuelLevel:@10.3,
                                           SDLNameFuelLevelState:SDLComponentVolumeStatusAlert,
                                           SDLNameFuelRange:@[fuelRange],
                                           SDLNameGPS:gps,
                                           SDLNameHeadLampStatus:headLamp,
                                           SDLNameInstantFuelConsumption:@4000.63,
                                           SDLNameMyKey:myKey,
                                           SDLNameOdometer:@100050,
                                           SDLNamePRNDL:SDLPRNDLDrive,
                                           SDLNameRPM:@4242,
                                           SDLNameSpeed:@70.1,
                                           SDLNameSteeringWheelAngle:@0.000000001,
                                           SDLNameTirePressure:tires,
                                           SDLNameTurnSignal:SDLTurnSignalOff,
                                           SDLNameVIN:@"222222222722",
                                           SDLNameWiperStatus:SDLWiperStatusStalled},
                                     SDLNameOperationName:SDLNameOnVehicleData}};
        SDLOnVehicleData* testNotification = [[SDLOnVehicleData alloc] initWithDictionary:dict];
        
        expect(testNotification.accPedalPosition).to(equal(@99.99999999));
        expect(testNotification.airbagStatus).to(equal(airbag));
        expect(testNotification.beltStatus).to(equal(belt));
        expect(testNotification.bodyInformation).to(equal(body));
        expect(testNotification.clusterModeStatus).to(equal(clusterMode));
        expect(testNotification.deviceStatus).to(equal(device));
        expect(testNotification.driverBraking).to(equal(SDLVehicleDataEventStatusYes));
        expect(testNotification.eCallInfo).to(equal(eCall));
        expect(testNotification.electronicParkBrakeStatus).to(equal(SDLElectronicParkBrakeStatusDriveActive));
        expect(testNotification.emergencyEvent).to(equal(event));
        expect(testNotification.engineOilLife).to(equal(@45.1));
        expect(testNotification.engineTorque).to(equal(@-200.124));
        expect(testNotification.externalTemperature).to(equal(@-10));
        expect(testNotification.fuelLevel).to(equal(@10.3));
        expect(testNotification.fuelLevel_State).to(equal(SDLComponentVolumeStatusAlert));
        expect(testNotification.fuelRange).to(equal(@[fuelRange]));
        expect(testNotification.gps).to(equal(gps));
        expect(testNotification.headLampStatus).to(equal(headLamp));
        expect(testNotification.instantFuelConsumption).to(equal(@4000.63));
        expect(testNotification.myKey).to(equal(myKey));
        expect(testNotification.odometer).to(equal(@100050));
        expect(testNotification.prndl).to(equal(SDLPRNDLDrive));
        expect(testNotification.rpm).to(equal(@4242));
        expect(testNotification.speed).to(equal(@70.1));
        expect(testNotification.steeringWheelAngle).to(equal(@0.000000001));
        expect(testNotification.tirePressure).to(equal(tires));
        expect(testNotification.turnSignal).to(equal(SDLTurnSignalOff));
        expect(testNotification.vin).to(equal(@"222222222722"));
        expect(testNotification.wiperStatus).to(equal(SDLWiperStatusStalled));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLOnVehicleData* testNotification = [[SDLOnVehicleData alloc] init];
        
        expect(testNotification.accPedalPosition).to(beNil());
        expect(testNotification.airbagStatus).to(beNil());
        expect(testNotification.beltStatus).to(beNil());
        expect(testNotification.bodyInformation).to(beNil());
        expect(testNotification.clusterModeStatus).to(beNil());
        expect(testNotification.deviceStatus).to(beNil());
        expect(testNotification.driverBraking).to(beNil());
        expect(testNotification.eCallInfo).to(beNil());
        expect(testNotification.electronicParkBrakeStatus).to(beNil());
        expect(testNotification.emergencyEvent).to(beNil());
        expect(testNotification.engineOilLife).to(beNil());
        expect(testNotification.engineTorque).to(beNil());
        expect(testNotification.externalTemperature).to(beNil());
        expect(testNotification.fuelLevel).to(beNil());
        expect(testNotification.fuelLevel_State).to(beNil());
        expect(testNotification.fuelRange).to(beNil());
        expect(testNotification.gps).to(beNil());
        expect(testNotification.headLampStatus).to(beNil());
        expect(testNotification.instantFuelConsumption).to(beNil());
        expect(testNotification.myKey).to(beNil());
        expect(testNotification.odometer).to(beNil());
        expect(testNotification.prndl).to(beNil());
        expect(testNotification.rpm).to(beNil());
        expect(testNotification.speed).to(beNil());
        expect(testNotification.steeringWheelAngle).to(beNil());
        expect(testNotification.tirePressure).to(beNil());
        expect(testNotification.turnSignal).to(beNil());
        expect(testNotification.vin).to(beNil());
        expect(testNotification.wiperStatus).to(beNil());
    });
});

QuickSpecEnd
