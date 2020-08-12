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

// set up all test constants
SDLGPSData* gps = [[SDLGPSData alloc] init];
SDLTireStatus* tirePressure = [[SDLTireStatus alloc] init];
SDLBeltStatus* beltStatus = [[SDLBeltStatus alloc] init];
SDLBodyInformation* bodyInformation = [[SDLBodyInformation alloc] init];
SDLDeviceStatus* deviceStatus = [[SDLDeviceStatus alloc] init];
SDLHeadLampStatus* headLampStatus = [[SDLHeadLampStatus alloc] init];
SDLECallInfo* eCallInfo = [[SDLECallInfo alloc] init];
SDLAirbagStatus* airbagStatus = [[SDLAirbagStatus alloc] init];
SDLEmergencyEvent* emergencyEvent = [[SDLEmergencyEvent alloc] init];
SDLClusterModeStatus* clusterModeStatus = [[SDLClusterModeStatus alloc] init];
SDLMyKey* myKey = [[SDLMyKey alloc] init];
SDLFuelRange* fuelRange = [[SDLFuelRange alloc] init];
NSArray<SDLFuelRange *> *fuelRangeArray = @[fuelRange, fuelRange];
NSString *const vin = @"6574839201a";
NSString *const cloudAppVehicleID = @"cloud-6f56054e-d633-11ea-999a-14109fcf4b5b";
const float speed = 123.45;
const NSUInteger rpm = 3599;
const float fuelLevel = 34.45;
SDLComponentVolumeStatus fuelLevel_State = SDLComponentVolumeStatusLow;
const float instantFuelConsumption = 45.67;
const float externalTemperature = 56.67;
SDLTurnSignal turnSignal = SDLTurnSignalLeft;
SDLPRNDL prndl = SDLPRNDLReverse;
const NSUInteger odometer = 100999;
SDLVehicleDataEventStatus driverBraking = SDLVehicleDataEventStatusYes;
SDLWiperStatus wiperStatus = SDLWiperStatusWash;
const float steeringWheelAngle = 359.99;
const float engineTorque = 999.123;
const float accPedalPosition = 35.88;
const float engineOilLife = 98.76;
SDLElectronicParkBrakeStatus electronicParkBrakeStatus = SDLElectronicParkBrakeStatusTransition;
NSArray<SDLWindowStatus *> *windowStatus = @[[[SDLWindowStatus alloc] init], [[SDLWindowStatus alloc] init]];

