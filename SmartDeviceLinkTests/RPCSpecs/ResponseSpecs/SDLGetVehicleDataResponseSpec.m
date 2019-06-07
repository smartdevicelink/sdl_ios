//
//  SDLGetVehicleDataResponseSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SmartDeviceLink.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"


QuickSpecBegin(SDLGetVehicleDataResponseSpec)

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
    __block NSString* vin = nil;
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
        vin = @"6574839201a";
        cloudAppVehicleID = @"cloudAppVehicleID";
    });

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
        NSMutableDictionary* dict = [@{SDLRPCParameterNameNotification:
                                           @{SDLRPCParameterNameParameters:
                                                 @{
                                                     SDLRPCParameterNameAccelerationPedalPosition:@0,
                                                     SDLRPCParameterNameAirbagStatus:airbag,
                                                     SDLRPCParameterNameBeltStatus:belt,
                                                     SDLRPCParameterNameBodyInformation:body,
                                                     SDLRPCParameterNameCloudAppVehicleID:cloudAppVehicleID,
                                                     SDLRPCParameterNameClusterModeStatus:clusterMode,
                                                     SDLRPCParameterNameDeviceStatus:device,
                                                     SDLRPCParameterNameDriverBraking:SDLVehicleDataEventStatusNoEvent,
                                                     SDLRPCParameterNameECallInfo:eCall,
                                                     SDLRPCParameterNameElectronicParkBrakeStatus:SDLElectronicParkBrakeStatusDriveActive,
                                                     SDLRPCParameterNameEmergencyEvent:event,
                                                     SDLRPCParameterNameEngineOilLife:@23.22,
                                                     SDLRPCParameterNameEngineTorque:@630.4,
                                                     SDLRPCParameterNameExternalTemperature:@0,
                                                     SDLRPCParameterNameFuelLevel:@99.9999,
                                                     SDLRPCParameterNameFuelLevelState:SDLComponentVolumeStatusFault,
                                                     SDLRPCParameterNameFuelRange:@[fuelRange],
                                                     SDLRPCParameterNameGPS:gps,
                                                     SDLRPCParameterNameHeadLampStatus:headLamp,
                                                     SDLRPCParameterNameInstantFuelConsumption:@40.7,
                                                     SDLRPCParameterNameMyKey:myKey,
                                                     SDLRPCParameterNameOdometer:@70000,
                                                     SDLRPCParameterNamePRNDL:SDLPRNDLPark,
                                                     SDLRPCParameterNameRPM:@3,
                                                     SDLRPCParameterNameSpeed:@100,
                                                     SDLRPCParameterNameSteeringWheelAngle:@-1500,
                                                     SDLRPCParameterNameTirePressure:tires,
                                                     SDLRPCParameterNameTurnSignal:SDLTurnSignalOff,
                                                     SDLRPCParameterNameVIN:vin,
                                                     SDLRPCParameterNameWiperStatus:SDLWiperStatusAutomaticHigh},
                                             SDLRPCParameterNameOperationName:SDLRPCFunctionNameGetVehicleData}} mutableCopy];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLGetVehicleDataResponse* testResponse = [[SDLGetVehicleDataResponse alloc] initWithDictionary:dict];
#pragma clang diagnostic pop

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

    it(@"should set and get generic Network data", ^{
        SDLGetVehicleDataResponse *testRequest = [[SDLGetVehicleDataResponse alloc] init];

        [testRequest setGenericNetworkData:@"speed" withVehicleDataState:@100];
        [testRequest setGenericNetworkData:@"turnSignal" withVehicleDataState:SDLTurnSignalOff];

        expect([testRequest genericNetworkData:@"speed"]).to(equal(@100));
        expect([testRequest genericNetworkData:@"turnSignal"]).to(equal(SDLTurnSignalOff));

    });
});

QuickSpecEnd
