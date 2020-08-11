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
NSArray *fuelRangeArray = @[fuelRange, fuelRange];
NSString *const vin = @"6574839201a";
NSString *const cloudAppVehicleID = @"cloudAppVehicleID";
const float speed = 123.45;
const NSUInteger rpm = 42;
const float fuelLevel = 10.3;
SDLComponentVolumeStatus fuelLevel_State = SDLComponentVolumeStatusAlert;
const float instantFuelConsumption = 4000.63;
const float externalTemperature = -10.5;
SDLTurnSignal turnSignal = SDLTurnSignalOff;
SDLPRNDL prndl = SDLPRNDLDrive;
NSUInteger odometer = 100500;
SDLVehicleDataEventStatus driverBraking = SDLVehicleDataEventStatusYes;
SDLWiperStatus wiperStatus = SDLWiperStatusStalled;
const float engineTorque = -200.124;
const float accPedalPosition = 99.99999999;
const float steeringWheelAngle = M_PI_4;
const float engineOilLife = 34.45;
SDLElectronicParkBrakeStatus electronicParkBrakeStatus = SDLElectronicParkBrakeStatusDriveActive;
const BOOL handsOffSteering = YES;

describe(@"getter/setter tests", ^{
    context(@"init", ^{
        SDLGetVehicleDataResponse* testResponse = [[SDLGetVehicleDataResponse alloc] init];
        it(@"should set and get correctly", ^{

            testResponse.accPedalPosition = @(accPedalPosition);
            testResponse.airbagStatus = airbag;
            testResponse.beltStatus = belt;
            testResponse.bodyInformation = body;
            testResponse.cloudAppVehicleID = cloudAppVehicleID;
            testResponse.clusterModeStatus = clusterMode;
            testResponse.deviceStatus = device;
            testResponse.driverBraking = driverBraking;
            testResponse.eCallInfo = eCall;
            testResponse.electronicParkBrakeStatus = electronicParkBrakeStatus;
            testResponse.emergencyEvent = event;
            testResponse.engineOilLife = @(engineOilLife);
            testResponse.engineTorque = @(engineTorque);
            testResponse.externalTemperature = @(externalTemperature);
            testResponse.gps = gps;
            testResponse.handsOffSteering = @(handsOffSteering);
            testResponse.headLampStatus = headLamp;
            testResponse.instantFuelConsumption = @(instantFuelConsumption);
            testResponse.myKey = myKey;
            testResponse.odometer = @(odometer);
            testResponse.prndl = prndl;
            testResponse.rpm = @(rpm);
            testResponse.speed = @(speed);
            testResponse.steeringWheelAngle = @(steeringWheelAngle);
            testResponse.tirePressure = tires;
            testResponse.turnSignal = turnSignal;
            testResponse.vin = vin;
            testResponse.wiperStatus = wiperStatus;
            testResponse.fuelRange = fuelRangeArray;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            testResponse.fuelLevel = @(fuelLevel);
            testResponse.fuelLevel_State = fuelLevel_State;
#pragma clang diagnostic pop

            expect(testResponse.accPedalPosition).to(equal(@(accPedalPosition)));
            expect(testResponse.airbagStatus).to(equal(airbag));
            expect(testResponse.beltStatus).to(equal(belt));
            expect(testResponse.bodyInformation).to(equal(body));
            expect(testResponse.cloudAppVehicleID).to(equal(cloudAppVehicleID));
            expect(testResponse.clusterModeStatus).to(equal(clusterMode));
            expect(testResponse.deviceStatus).to(equal(device));
            expect(testResponse.driverBraking).to(equal(driverBraking));
            expect(testResponse.eCallInfo).to(equal(eCall));
            expect(testResponse.electronicParkBrakeStatus).to(equal(SDLElectronicParkBrakeStatusDriveActive));
            expect(testResponse.emergencyEvent).to(equal(event));
            expect(testResponse.engineOilLife).to(equal(@(engineOilLife)));
            expect(testResponse.engineTorque).to(equal(@(engineTorque)));
            expect(testResponse.externalTemperature).to(equal(@(externalTemperature)));
            expect(testResponse.gps).to(equal(gps));
            expect(testResponse.handsOffSteering).to(equal(@(handsOffSteering)));
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
            expect(testResponse.fuelRange).to(equal(fuelRangeArray));
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            expect(testResponse.fuelLevel).to(equal(@(fuelLevel)));
            expect(testResponse.fuelLevel_State).to(equal(fuelLevel_State));
#pragma clang diagnostic pop
        });
    });

    
    it(@"should get correctly when initialized", ^ {
        NSDictionary* dict = @{SDLRPCParameterNameNotification:
                                           @{SDLRPCParameterNameParameters:
                                                 @{
                                                     SDLRPCParameterNameAccelerationPedalPosition:@(accPedalPosition),
                                                     SDLRPCParameterNameAirbagStatus:airbag,
                                                     SDLRPCParameterNameBeltStatus:belt,
                                                     SDLRPCParameterNameBodyInformation:body,
                                                     SDLRPCParameterNameCloudAppVehicleID:cloudAppVehicleID,
                                                     SDLRPCParameterNameClusterModeStatus:clusterMode,
                                                     SDLRPCParameterNameDeviceStatus:device,
                                                     SDLRPCParameterNameDriverBraking:driverBraking,
                                                     SDLRPCParameterNameECallInfo:eCall,
                                                     SDLRPCParameterNameElectronicParkBrakeStatus:electronicParkBrakeStatus,
                                                     SDLRPCParameterNameEmergencyEvent:event,
                                                     SDLRPCParameterNameEngineOilLife:@(engineOilLife),
                                                     SDLRPCParameterNameEngineTorque:@(engineTorque),
                                                     SDLRPCParameterNameExternalTemperature:@(externalTemperature),
                                                     SDLRPCParameterNameFuelLevel:@(fuelLevel),
                                                     SDLRPCParameterNameFuelLevelState:fuelLevel_State,
                                                     SDLRPCParameterNameFuelRange:fuelRangeArray,
                                                     SDLRPCParameterNameGPS:gps,
                                                     SDLRPCParameterNameHandsOffSteering:@(handsOffSteering),
                                                     SDLRPCParameterNameHeadLampStatus:headLamp,
                                                     SDLRPCParameterNameInstantFuelConsumption:@(instantFuelConsumption),
                                                     SDLRPCParameterNameMyKey:myKey,
                                                     SDLRPCParameterNameOdometer:@(odometer),
                                                     SDLRPCParameterNamePRNDL:prndl,
                                                     SDLRPCParameterNameRPM:@(rpm),
                                                     SDLRPCParameterNameSpeed:@(speed),
                                                     SDLRPCParameterNameSteeringWheelAngle:@(steeringWheelAngle),
                                                     SDLRPCParameterNameTirePressure:tires,
                                                     SDLRPCParameterNameTurnSignal:turnSignal,
                                                     SDLRPCParameterNameVIN:vin,
                                                     SDLRPCParameterNameWiperStatus:wiperStatus,
                                                 },
                                             SDLRPCParameterNameOperationName:SDLRPCFunctionNameGetVehicleData}};
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLGetVehicleDataResponse* testResponse = [[SDLGetVehicleDataResponse alloc] initWithDictionary:dict];
#pragma clang diagnostic pop

        expect(testResponse.accPedalPosition).to(equal(@(accPedalPosition)));
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
        expect(testResponse.engineOilLife).to(equal(@(engineOilLife)));
        expect(testResponse.engineTorque).to(equal(@(engineTorque)));
        expect(testResponse.externalTemperature).to(equal(@(externalTemperature)));
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        expect(testResponse.fuelLevel).to(equal(@(fuelLevel)));
        expect(testResponse.fuelLevel_State).to(equal(fuelLevel_State));
#pragma clang diagnostic pop
        expect(testResponse.fuelRange).to(equal(fuelRangeArray));
        expect(testResponse.gps).to(equal(gps));
        expect(testResponse.handsOffSteering).to(equal(@(handsOffSteering)));
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
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        expect(testResponse.fuelLevel).to(beNil());
        expect(testResponse.fuelLevel_State).to(beNil());
#pragma clang diagnostic pop
        expect(testResponse.fuelRange).to(beNil());
        expect(testResponse.gps).to(beNil());
        expect(testResponse.handsOffSteering).to(beNil());
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

    context(@"initWithGps:speed:rpm:fuelLevel:fuelLevel_State:instantFuelConsumption:fuelRange:externalTemperature:turnSignal:vin:prndl:tirePressure:odometer:beltStatus:bodyInformation:deviceStatus:driverBraking:wiperStatus:headLampStatus:engineTorque:accPedalPosition:steeringWheelAngle:engineOilLife:electronicParkBrakeStatus:cloudAppVehicleID:eCallInfo:airbagStatus:emergencyEvent:clusterModeStatus:myKey:", ^{
        SDLGetVehicleDataResponse *testResponse = [[SDLGetVehicleDataResponse alloc] initWithGps:gps speed:speed rpm:@(rpm) instantFuelConsumption:instantFuelConsumption fuelRange:fuelRangeArray externalTemperature:externalTemperature turnSignal:turnSignal vin:vin prndl:prndl tirePressure:tires odometer:@(odometer) beltStatus:belt bodyInformation:body deviceStatus:device driverBraking:driverBraking wiperStatus:wiperStatus headLampStatus:headLamp engineTorque:engineTorque accPedalPosition:accPedalPosition steeringWheelAngle:steeringWheelAngle engineOilLife:engineOilLife electronicParkBrakeStatus:electronicParkBrakeStatus cloudAppVehicleID:cloudAppVehicleID eCallInfo:eCall airbagStatus:airbag emergencyEvent:event clusterModeStatus:clusterMode myKey:myKey handsOffSteering:@(handsOffSteering)];
        it(@"should set all properties properly", ^{
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
            expect(testResponse.externalTemperature).to(equal(externalTemperature));
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            expect(testResponse.fuelLevel).to(beNil());
            expect(testResponse.fuelLevel_State).to(beNil());
#pragma clang diagnostic pop
            expect(testResponse.fuelRange).to(equal(fuelRangeArray));
            expect(testResponse.gps).to(equal(gps));
            expect(testResponse.handsOffSteering).to(equal(@(handsOffSteering)));
            expect(testResponse.headLampStatus).to(equal(headLamp));
            expect(testResponse.instantFuelConsumption).to(equal(instantFuelConsumption));
            expect(testResponse.myKey).to(equal(myKey));
            expect(testResponse.odometer).to(equal(odometer));
            expect(testResponse.prndl).to(equal(prndl));
            expect(testResponse.rpm).to(equal(rpm));
            expect(testResponse.speed).to(equal(speed));
            expect(testResponse.steeringWheelAngle).to(equal(steeringWheelAngle));
            expect(testResponse.tirePressure).to(equal(tires));
            expect(testResponse.turnSignal).to(equal(turnSignal));
            expect(testResponse.vin).to(equal(vin));
            expect(testResponse.wiperStatus).to(equal(wiperStatus));
        });
    });

    it(@"should set and get OEM Custom Vehicle Data", ^{
        SDLGetVehicleDataResponse *testResponse = [[SDLGetVehicleDataResponse alloc] init];
        [testResponse setOEMCustomVehicleData:@"customVehicleData" withVehicleDataState:@"oemVehicleData"];
        
        expect([testResponse getOEMCustomVehicleData:@"customVehicleData"]).to(equal(@"oemVehicleData"));
    });
});

QuickSpecEnd
