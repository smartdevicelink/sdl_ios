//
//  SDLOnVehicleDataSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SmartDeviceLink.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"


QuickSpecBegin(SDLOnVehicleDataSpec)

describe(@"Getter/Setter Tests", ^ {
    __block SDLGPSData* gps = nil;
    __block SDLTireStatus* tires = nil;
    __block SDLBeltStatus* belt = nil;
    __block SDLBodyInformation* body = nil;
    __block SDLDeviceStatus* device = nil;
    __block SDLHeadLampStatus* headLamp = nil;
    __block SDLECallInfo* eCall = nil;
    __block SDLAirbagStatus* airbag = nil;
    __block SDLEmergencyEvent* event = nil;
    __block SDLClusterModeStatus* clusterMode = nil;
    __block SDLMyKey* myKey = nil;
    __block SDLFuelRange* fuelRange = nil;
    __block NSString* cloudAppVehicleID = nil;

    beforeEach(^{
        gps = [[SDLGPSData alloc] init];
        tires = [[SDLTireStatus alloc] init];
        belt = [[SDLBeltStatus alloc] init];
        body = [[SDLBodyInformation alloc] init];
        device = [[SDLDeviceStatus alloc] init];
        headLamp = [[SDLHeadLampStatus alloc] init];
        eCall = [[SDLECallInfo alloc] init];
        airbag = [[SDLAirbagStatus alloc] init];
        event = [[SDLEmergencyEvent alloc] init];
        clusterMode = [[SDLClusterModeStatus alloc] init];
        myKey = [[SDLMyKey alloc] init];
        fuelRange = [[SDLFuelRange alloc] init];
        cloudAppVehicleID = @"testCloudAppVehicleID";
    });

    it(@"Should set and get correctly", ^ {
        SDLOnVehicleData* testNotification = [[SDLOnVehicleData alloc] init];

        testNotification.accPedalPosition = @99.99999999;
        testNotification.airbagStatus = airbag;
        testNotification.beltStatus = belt;
        testNotification.bodyInformation = body;
        testNotification.cloudAppVehicleID = cloudAppVehicleID;
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
        expect(testNotification.cloudAppVehicleID).to(equal(cloudAppVehicleID));
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
        NSDictionary* dict = @{SDLRPCParameterNameNotification:
                                   @{SDLRPCParameterNameParameters:
                                         @{SDLRPCParameterNameAccelerationPedalPosition:@99.99999999,
                                           SDLRPCParameterNameAirbagStatus:airbag,
                                           SDLRPCParameterNameBeltStatus:belt,
                                           SDLRPCParameterNameBodyInformation:body,
                                           SDLRPCParameterNameCloudAppVehicleID:cloudAppVehicleID,
                                           SDLRPCParameterNameClusterModeStatus:clusterMode,
                                           SDLRPCParameterNameDeviceStatus:device,
                                           SDLRPCParameterNameDriverBraking:SDLVehicleDataEventStatusYes,
                                           SDLRPCParameterNameECallInfo:eCall,
                                           SDLRPCParameterNameElectronicParkBrakeStatus:SDLElectronicParkBrakeStatusDriveActive,
                                           SDLRPCParameterNameEmergencyEvent:event,
                                           SDLRPCParameterNameEngineOilLife:@45.1,
                                           SDLRPCParameterNameEngineTorque:@-200.124,
                                           SDLRPCParameterNameExternalTemperature:@-10,
                                           SDLRPCParameterNameFuelLevel:@10.3,
                                           SDLRPCParameterNameFuelLevelState:SDLComponentVolumeStatusAlert,
                                           SDLRPCParameterNameFuelRange:@[fuelRange],
                                           SDLRPCParameterNameGPS:gps,
                                           SDLRPCParameterNameHeadLampStatus:headLamp,
                                           SDLRPCParameterNameInstantFuelConsumption:@4000.63,
                                           SDLRPCParameterNameMyKey:myKey,
                                           SDLRPCParameterNameOdometer:@100050,
                                           SDLRPCParameterNamePRNDL:SDLPRNDLDrive,
                                           SDLRPCParameterNameRPM:@4242,
                                           SDLRPCParameterNameSpeed:@70.1,
                                           SDLRPCParameterNameSteeringWheelAngle:@0.000000001,
                                           SDLRPCParameterNameTirePressure:tires,
                                           SDLRPCParameterNameTurnSignal:SDLTurnSignalOff,
                                           SDLRPCParameterNameVIN:@"222222222722",
                                           SDLRPCParameterNameWiperStatus:SDLWiperStatusStalled},
                                     SDLRPCParameterNameOperationName:SDLRPCFunctionNameOnVehicleData}};
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLOnVehicleData* testNotification = [[SDLOnVehicleData alloc] initWithDictionary:dict];
#pragma clang diagnostic pop
        
        expect(testNotification.accPedalPosition).to(equal(@99.99999999));
        expect(testNotification.airbagStatus).to(equal(airbag));
        expect(testNotification.beltStatus).to(equal(belt));
        expect(testNotification.bodyInformation).to(equal(body));
        expect(testNotification.cloudAppVehicleID).to(equal(cloudAppVehicleID));
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
        expect(testNotification.cloudAppVehicleID).to(beNil());
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

    it(@"should set and get generic Network data", ^{
        SDLOnVehicleData *testRequest = [[SDLOnVehicleData alloc] init];

        [testRequest setGenericNetworkData:@"speed" withVehicleDataState:@100];
        [testRequest setGenericNetworkData:@"turnSignal" withVehicleDataState:SDLTurnSignalOff];

        expect([testRequest genericNetworkData:@"speed"]).to(equal(@100));
        expect([testRequest genericNetworkData:@"turnSignal"]).to(equal(SDLTurnSignalOff));

    });
});

QuickSpecEnd
