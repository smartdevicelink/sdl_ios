//
//  SDLGetVehicleDataResponseSpec.m
//  SmartDeviceLink

#import <Foundation/Foundation.h>
#import <Nimble/Nimble.h>
#import <Quick/Quick.h>

#import "SDLRPCFunctionNames.h"
#import "SDLRPCParameterNames.h"
#import "SmartDeviceLink.h"

QuickSpecBegin(SDLGetVehicleDataResponseSpec)

// set up all test constants
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
NSString* vin = @"6574839201a";
NSString* cloudAppVehicleID = @"cloud-6f56054e-d633-11ea-999a-14109fcf4b5b";
const float speed = 123.45;
const NSUInteger rpm = 3599;
const float fuelLevel = 34.45;
SDLComponentVolumeStatus fuelLevel_State = SDLComponentVolumeStatusLow;
const float instantFuelConsumption = 45.67;
const float externalTemperature = 56.67;
SDLTurnSignal turnSignal = SDLTurnSignalLeft;
SDLPRNDL prndl = SDLPRNDLReverse;
SDLTireStatus *tirePressure = [[SDLTireStatus alloc] init];
const NSUInteger odometer = 100999;
SDLVehicleDataEventStatus driverBraking = SDLVehicleDataEventStatusYes;
SDLWiperStatus wiperStatus = SDLWiperStatusWash;
const float steeringWheelAngle = 359.99;
const float engineTorque = 999.123;
const float accPedalPosition = 35.88;
const float engineOilLife = 98.76;
SDLElectronicParkBrakeStatus electronicParkBrakeStatus = SDLElectronicParkBrakeStatusTransition;
NSArray<SDLWindowStatus *> *windowStatus = @[[[SDLWindowStatus alloc] init], [[SDLWindowStatus alloc] init]];

describe(@"Getter/Setter Tests", ^ {
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

    context(@"initWithGps:speed:rpm:fuelLevel:fuelLevel_State:instantFuelConsumption:fuelRange:externalTemperature:turnSignal:vin:prndl:tirePressure:odometer:beltStatus:bodyInformation:deviceStatus:driverBraking:wiperStatus:headLampStatus:engineTorque:accPedalPosition:steeringWheelAngle:engineOilLife:electronicParkBrakeStatus:cloudAppVehicleID:eCallInfo:airbagStatus:emergencyEvent:clusterModeStatus:myKey:windowStatus:", ^{

        SDLGetVehicleDataResponse *testResponse = [[SDLGetVehicleDataResponse alloc] initWithGps:gps speed:speed rpm:@(rpm) fuelLevel:fuelLevel fuelLevel_State:fuelLevel_State instantFuelConsumption:instantFuelConsumption fuelRange:@[fuelRange, fuelRange] externalTemperature:externalTemperature turnSignal:turnSignal vin:vin prndl:prndl tirePressure:tirePressure odometer:@(odometer) beltStatus:belt bodyInformation:body deviceStatus:device driverBraking:driverBraking wiperStatus:wiperStatus headLampStatus:headLamp engineTorque:engineTorque accPedalPosition:accPedalPosition steeringWheelAngle:steeringWheelAngle engineOilLife:engineOilLife electronicParkBrakeStatus:electronicParkBrakeStatus cloudAppVehicleID:cloudAppVehicleID eCallInfo:eCall airbagStatus:airbag emergencyEvent:event clusterModeStatus:clusterMode myKey:myKey windowStatus:windowStatus];

        it(@"Expect all properties to be set properly", ^{
            expect(testResponse.accPedalPosition).to(equal(accPedalPosition));
            expect(testResponse.airbagStatus).to(equal(airbag));
            expect(testResponse.beltStatus).to(equal(belt));
            expect(testResponse.bodyInformation).to(equal(body));
            expect(testResponse.cloudAppVehicleID).to(equal(cloudAppVehicleID));
            expect(testResponse.clusterModeStatus).to(equal(clusterMode));
            expect(testResponse.deviceStatus).to(equal(device));
            expect(testResponse.driverBraking).to(equal(driverBraking));
            expect(testResponse.eCallInfo).to(equal(eCall));
            expect(testResponse.electronicParkBrakeStatus).to(equal(electronicParkBrakeStatus));
            expect(testResponse.emergencyEvent).to(equal(event));
            expect(testResponse.engineOilLife).to(equal(engineOilLife));
            expect(testResponse.engineTorque).to(equal(engineTorque));
            expect(testResponse.externalTemperature).to(equal(@(externalTemperature)));
            expect(testResponse.fuelLevel).to(equal(@(fuelLevel)));
            expect(testResponse.fuelLevel_State).to(equal(fuelLevel_State));
            expect(testResponse.fuelRange).to(equal(@[fuelRange, fuelRange]));
            expect(testResponse.gps).to(equal(gps));
            expect(testResponse.headLampStatus).to(equal(headLamp));
            expect(testResponse.instantFuelConsumption).to(equal(@(instantFuelConsumption)));
            expect(testResponse.myKey).to(equal(myKey));
            expect(testResponse.odometer).to(equal(@(odometer)));
            expect(testResponse.prndl).to(equal(prndl));
            expect(testResponse.rpm).to(equal(@(rpm)));
            expect(testResponse.speed).to(equal(@(speed)));
            expect(testResponse.steeringWheelAngle).to(equal(@(steeringWheelAngle)));
            expect(testResponse.tirePressure).to(equal(tires));
            expect(testResponse.turnSignal).to(equal(turnSignal));
            expect(testResponse.vin).to(equal(vin));
            expect(testResponse.wiperStatus).to(equal(wiperStatus));
            expect(testResponse.windowStatus).to(equal(windowStatus));
        });
    });

    it(@"Should set and get OEM Custom Vehicle Data", ^{
        SDLGetVehicleDataResponse *testRequest = [[SDLGetVehicleDataResponse alloc] init];

        [testRequest setOEMCustomVehicleData:@"customVehicleData" withVehicleDataState:@"oemVehicleData"];
        
        expect([testRequest getOEMCustomVehicleData:@"customVehicleData"]).to(equal(@"oemVehicleData"));
    });
});

QuickSpecEnd
