//
//  SDLGetVehicleDataResponseSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SmartDeviceLink.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"
#import "SDLStabilityControlsStatus.h"

QuickSpecBegin(SDLGetVehicleDataResponseSpec)

describe(@"getter/setter tests", ^ {
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
    NSString* cloudAppVehicleID = @"testCloudAppVehicleID";
    SDLStabilityControlsStatus* stabilityControlsStatus = [[SDLStabilityControlsStatus alloc] initWithEscSystem:SDLVehicleDataStatusOn trailerSwayControl:SDLVehicleDataStatusOn];
    const float speed = 23.45;
    const NSUInteger rpm = 3599;
    const float fuelLevel = 34.45;
    SDLComponentVolumeStatus fuelLevel_State = SDLComponentVolumeStatusNormal;
    const float instantFuelConsumption = 45.56;
    const float externalTemperature = 56.67;
    SDLTurnSignal turnSignal = SDLTurnSignalBoth;
    NSString *vin = @"vin_aff9b0fe-d661-11ea-8d93-14109fcf4b5b";
    SDLPRNDL prndl = SDLPRNDLDrive;
    const NSUInteger odometer = 100999;
    SDLVehicleDataEventStatus driverBraking = SDLVehicleDataEventStatusYes;
    SDLWiperStatus wiperStatus = SDLWiperStatusManualHigh;
    const float engineTorque = 67.78;
    const float accPedalPosition = 78.89;
    const float steeringWheelAngle = -355.5;
    const float engineOilLife = 89.909;
    SDLElectronicParkBrakeStatus electronicParkBrakeStatus = SDLElectronicParkBrakeStatusDriveActive;

    it(@"should set and get correctly", ^ {
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
        testResponse.stabilityControlsStatus = stabilityControlsStatus;

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
        expect(testResponse.stabilityControlsStatus).to(equal(stabilityControlsStatus));
    });
    
    it(@"should get correctly when initialized", ^ {
        NSDictionary* dict = @{SDLRPCParameterNameNotification:
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
                                                     SDLRPCParameterNameWiperStatus:SDLWiperStatusAutomaticHigh,
                                                     SDLRPCParameterNameStabilityControlsStatus:stabilityControlsStatus
                                                 },
                                             SDLRPCParameterNameOperationName:SDLRPCFunctionNameGetVehicleData}};
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
        expect(testResponse.stabilityControlsStatus).to(equal(stabilityControlsStatus));
    });
    
    it(@"should return nil if not set", ^ {
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
        expect(testResponse.stabilityControlsStatus).to(beNil());
    });

    context(@"initWithGps:speed:rpm:fuelLevel:fuelLevel_State:instantFuelConsumption:fuelRange:externalTemperature:turnSignal:vin:prndl:tirePressure:odometer:beltStatus:bodyInformation:deviceStatus:driverBraking:wiperStatus:headLampStatus:engineTorque:accPedalPosition:steeringWheelAngle:engineOilLife:electronicParkBrakeStatus:cloudAppVehicleID:stabilityControlsStatus:eCallInfo:airbagStatus:emergencyEvent:clusterModeStatus:myKey:", ^{

        SDLGetVehicleDataResponse* testNotification = [[SDLGetVehicleDataResponse alloc] initWithGps:gps speed:speed rpm:@(rpm) fuelLevel:fuelLevel fuelLevel_State:fuelLevel_State instantFuelConsumption:instantFuelConsumption fuelRange:@[fuelRange, fuelRange] externalTemperature:externalTemperature turnSignal:turnSignal vin:vin prndl:prndl tirePressure:tires odometer:@(odometer) beltStatus:belt bodyInformation:body deviceStatus:device driverBraking:driverBraking wiperStatus:wiperStatus headLampStatus:headLamp engineTorque:engineTorque accPedalPosition:accPedalPosition steeringWheelAngle:steeringWheelAngle engineOilLife:engineOilLife electronicParkBrakeStatus:electronicParkBrakeStatus cloudAppVehicleID:cloudAppVehicleID stabilityControlsStatus:stabilityControlsStatus eCallInfo:eCall airbagStatus:airbag emergencyEvent:event clusterModeStatus:clusterMode myKey:myKey];

         it(@"expect all properties to be set properly", ^{
             expect(testNotification.accPedalPosition).to(equal(accPedalPosition));
             expect(testNotification.airbagStatus).to(equal(airbag));
             expect(testNotification.beltStatus).to(equal(belt));
             expect(testNotification.bodyInformation).to(equal(body));
             expect(testNotification.cloudAppVehicleID).to(equal(cloudAppVehicleID));
             expect(testNotification.clusterModeStatus).to(equal(clusterMode));
             expect(testNotification.deviceStatus).to(equal(device));
             expect(testNotification.driverBraking).to(equal(driverBraking));
             expect(testNotification.eCallInfo).to(equal(eCall));
             expect(testNotification.electronicParkBrakeStatus).to(equal(electronicParkBrakeStatus));
             expect(testNotification.emergencyEvent).to(equal(event));
             expect(testNotification.engineOilLife).to(equal(@(engineOilLife)));
             expect(testNotification.engineTorque).to(equal(@(engineTorque)));
             expect(testNotification.externalTemperature).to(equal(@(externalTemperature)));
             expect(testNotification.fuelLevel).to(equal(@(fuelLevel)));
             expect(testNotification.fuelLevel_State).to(equal(fuelLevel_State));
             expect(testNotification.fuelRange).to(equal(@[fuelRange, fuelRange]));
             expect(testNotification.gps).to(equal(gps));
             expect(testNotification.headLampStatus).to(equal(headLamp));
             expect(testNotification.instantFuelConsumption).to(equal(@(instantFuelConsumption)));
             expect(testNotification.myKey).to(equal(myKey));
             expect(testNotification.odometer).to(equal(@(odometer)));
             expect(testNotification.prndl).to(equal(prndl));
             expect(testNotification.rpm).to(equal(@(rpm)));
             expect(testNotification.speed).to(equal(@(speed)));
             expect(testNotification.steeringWheelAngle).to(equal(@(steeringWheelAngle)));
             expect(testNotification.tirePressure).to(equal(tires));
             expect(testNotification.turnSignal).to(equal(turnSignal));
             expect(testNotification.vin).to(equal(vin));
             expect(testNotification.wiperStatus).to(equal(wiperStatus));
             expect(testNotification.stabilityControlsStatus).to(equal(stabilityControlsStatus));
         });
     });

    it(@"should set and get OEM Custom Vehicle Data", ^{
        SDLGetVehicleDataResponse *testRequest = [[SDLGetVehicleDataResponse alloc] init];
        [testRequest setOEMCustomVehicleData:@"customVehicleData" withVehicleDataState:@"oemVehicleData"];
        
        expect([testRequest getOEMCustomVehicleData:@"customVehicleData"]).to(equal(@"oemVehicleData"));
    });
});

QuickSpecEnd