describe(@"getter/setter tests", ^{
    context(@"init and assign", ^{
        SDLOnVehicleData* testNotification = [[SDLOnVehicleData alloc] init];

        testNotification.accPedalPosition = @(accPedalPosition);
        testNotification.airbagStatus = airbagStatus;
        testNotification.beltStatus = beltStatus;
        testNotification.bodyInformation = bodyInformation;
        testNotification.cloudAppVehicleID = cloudAppVehicleID;
        testNotification.clusterModeStatus = clusterModeStatus;
        testNotification.deviceStatus = deviceStatus;
        testNotification.driverBraking = driverBraking;
        testNotification.eCallInfo = eCallInfo;
        testNotification.electronicParkBrakeStatus = electronicParkBrakeStatus;
        testNotification.emergencyEvent = emergencyEvent;
        testNotification.engineOilLife = @(engineOilLife);
        testNotification.engineTorque = @(engineTorque);
        testNotification.externalTemperature = @(externalTemperature);
        testNotification.fuelLevel = @(fuelLevel);
        testNotification.fuelLevel_State = fuelLevel_State;
        testNotification.fuelRange = fuelRangeArray;
        testNotification.gps = gps;
        testNotification.headLampStatus = headLampStatus;
        testNotification.instantFuelConsumption = @(instantFuelConsumption);
        testNotification.myKey = myKey;
        testNotification.odometer = @(odometer);
        testNotification.prndl = prndl;
        testNotification.rpm = @(rpm);
        testNotification.speed = @(speed);
        testNotification.steeringWheelAngle = @(steeringWheelAngle);
        testNotification.tirePressure = tirePressure;
        testNotification.turnSignal = turnSignal;
        testNotification.vin = vin;
        testNotification.windowStatus = windowStatus;
        testNotification.wiperStatus = wiperStatus;

        it(@"expect all properties to be set properly", ^{
            expect(testNotification.accPedalPosition).to(equal(@(accPedalPosition)));
            expect(testNotification.airbagStatus).to(equal(airbagStatus));
            expect(testNotification.beltStatus).to(equal(beltStatus));
            expect(testNotification.bodyInformation).to(equal(bodyInformation));
            expect(testNotification.cloudAppVehicleID).to(equal(cloudAppVehicleID));
            expect(testNotification.clusterModeStatus).to(equal(clusterModeStatus));
            expect(testNotification.deviceStatus).to(equal(deviceStatus));
            expect(testNotification.driverBraking).to(equal(driverBraking));
            expect(testNotification.eCallInfo).to(equal(eCallInfo));
            expect(testNotification.electronicParkBrakeStatus).to(equal(electronicParkBrakeStatus));
            expect(testNotification.emergencyEvent).to(equal(emergencyEvent));
            expect(testNotification.engineOilLife).to(equal(@(engineOilLife)));
            expect(testNotification.engineTorque).to(equal(@(engineTorque)));
            expect(testNotification.externalTemperature).to(equal(@(externalTemperature)));
            expect(testNotification.fuelLevel).to(equal(@(fuelLevel)));
            expect(testNotification.fuelLevel_State).to(equal(fuelLevel_State));
            expect(testNotification.fuelRange).to(equal(fuelRangeArray));
            expect(testNotification.gps).to(equal(gps));
            expect(testNotification.headLampStatus).to(equal(headLampStatus));
            expect(testNotification.instantFuelConsumption).to(equal(@(instantFuelConsumption)));
            expect(testNotification.myKey).to(equal(myKey));
            expect(testNotification.odometer).to(equal(@(odometer)));
            expect(testNotification.prndl).to(equal(prndl));
            expect(testNotification.rpm).to(equal(@(rpm)));
            expect(testNotification.speed).to(equal(@(speed)));
            expect(testNotification.steeringWheelAngle).to(equal(@(steeringWheelAngle)));
            expect(testNotification.tirePressure).to(equal(tirePressure));
            expect(testNotification.turnSignal).to(equal(turnSignal));
            expect(testNotification.vin).to(equal(vin));
            expect(testNotification.windowStatus).to(equal(windowStatus));
            expect(testNotification.wiperStatus).to(equal(wiperStatus));
        });
    });
    
    context(@"initWithDictionary:", ^{
        NSDictionary* dict = @{SDLRPCParameterNameNotification:
                                   @{SDLRPCParameterNameParameters:@{
                                        SDLRPCParameterNameAccelerationPedalPosition:@(accPedalPosition),
                                        SDLRPCParameterNameAirbagStatus:airbagStatus,
                                        SDLRPCParameterNameBeltStatus:beltStatus,
                                        SDLRPCParameterNameBodyInformation:bodyInformation,
                                        SDLRPCParameterNameCloudAppVehicleID:cloudAppVehicleID,
                                        SDLRPCParameterNameClusterModeStatus:clusterModeStatus,
                                        SDLRPCParameterNameDeviceStatus:deviceStatus,
                                        SDLRPCParameterNameDriverBraking:driverBraking,
                                        SDLRPCParameterNameECallInfo:eCallInfo,
                                        SDLRPCParameterNameElectronicParkBrakeStatus:electronicParkBrakeStatus,
                                        SDLRPCParameterNameEmergencyEvent:emergencyEvent,
                                        SDLRPCParameterNameEngineOilLife:@(engineOilLife),
                                        SDLRPCParameterNameEngineTorque:@(engineTorque),
                                        SDLRPCParameterNameExternalTemperature:@(externalTemperature),
                                        SDLRPCParameterNameFuelLevel:@(fuelLevel),
                                        SDLRPCParameterNameFuelLevelState:fuelLevel_State,
                                        SDLRPCParameterNameFuelRange:fuelRangeArray,
                                        SDLRPCParameterNameGPS:gps,
                                        SDLRPCParameterNameHeadLampStatus:headLampStatus,
                                        SDLRPCParameterNameInstantFuelConsumption:@(instantFuelConsumption),
                                        SDLRPCParameterNameMyKey:myKey,
                                        SDLRPCParameterNameOdometer:@(odometer),
                                        SDLRPCParameterNamePRNDL:prndl,
                                        SDLRPCParameterNameRPM:@(rpm),
                                        SDLRPCParameterNameSpeed:@(speed),
                                        SDLRPCParameterNameSteeringWheelAngle:@(steeringWheelAngle),
                                        SDLRPCParameterNameTirePressure:tirePressure,
                                        SDLRPCParameterNameTurnSignal:turnSignal,
                                        SDLRPCParameterNameVIN:vin,
                                        SDLRPCParameterNameWindowStatus:windowStatus,
                                        SDLRPCParameterNameWiperStatus:wiperStatus,
                                        },
                                     SDLRPCParameterNameOperationName:SDLRPCFunctionNameOnVehicleData}};
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLOnVehicleData* testNotification = [[SDLOnVehicleData alloc] initWithDictionary:dict];
#pragma clang diagnostic pop

        it(@"expect all properties to be set properly", ^{
            expect(testNotification.accPedalPosition).to(equal(@(accPedalPosition)));
            expect(testNotification.airbagStatus).to(equal(airbagStatus));
            expect(testNotification.beltStatus).to(equal(beltStatus));
            expect(testNotification.bodyInformation).to(equal(bodyInformation));
            expect(testNotification.cloudAppVehicleID).to(equal(cloudAppVehicleID));
            expect(testNotification.clusterModeStatus).to(equal(clusterModeStatus));
            expect(testNotification.deviceStatus).to(equal(deviceStatus));
            expect(testNotification.driverBraking).to(equal(driverBraking));
            expect(testNotification.eCallInfo).to(equal(eCallInfo));
            expect(testNotification.electronicParkBrakeStatus).to(equal(electronicParkBrakeStatus));
            expect(testNotification.emergencyEvent).to(equal(emergencyEvent));
            expect(testNotification.engineOilLife).to(equal(@(engineOilLife)));
            expect(testNotification.engineTorque).to(equal(@(engineTorque)));
            expect(testNotification.externalTemperature).to(equal(@(externalTemperature)));
            expect(testNotification.fuelLevel).to(equal(@(fuelLevel)));
            expect(testNotification.fuelLevel_State).to(equal(fuelLevel_State));
            expect(testNotification.fuelRange).to(equal(fuelRangeArray));
            expect(testNotification.gps).to(equal(gps));
            expect(testNotification.headLampStatus).to(equal(headLampStatus));
            expect(testNotification.instantFuelConsumption).to(equal(@(instantFuelConsumption)));
            expect(testNotification.myKey).to(equal(myKey));
            expect(testNotification.odometer).to(equal(@(odometer)));
            expect(testNotification.prndl).to(equal(prndl));
            expect(testNotification.rpm).to(equal(@(rpm)));
            expect(testNotification.speed).to(equal(@(speed)));
            expect(testNotification.steeringWheelAngle).to(equal(@(steeringWheelAngle)));
            expect(testNotification.tirePressure).to(equal(tirePressure));
            expect(testNotification.turnSignal).to(equal(turnSignal));
            expect(testNotification.vin).to(equal(vin));
            expect(testNotification.windowStatus).to(equal(windowStatus));
            expect(testNotification.wiperStatus).to(equal(wiperStatus));
        });
    });
    
    context(@"init", ^{
        SDLOnVehicleData* testNotification = [[SDLOnVehicleData alloc] init];

        it(@"expect all properties to be nil", ^{
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
            expect(testNotification.windowStatus).to(beNil());
            expect(testNotification.wiperStatus).to(beNil());
        });
    });

    context(@"initWithGps:speed:rpm:fuelLevel:fuelLevel_State:instantFuelConsumption:fuelRange:externalTemperature:turnSignal:vin:prndl:tirePressure:odometer:beltStatus:bodyInformation:deviceStatus:driverBraking:wiperStatus:headLampStatus:engineTorque:accPedalPosition:steeringWheelAngle:engineOilLife:electronicParkBrakeStatus:cloudAppVehicleID:eCallInfo:airbagStatus:emergencyEvent:clusterModeStatus:myKey:windowStatus:", ^{
        SDLOnVehicleData* testNotification = [[SDLOnVehicleData alloc] initWithGps:gps speed:speed rpm:@(rpm) fuelLevel:fuelLevel fuelLevel_State:fuelLevel_State instantFuelConsumption:instantFuelConsumption fuelRange:fuelRangeArray externalTemperature:externalTemperature turnSignal:turnSignal vin:vin prndl:prndl tirePressure:tirePressure odometer:@(odometer) beltStatus:beltStatus bodyInformation:bodyInformation deviceStatus:deviceStatus driverBraking:driverBraking wiperStatus:wiperStatus headLampStatus:headLampStatus engineTorque:engineTorque accPedalPosition:accPedalPosition steeringWheelAngle:steeringWheelAngle engineOilLife:engineOilLife electronicParkBrakeStatus:electronicParkBrakeStatus cloudAppVehicleID:cloudAppVehicleID eCallInfo:eCallInfo airbagStatus:airbagStatus emergencyEvent:emergencyEvent clusterModeStatus:clusterModeStatus myKey:myKey windowStatus:windowStatus];

        it(@"expect all properties to be set properly", ^{
            expect(testNotification.accPedalPosition).to(equal(accPedalPosition));
            expect(testNotification.airbagStatus).to(equal(airbagStatus));
            expect(testNotification.beltStatus).to(equal(beltStatus));
            expect(testNotification.bodyInformation).to(equal(bodyInformation));
            expect(testNotification.cloudAppVehicleID).to(equal(cloudAppVehicleID));
            expect(testNotification.clusterModeStatus).to(equal(clusterModeStatus));
            expect(testNotification.deviceStatus).to(equal(deviceStatus));
            expect(testNotification.driverBraking).to(equal(driverBraking));
            expect(testNotification.eCallInfo).to(equal(eCallInfo));
            expect(testNotification.electronicParkBrakeStatus).to(equal(electronicParkBrakeStatus));
            expect(testNotification.emergencyEvent).to(equal(emergencyEvent));
            expect(testNotification.engineOilLife).to(equal(engineOilLife));
            expect(testNotification.engineTorque).to(equal(engineTorque));
            expect(testNotification.externalTemperature).to(equal(@(externalTemperature)));
            expect(testNotification.fuelLevel).to(equal(@(fuelLevel)));
            expect(testNotification.fuelLevel_State).to(equal(fuelLevel_State));
            expect(testNotification.fuelRange).to(equal(fuelRangeArray));
            expect(testNotification.gps).to(equal(gps));
            expect(testNotification.headLampStatus).to(equal(headLampStatus));
            expect(testNotification.instantFuelConsumption).to(equal(@(instantFuelConsumption)));
            expect(testNotification.myKey).to(equal(myKey));
            expect(testNotification.odometer).to(equal(@(odometer)));
            expect(testNotification.prndl).to(equal(prndl));
            expect(testNotification.rpm).to(equal(@(rpm)));
            expect(testNotification.speed).to(equal(@(speed)));
            expect(testNotification.steeringWheelAngle).to(equal(@(steeringWheelAngle)));
            expect(testNotification.tirePressure).to(equal(tirePressure));
            expect(testNotification.turnSignal).to(equal(turnSignal));
            expect(testNotification.vin).to(equal(vin));
            expect(testNotification.windowStatus).to(equal(windowStatus));
            expect(testNotification.wiperStatus).to(equal(wiperStatus));
        });
    });

    context(@"should set OEM Custom Vehicle Data", ^{
        SDLOnVehicleData *testRequest = [[SDLOnVehicleData alloc] init];
        [testRequest setOEMCustomVehicleData:@"customVehicleData" withVehicleDataState:@"oemVehicleData"];

        it(@"expect OEM Custom Vehicle Data to be set properly", ^{
            expect([testRequest getOEMCustomVehicleData:@"customVehicleData"]).to(equal(@"oemVehicleData"));
            expect(testRequest.windowStatus).to(beNil());
        });
    });
});

QuickSpecEnd
