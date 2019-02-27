//
//  SDLGetVehicleDataResponseSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SmartDeviceLink.h"
#import "SDLNames.h"


QuickSpecBegin(SDLGetVehicleDataResponseSpec)

describe(@"Getter/Setter Tests", ^ {
    __block SDLGPSData* gps = [[SDLGPSData alloc] init];
    __block SDLTireStatus* tires = [[SDLTireStatus alloc] init];
    __block SDLBeltStatus* belt = [[SDLBeltStatus alloc] init];
    __block SDLBodyInformation* body = [[SDLBodyInformation alloc] init];
    __block SDLDeviceStatus* device = [[SDLDeviceStatus alloc] init];
    __block SDLHeadLampStatus* headLamp = [[SDLHeadLampStatus alloc] init];
    __block SDLECallInfo* eCall = [[SDLECallInfo alloc] init];
    __block SDLAirbagStatus* airbag = [[SDLAirbagStatus alloc] init];
    __block SDLEmergencyEvent* event = [[SDLEmergencyEvent alloc] init];
    __block SDLClusterModeStatus* clusterMode = [[SDLClusterModeStatus alloc] init];
    __block SDLMyKey* myKey = [[SDLMyKey alloc] init];
    __block SDLFuelRange* fuelRange = [[SDLFuelRange alloc] init];
    __block NSString* vin = @"6574839201a";
    __block NSString* cloudAppVehicleID = @"cloudAppVehicleID";

    it(@"Should set and get correctly", ^ {
        SDLGetVehicleDataResponse* testResponse = [[SDLGetVehicleDataResponse alloc] init];

        testResponse.accPedalPosition = @0;
        testResponse.airbagStatus = airbag;
        testResponse.beltStatus = belt;
        testResponse.bodyInformation = body;
        testResponse.cloudAppVehicleID = cloudAppVehicleID;
        testResponse.clusterModeStatus = clusterMode;
        testResponse.deviceStatus = device;
        testResponse.driverBraking = SDLVehicleDataEventStatusNoEvent;
        testResponse.eCallInfo = eCall;
        testResponse.electronicParkBrakeStatus = SDLElectronicParkBrakeStatusDriveActive;
        testResponse.emergencyEvent = event;
        testResponse.engineOilLife = @56.3;
        testResponse.engineTorque = @630.4;
        testResponse.externalTemperature = @0;
        testResponse.fuelLevel = @99.9999;
        testResponse.fuelLevel_State = SDLComponentVolumeStatusFault;
        testResponse.fuelRange = @[fuelRange, fuelRange];
        testResponse.gps = gps;
        testResponse.headLampStatus = headLamp;
        testResponse.instantFuelConsumption = @40.7;
        testResponse.myKey = myKey;
        testResponse.odometer = @70000;
        testResponse.prndl = SDLPRNDLPark;
        testResponse.rpm = @3;
        testResponse.speed = @100;
        testResponse.steeringWheelAngle = @-1500;
        testResponse.tirePressure = tires;
        testResponse.turnSignal = SDLTurnSignalBoth;
        testResponse.vin = vin;
        testResponse.wiperStatus = SDLWiperStatusAutomaticHigh;

        expect(testResponse.accPedalPosition).to(equal(@0));
        expect(testResponse.airbagStatus).to(equal(airbag));
        expect(testResponse.beltStatus).to(equal(belt));
        expect(testResponse.bodyInformation).to(equal(body));
        expect(testResponse.cloudAppVehicleID).to(equal(cloudAppVehicleID));
        expect(testResponse.clusterModeStatus).to(equal(clusterMode));
        expect(testResponse.deviceStatus).to(equal(device));
        expect(testResponse.driverBraking).to(equal(SDLVehicleDataEventStatusNoEvent));
        expect(testResponse.eCallInfo).to(equal(eCall));
        expect(testResponse.electronicParkBrakeStatus).to(equal(SDLElectronicParkBrakeStatusDriveActive));
        expect(testResponse.emergencyEvent).to(equal(event));
        expect(testResponse.engineOilLife).to(equal(@56.3));
        expect(testResponse.engineTorque).to(equal(@630.4));
        expect(testResponse.externalTemperature).to(equal(@0));
        expect(testResponse.fuelLevel).to(equal(@99.9999));
        expect(testResponse.fuelLevel_State).to(equal(SDLComponentVolumeStatusFault));
        expect(testResponse.fuelRange).to(equal(@[fuelRange, fuelRange]));
        expect(testResponse.gps).to(equal(gps));
        expect(testResponse.headLampStatus).to(equal(headLamp));
        expect(testResponse.instantFuelConsumption).to(equal(@40.7));
        expect(testResponse.myKey).to(equal(myKey));
        expect(testResponse.odometer).to(equal(@70000));
        expect(testResponse.prndl).to(equal(SDLPRNDLPark));
        expect(testResponse.rpm).to(equal(@3));
        expect(testResponse.speed).to(equal(@100));
        expect(testResponse.steeringWheelAngle).to(equal(@-1500));
        expect(testResponse.tirePressure).to(equal(tires));
        expect(testResponse.turnSignal).to(equal(SDLTurnSignalBoth));
        expect(testResponse.vin).to(equal(vin));
        expect(testResponse.wiperStatus).to(equal(SDLWiperStatusAutomaticHigh));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{SDLNameNotification:
                                           @{SDLNameParameters:
                                                 @{
                                                     SDLNameAccelerationPedalPosition:@0,
                                                     SDLNameAirbagStatus:airbag,
                                                     SDLNameBeltStatus:belt,
                                                     SDLNameBodyInformation:body,
                                                     SDLNameCloudAppVehicleID:cloudAppVehicleID,
                                                     SDLNameClusterModeStatus:clusterMode,
                                                     SDLNameDeviceStatus:device,
                                                     SDLNameDriverBraking:SDLVehicleDataEventStatusNoEvent,
                                                     SDLNameECallInfo:eCall,
                                                     SDLNameElectronicParkBrakeStatus:SDLElectronicParkBrakeStatusDriveActive,
                                                     SDLNameEmergencyEvent:event,
                                                     SDLNameEngineOilLife:@23.22,
                                                     SDLNameEngineTorque:@630.4,
                                                     SDLNameExternalTemperature:@0,
                                                     SDLNameFuelLevel:@99.9999,
                                                     SDLNameFuelLevelState:SDLComponentVolumeStatusFault,
                                                     SDLNameFuelRange:@[fuelRange],
                                                     SDLNameGPS:gps,
                                                     SDLNameHeadLampStatus:headLamp,
                                                     SDLNameInstantFuelConsumption:@40.7,
                                                     SDLNameMyKey:myKey,
                                                     SDLNameOdometer:@70000,
                                                     SDLNamePRNDL:SDLPRNDLPark,
                                                     SDLNameRPM:@3,
                                                     SDLNameSpeed:@100,
                                                     SDLNameSteeringWheelAngle:@-1500,
                                                     SDLNameTirePressure:tires,
                                                     SDLNameTurnSignal:SDLTurnSignalOff,
                                                     SDLNameVIN:vin,
                                                     SDLNameWiperStatus:SDLWiperStatusAutomaticHigh},
                                             SDLNameOperationName:SDLNameGetVehicleData}} mutableCopy];
        SDLGetVehicleDataResponse* testResponse = [[SDLGetVehicleDataResponse alloc] initWithDictionary:dict];

        expect(testResponse.accPedalPosition).to(equal(@0));
        expect(testResponse.airbagStatus).to(equal(airbag));
        expect(testResponse.beltStatus).to(equal(belt));
        expect(testResponse.bodyInformation).to(equal(body));
        expect(testResponse.cloudAppVehicleID).to(equal(cloudAppVehicleID));
        expect(testResponse.clusterModeStatus).to(equal(clusterMode));
        expect(testResponse.deviceStatus).to(equal(device));
        expect(testResponse.driverBraking).to(equal(SDLVehicleDataEventStatusNoEvent));
        expect(testResponse.eCallInfo).to(equal(eCall));
        expect(testResponse.electronicParkBrakeStatus).to(equal(SDLElectronicParkBrakeStatusDriveActive));
        expect(testResponse.emergencyEvent).to(equal(event));
        expect(testResponse.engineOilLife).to(equal(@23.22));
        expect(testResponse.engineTorque).to(equal(@630.4));
        expect(testResponse.externalTemperature).to(equal(@0));
        expect(testResponse.fuelLevel).to(equal(@99.9999));
        expect(testResponse.fuelLevel_State).to(equal(SDLComponentVolumeStatusFault));
        expect(testResponse.fuelRange).to(equal(@[fuelRange]));
        expect(testResponse.gps).to(equal(gps));
        expect(testResponse.headLampStatus).to(equal(headLamp));
        expect(testResponse.instantFuelConsumption).to(equal(@40.7));
        expect(testResponse.myKey).to(equal(myKey));
        expect(testResponse.odometer).to(equal(@70000));
        expect(testResponse.prndl).to(equal(SDLPRNDLPark));
        expect(testResponse.rpm).to(equal(@3));
        expect(testResponse.speed).to(equal(@100));
        expect(testResponse.steeringWheelAngle).to(equal(@-1500));
        expect(testResponse.tirePressure).to(equal(tires));
        expect(testResponse.turnSignal).to(equal(SDLTurnSignalOff));
        expect(testResponse.vin).to(equal(vin));
        expect(testResponse.wiperStatus).to(equal(SDLWiperStatusAutomaticHigh));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLGetVehicleDataResponse* testResponse = [[SDLGetVehicleDataResponse alloc] init];
        
        expect(testResponse.accPedalPosition).to(beNil());
        expect(testResponse.airbagStatus).to(beNil());
        expect(testResponse.beltStatus).to(beNil());
        expect(testResponse.bodyInformation).to(beNil());
        expect(testResponse.cloudAppVehicleID).to(beNil());
        expect(testResponse.clusterModeStatus).to(beNil());
        expect(testResponse.deviceStatus).to(beNil());
        expect(testResponse.driverBraking).to(beNil());
        expect(testResponse.eCallInfo).to(beNil());
        expect(testResponse.electronicParkBrakeStatus).to(beNil());
        expect(testResponse.emergencyEvent).to(beNil());
        expect(testResponse.engineOilLife).to(beNil());
        expect(testResponse.engineTorque).to(beNil());
        expect(testResponse.externalTemperature).to(beNil());
        expect(testResponse.fuelLevel).to(beNil());
        expect(testResponse.fuelLevel_State).to(beNil());
        expect(testResponse.fuelRange).to(beNil());
        expect(testResponse.gps).to(beNil());
        expect(testResponse.headLampStatus).to(beNil());
        expect(testResponse.instantFuelConsumption).to(beNil());
        expect(testResponse.myKey).to(beNil());
        expect(testResponse.odometer).to(beNil());
        expect(testResponse.prndl).to(beNil());
        expect(testResponse.rpm).to(beNil());
        expect(testResponse.speed).to(beNil());
        expect(testResponse.steeringWheelAngle).to(beNil());
        expect(testResponse.tirePressure).to(beNil());
        expect(testResponse.turnSignal).to(beNil());
        expect(testResponse.vin).to(beNil());
        expect(testResponse.wiperStatus).to(beNil());
    });
});

QuickSpecEnd
