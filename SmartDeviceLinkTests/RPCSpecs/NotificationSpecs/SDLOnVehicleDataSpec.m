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
NSString *const cloudAppVehicleID = @"testCloudAppVehicleID";
NSString *const vin = @"6574839201a";
const float speed = 123.45;
const NSUInteger rpm = 3500;
const float instantFuelConsumption = 67.88;
const float externalTemperature = 37.7;
SDLTurnSignal turnSignal = SDLTurnSignalLeft;
SDLPRNDL prndl = SDLPRNDLPark;
const NSUInteger odometer = 98765;
SDLVehicleDataEventStatus driverBraking = SDLVehicleDataEventStatusNoEvent;
SDLWiperStatus wiperStatus = SDLWiperStatusManualLow;
const float fuelLevel = 98.76;
SDLComponentVolumeStatus fuelLevel_State = SDLComponentVolumeStatusNormal;
const float engineTorque = 765.56;
const float accPedalPosition = 34.56;
const float steeringWheelAngle = 56.78;
const float engineOilLife = 67.89;
SDLElectronicParkBrakeStatus electronicParkBrakeStatus = SDLElectronicParkBrakeStatusClosed;
const BOOL handsOffSteering = YES;

describe(@"getter/setter tests", ^ {
    it(@"should correctly initialize with init", ^ {
        SDLOnVehicleData* testNotification = [[SDLOnVehicleData alloc] init];

        testNotification.accPedalPosition = @(accPedalPosition);
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
        testNotification.engineOilLife = @(engineOilLife);
        testNotification.engineTorque = @(engineTorque);
        testNotification.externalTemperature = @(externalTemperature);
        testNotification.gps = gps;
        testNotification.handsOffSteering = @YES;
        testNotification.headLampStatus = headLamp;
        testNotification.instantFuelConsumption = @(instantFuelConsumption);
        testNotification.myKey = myKey;
        testNotification.odometer = @(odometer);
        testNotification.prndl = prndl;
        testNotification.rpm = @(rpm);
        testNotification.speed = @(speed);
        testNotification.steeringWheelAngle = @(steeringWheelAngle);
        testNotification.tirePressure = tires;
        testNotification.turnSignal = turnSignal;
        testNotification.vin = vin;
        testNotification.wiperStatus = wiperStatus;
        testNotification.fuelRange = fuelRangeArray;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        testNotification.fuelLevel = @(fuelLevel);
        testNotification.fuelLevel_State = fuelLevel_State;
#pragma clang diagnostic pop

        expect(testNotification.accPedalPosition).to(equal(@(accPedalPosition)));
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
        expect(testNotification.engineOilLife).to(equal(@(engineOilLife)));
        expect(testNotification.engineTorque).to(equal(@(engineTorque)));
        expect(testNotification.externalTemperature).to(equal(@(externalTemperature)));
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
        expect(testNotification.handsOffSteering).to(equal(@(handsOffSteering)));
        expect(testNotification.fuelRange).to(equal(fuelRangeArray));
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        expect(testNotification.fuelLevel).to(equal(@(fuelLevel)));
        expect(testNotification.fuelLevel_State).to(equal(fuelLevel_State));
#pragma clang diagnostic pop
    });
    
    it(@"should get correctly when initialized", ^ {
        NSDictionary* dict = @{SDLRPCParameterNameNotification:
                                   @{SDLRPCParameterNameParameters:
                                         @{SDLRPCParameterNameAccelerationPedalPosition:@(accPedalPosition),
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
                                           SDLRPCParameterNameHandsOffSteering:@(handsOffSteering)
                                         },
                                     SDLRPCParameterNameOperationName:SDLRPCFunctionNameOnVehicleData}};
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLOnVehicleData* testNotification = [[SDLOnVehicleData alloc] initWithDictionary:dict];
#pragma clang diagnostic pop
        
        expect(testNotification.accPedalPosition).to(equal(@(accPedalPosition)));
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
        expect(testNotification.gps).to(equal(gps));
        expect(testNotification.handsOffSteering).to(equal(@(handsOffSteering)));
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
        expect(testNotification.fuelRange).to(equal(fuelRangeArray));
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        expect(testNotification.fuelLevel).to(equal(@(fuelLevel)));
        expect(testNotification.fuelLevel_State).to(equal(fuelLevel_State));
#pragma clang diagnostic pop
    });
    
    it(@"should return nil if not set", ^ {
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
        expect(testNotification.gps).to(beNil());
        expect(testNotification.handsOffSteering).to(beNil());
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
        expect(testNotification.fuelRange).to(beNil());
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        expect(testNotification.fuelLevel).to(beNil());
        expect(testNotification.fuelLevel_State).to(beNil());
#pragma clang diagnostic pop
    });

    context(@"initWithGps:speed:rpm:instantFuelConsumption:fuelRange:externalTemperature:turnSignal:vin:prndl:tirePressure:odometer:beltStatus:bodyInformation:deviceStatus:driverBraking:wiperStatus:headLampStatus:engineTorque:accPedalPosition:steeringWheelAngle:engineOilLife:electronicParkBrakeStatus:cloudAppVehicleID:eCallInfo:airbagStatus:emergencyEvent:clusterModeStatus:myKey:handsOffSteering:", ^{
        SDLOnVehicleData *onVehicleData = [[SDLOnVehicleData alloc] initWithGps:gps speed:speed rpm:@(rpm) instantFuelConsumption:instantFuelConsumption fuelRange:fuelRangeArray externalTemperature:externalTemperature turnSignal:turnSignal vin:vin prndl:prndl tirePressure:tires odometer:@(odometer) beltStatus:belt bodyInformation:body deviceStatus:device driverBraking:driverBraking wiperStatus:wiperStatus headLampStatus:headLamp engineTorque:engineTorque accPedalPosition:accPedalPosition steeringWheelAngle:steeringWheelAngle engineOilLife:engineOilLife electronicParkBrakeStatus:electronicParkBrakeStatus cloudAppVehicleID:cloudAppVehicleID eCallInfo:eCall airbagStatus:airbag emergencyEvent:event clusterModeStatus:clusterMode myKey:myKey handsOffSteering:@(handsOffSteering)];
        it(@"should initialize an object correctly", ^{
            expect(onVehicleData.accPedalPosition).to(equal(@(accPedalPosition)));
            expect(onVehicleData.airbagStatus).to(equal(airbag));
            expect(onVehicleData.beltStatus).to(equal(belt));
            expect(onVehicleData.bodyInformation).to(equal(body));
            expect(onVehicleData.cloudAppVehicleID).to(equal(cloudAppVehicleID));
            expect(onVehicleData.clusterModeStatus).to(equal(clusterMode));
            expect(onVehicleData.deviceStatus).to(equal(device));
            expect(onVehicleData.driverBraking).to(equal(driverBraking));
            expect(onVehicleData.eCallInfo).to(equal(eCall));
            expect(onVehicleData.electronicParkBrakeStatus).to(equal(electronicParkBrakeStatus));
            expect(onVehicleData.emergencyEvent).to(equal(event));
            expect(onVehicleData.engineOilLife).to(equal(@(engineOilLife)));
            expect(onVehicleData.engineTorque).to(equal(@(engineTorque)));
            expect(onVehicleData.externalTemperature).to(equal(@(externalTemperature)));
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            expect(onVehicleData.fuelLevel).to(beNil());
            expect(onVehicleData.fuelLevel_State).to(beNil());
#pragma clang diagnostic pop
            expect(onVehicleData.fuelRange).to(equal(fuelRangeArray));
            expect(onVehicleData.gps).to(equal(gps));
            expect(onVehicleData.handsOffSteering).to(equal(@(handsOffSteering)));
            expect(onVehicleData.headLampStatus).to(equal(headLamp));
            expect(onVehicleData.instantFuelConsumption).to(equal(@(instantFuelConsumption)));
            expect(onVehicleData.myKey).to(equal(myKey));
            expect(onVehicleData.odometer).to(equal(@(odometer)));
            expect(onVehicleData.prndl).to(equal(prndl));
            expect(onVehicleData.rpm).to(equal(@(rpm)));
            expect(onVehicleData.speed).to(equal(@(speed)));
            expect(onVehicleData.steeringWheelAngle).to(equal((steeringWheelAngle)));
            expect(onVehicleData.tirePressure).to(equal(tires));
            expect(onVehicleData.turnSignal).to(equal(turnSignal));
            expect(onVehicleData.vin).to(equal(vin));
            expect(onVehicleData.wiperStatus).to(equal(wiperStatus));
        });

        it(@"should set and get OEM Custom Vehicle Data", ^{
             SDLOnVehicleData *testRequest = [[SDLOnVehicleData alloc] init];
             [testRequest setOEMCustomVehicleData:@"customVehicleData" withVehicleDataState:@"oemVehicleData"];

             expect([testRequest getOEMCustomVehicleData:@"customVehicleData"]).to(equal(@"oemVehicleData"));
        });
    });
});

QuickSpecEnd
