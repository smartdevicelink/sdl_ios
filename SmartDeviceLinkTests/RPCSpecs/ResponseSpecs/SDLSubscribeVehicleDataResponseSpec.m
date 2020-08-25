//
//  SDLSubscribeVehicleDataResponseSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"
#import "SDLSubscribeVehicleDataResponse.h"
#import "SDLVehicleDataResult.h"
#import "SDLVehicleDataResultCode.h"


QuickSpecBegin(SDLSubscribeVehicleDataResponseSpec)

SDLVehicleDataResult* vehicleDataResult = [[SDLVehicleDataResult alloc] init];
SDLVehicleDataResult* customOEMvehicleDataResult = [[SDLVehicleDataResult alloc] initWithCustomOEMDataType:@"customOEMVehicleData" resultCode:SDLVehicleDataResultCodeSuccess];

describe(@"getter/setter tests", ^{
    context(@"init and assign", ^{
        SDLSubscribeVehicleDataResponse* testResponse = [[SDLSubscribeVehicleDataResponse alloc] init];

        testResponse.accPedalPosition = vehicleDataResult;
        testResponse.airbagStatus = vehicleDataResult;
        testResponse.beltStatus = vehicleDataResult;
        testResponse.bodyInformation = vehicleDataResult;
        testResponse.cloudAppVehicleID = vehicleDataResult;
        testResponse.clusterModes = vehicleDataResult;
        testResponse.deviceStatus = vehicleDataResult;
        testResponse.driverBraking = vehicleDataResult;
        testResponse.eCallInfo = vehicleDataResult;
        testResponse.electronicParkBrakeStatus = vehicleDataResult;
        testResponse.emergencyEvent = vehicleDataResult;
        testResponse.engineOilLife = vehicleDataResult;
        testResponse.engineTorque = vehicleDataResult;
        testResponse.externalTemperature = vehicleDataResult;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        testResponse.fuelLevel = vehicleDataResult;
        testResponse.fuelLevel_State = vehicleDataResult;
#pragma clang diagnostic pop
        testResponse.fuelRange = vehicleDataResult;
        testResponse.gearStatus = vehicleDataResult;
        testResponse.gps = vehicleDataResult;
        testResponse.handsOffSteering = vehicleDataResult;
        testResponse.headLampStatus = vehicleDataResult;
        testResponse.instantFuelConsumption = vehicleDataResult;
        testResponse.myKey = vehicleDataResult;
        testResponse.odometer = vehicleDataResult;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        testResponse.prndl = vehicleDataResult;
#pragma clang diagnostic pop
        testResponse.rpm = vehicleDataResult;
        testResponse.speed = vehicleDataResult;
        testResponse.steeringWheelAngle = vehicleDataResult;
        testResponse.tirePressure = vehicleDataResult;
        testResponse.turnSignal = vehicleDataResult;
        testResponse.wiperStatus = vehicleDataResult;

        it(@"expect all properties to be set properly", ^{
            expect(testResponse.accPedalPosition).to(equal(vehicleDataResult));
            expect(testResponse.airbagStatus).to(equal(vehicleDataResult));
            expect(testResponse.beltStatus).to(equal(vehicleDataResult));
            expect(testResponse.bodyInformation).to(equal(vehicleDataResult));
            expect(testResponse.cloudAppVehicleID).to(equal(vehicleDataResult));
            expect(testResponse.clusterModes).to(equal(vehicleDataResult));
            expect(testResponse.deviceStatus).to(equal(vehicleDataResult));
            expect(testResponse.driverBraking).to(equal(vehicleDataResult));
            expect(testResponse.eCallInfo).to(equal(vehicleDataResult));
            expect(testResponse.electronicParkBrakeStatus).to(equal(vehicleDataResult));
            expect(testResponse.emergencyEvent).to(equal(vehicleDataResult));
            expect(testResponse.engineOilLife).to(equal(vehicleDataResult));
            expect(testResponse.engineTorque).to(equal(vehicleDataResult));
            expect(testResponse.externalTemperature).to(equal(vehicleDataResult));
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            expect(testResponse.fuelLevel).to(equal(vehicleDataResult));
            expect(testResponse.fuelLevel_State).to(equal(vehicleDataResult));
#pragma clang diagnostic pop
            expect(testResponse.fuelRange).to(equal(vehicleDataResult));
            expect(testResponse.gearStatus).to(equal(vehicleDataResult));
            expect(testResponse.gps).to(equal(vehicleDataResult));
            expect(testResponse.handsOffSteering).to(equal(vehicleDataResult));
            expect(testResponse.headLampStatus).to(equal(vehicleDataResult));
            expect(testResponse.instantFuelConsumption).to(equal(vehicleDataResult));
            expect(testResponse.myKey).to(equal(vehicleDataResult));
            expect(testResponse.odometer).to(equal(vehicleDataResult));
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            expect(testResponse.prndl).to(equal(vehicleDataResult));
#pragma clang diagnostic pop
            expect(testResponse.rpm).to(equal(vehicleDataResult));
            expect(testResponse.speed).to(equal(vehicleDataResult));
            expect(testResponse.steeringWheelAngle).to(equal(vehicleDataResult));
            expect(testResponse.tirePressure).to(equal(vehicleDataResult));
            expect(testResponse.turnSignal).to(equal(vehicleDataResult));
            expect(testResponse.wiperStatus).to(equal(vehicleDataResult));
        });
    });
    
    context(@"initWithDictionary:", ^{
        NSDictionary<NSString *, id> *dict = @{SDLRPCParameterNameResponse:
                                                    @{SDLRPCParameterNameParameters:@{
                                                            SDLRPCParameterNameAccelerationPedalPosition:vehicleDataResult,
                                                            SDLRPCParameterNameAirbagStatus:vehicleDataResult,
                                                            SDLRPCParameterNameBeltStatus:vehicleDataResult,
                                                            SDLRPCParameterNameBodyInformation:vehicleDataResult,
                                                            SDLRPCParameterNameCloudAppVehicleID:vehicleDataResult,
                                                            SDLRPCParameterNameClusterModes:vehicleDataResult,
                                                            SDLRPCParameterNameDeviceStatus:vehicleDataResult,
                                                            SDLRPCParameterNameDriverBraking:vehicleDataResult,
                                                            SDLRPCParameterNameECallInfo:vehicleDataResult,
                                                            SDLRPCParameterNameElectronicParkBrakeStatus:vehicleDataResult,
                                                            SDLRPCParameterNameEmergencyEvent:vehicleDataResult,
                                                            SDLRPCParameterNameEngineOilLife:vehicleDataResult,
                                                            SDLRPCParameterNameEngineTorque:vehicleDataResult,
                                                            SDLRPCParameterNameExternalTemperature:vehicleDataResult,
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                                                            SDLRPCParameterNameFuelLevel:vehicleDataResult,
                                                            SDLRPCParameterNameFuelLevelState:vehicleDataResult,
#pragma clang diagnostic pop
                                                            SDLRPCParameterNameFuelRange:vehicleDataResult,
                                                            SDLRPCParameterNameGearStatus:vehicleDataResult,
                                                            SDLRPCParameterNameGPS:vehicleDataResult,
                                                            SDLRPCParameterNameHeadLampStatus:vehicleDataResult,
                                                            SDLRPCParameterNameInstantFuelConsumption:vehicleDataResult,
                                                            SDLRPCParameterNameMyKey:vehicleDataResult,
                                                            SDLRPCParameterNameOdometer:vehicleDataResult,
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                                                            SDLRPCParameterNamePRNDL:vehicleDataResult,
#pragma clang diagnostic pop
                                                            SDLRPCParameterNameRPM:vehicleDataResult,
                                                            SDLRPCParameterNameSpeed:vehicleDataResult,
                                                            SDLRPCParameterNameSteeringWheelAngle:vehicleDataResult,
                                                            SDLRPCParameterNameTirePressure:vehicleDataResult,
                                                            SDLRPCParameterNameTurnSignal:vehicleDataResult,
                                                            SDLRPCParameterNameWiperStatus:vehicleDataResult,
                                                            SDLRPCParameterNameHandsOffSteering:vehicleDataResult
                                                            },
                                                SDLRPCParameterNameOperationName:SDLRPCFunctionNameSubscribeVehicleData}};
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLSubscribeVehicleDataResponse* testResponse = [[SDLSubscribeVehicleDataResponse alloc] initWithDictionary:dict];
#pragma clang diagnostic pop

                it(@"expect all properties to be set properly", ^{
                    expect(testResponse.accPedalPosition).to(equal(vehicleDataResult));
                    expect(testResponse.airbagStatus).to(equal(vehicleDataResult));
                    expect(testResponse.beltStatus).to(equal(vehicleDataResult));
                    expect(testResponse.bodyInformation).to(equal(vehicleDataResult));
                    expect(testResponse.cloudAppVehicleID).to(equal(vehicleDataResult));
                    expect(testResponse.clusterModes).to(equal(vehicleDataResult));
                    expect(testResponse.deviceStatus).to(equal(vehicleDataResult));
                    expect(testResponse.driverBraking).to(equal(vehicleDataResult));
                    expect(testResponse.eCallInfo).to(equal(vehicleDataResult));
                    expect(testResponse.electronicParkBrakeStatus).to(equal(vehicleDataResult));
                    expect(testResponse.emergencyEvent).to(equal(vehicleDataResult));
                    expect(testResponse.engineOilLife).to(equal(vehicleDataResult));
                    expect(testResponse.engineTorque).to(equal(vehicleDataResult));
                    expect(testResponse.externalTemperature).to(equal(vehicleDataResult));
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Wdeprecated-declarations"
                    expect(testResponse.fuelLevel).to(equal(vehicleDataResult));
                    expect(testResponse.fuelLevel_State).to(equal(vehicleDataResult));
        #pragma clang diagnostic pop
                    expect(testResponse.fuelRange).to(equal(vehicleDataResult));
                    expect(testResponse.gearStatus).to(equal(vehicleDataResult));
                    expect(testResponse.gps).to(equal(vehicleDataResult));
                    expect(testResponse.handsOffSteering).to(equal(vehicleDataResult));
                    expect(testResponse.headLampStatus).to(equal(vehicleDataResult));
                    expect(testResponse.instantFuelConsumption).to(equal(vehicleDataResult));
                    expect(testResponse.myKey).to(equal(vehicleDataResult));
                    expect(testResponse.odometer).to(equal(vehicleDataResult));
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Wdeprecated-declarations"
                    expect(testResponse.prndl).to(equal(vehicleDataResult));
        #pragma clang diagnostic pop
                    expect(testResponse.rpm).to(equal(vehicleDataResult));
                    expect(testResponse.speed).to(equal(vehicleDataResult));
                    expect(testResponse.steeringWheelAngle).to(equal(vehicleDataResult));
                    expect(testResponse.tirePressure).to(equal(vehicleDataResult));
                    expect(testResponse.turnSignal).to(equal(vehicleDataResult));
                    expect(testResponse.wiperStatus).to(equal(vehicleDataResult));
                });
    });
    
    context(@"init", ^{
        SDLSubscribeVehicleDataResponse* testResponse = [[SDLSubscribeVehicleDataResponse alloc] init];

        it(@"expect all properties to be nil", ^{
            expect(testResponse.accPedalPosition).to(beNil());
            expect(testResponse.airbagStatus).to(beNil());
            expect(testResponse.beltStatus).to(beNil());
            expect(testResponse.bodyInformation).to(beNil());
            expect(testResponse.cloudAppVehicleID).to(beNil());
            expect(testResponse.clusterModes).to(beNil());
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
            expect(testResponse.gearStatus).to(beNil());
            expect(testResponse.gps).to(beNil());
            expect(testResponse.handsOffSteering).to(beNil());
            expect(testResponse.headLampStatus).to(beNil());
            expect(testResponse.instantFuelConsumption).to(beNil());
            expect(testResponse.myKey).to(beNil());
            expect(testResponse.odometer).to(beNil());
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            expect(testResponse.prndl).to(beNil());
#pragma clang diagnostic pop
            expect(testResponse.rpm).to(beNil());
            expect(testResponse.speed).to(beNil());
            expect(testResponse.steeringWheelAngle).to(beNil());
            expect(testResponse.tirePressure).to(beNil());
            expect(testResponse.turnSignal).to(beNil());
            expect(testResponse.wiperStatus).to(beNil());
        });
    });

    context(@"initWithGps:speed:rpm:instantFuelConsumption:fuelRange:externalTemperature:turnSignal:prndl:tirePressure:odometer:beltStatus:bodyInformation:deviceStatus:driverBraking:wiperStatus:headLampStatus:engineTorque:accPedalPosition:steeringWheelAngle:engineOilLife:electronicParkBrakeStatus:cloudAppVehicleID:eCallInfo:airbagStatus:emergencyEvent:clusterModes:myKey:handsOffSteering:", ^{
        SDLSubscribeVehicleDataResponse *testResponse = [[SDLSubscribeVehicleDataResponse alloc] initWithGps:vehicleDataResult speed:vehicleDataResult rpm:vehicleDataResult instantFuelConsumption:vehicleDataResult fuelRange:vehicleDataResult externalTemperature:vehicleDataResult turnSignal:vehicleDataResult gearStatus:vehicleDataResult tirePressure:vehicleDataResult odometer:vehicleDataResult beltStatus:vehicleDataResult bodyInformation:vehicleDataResult deviceStatus:vehicleDataResult driverBraking:vehicleDataResult wiperStatus:vehicleDataResult headLampStatus:vehicleDataResult engineTorque:vehicleDataResult accPedalPosition:vehicleDataResult steeringWheelAngle:vehicleDataResult engineOilLife:vehicleDataResult electronicParkBrakeStatus:vehicleDataResult cloudAppVehicleID:vehicleDataResult eCallInfo:vehicleDataResult airbagStatus:vehicleDataResult emergencyEvent:vehicleDataResult clusterModes:vehicleDataResult myKey:vehicleDataResult handsOffSteering:vehicleDataResult];

        it(@"expect all properties to be set properly", ^{
            expect(testResponse.accPedalPosition).to(equal(vehicleDataResult));
            expect(testResponse.airbagStatus).to(equal(vehicleDataResult));
            expect(testResponse.beltStatus).to(equal(vehicleDataResult));
            expect(testResponse.bodyInformation).to(equal(vehicleDataResult));
            expect(testResponse.cloudAppVehicleID).to(equal(vehicleDataResult));
            expect(testResponse.clusterModes).to(equal(vehicleDataResult));
            expect(testResponse.deviceStatus).to(equal(vehicleDataResult));
            expect(testResponse.driverBraking).to(equal(vehicleDataResult));
            expect(testResponse.eCallInfo).to(equal(vehicleDataResult));
            expect(testResponse.electronicParkBrakeStatus).to(equal(vehicleDataResult));
            expect(testResponse.emergencyEvent).to(equal(vehicleDataResult));
            expect(testResponse.engineOilLife).to(equal(vehicleDataResult));
            expect(testResponse.engineTorque).to(equal(vehicleDataResult));
            expect(testResponse.externalTemperature).to(equal(vehicleDataResult));
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            expect(testResponse.fuelLevel).to(beNil());
            expect(testResponse.fuelLevel_State).to(beNil());
#pragma clang diagnostic pop
            expect(testResponse.fuelRange).to(equal(vehicleDataResult));
            expect(testResponse.gearStatus).to(equal(vehicleDataResult));
            expect(testResponse.gps).to(equal(vehicleDataResult));
            expect(testResponse.handsOffSteering).to(equal(vehicleDataResult));
            expect(testResponse.headLampStatus).to(equal(vehicleDataResult));
            expect(testResponse.instantFuelConsumption).to(equal(vehicleDataResult));
            expect(testResponse.myKey).to(equal(vehicleDataResult));
            expect(testResponse.odometer).to(equal(vehicleDataResult));
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            expect(testResponse.prndl).to(beNil());
#pragma clang diagnostic push
            expect(testResponse.rpm).to(equal(vehicleDataResult));
            expect(testResponse.speed).to(equal(vehicleDataResult));
            expect(testResponse.steeringWheelAngle).to(equal(vehicleDataResult));
            expect(testResponse.tirePressure).to(equal(vehicleDataResult));
            expect(testResponse.turnSignal).to(equal(vehicleDataResult));
            expect(testResponse.wiperStatus).to(equal(vehicleDataResult));
        });
    });

    context(@"should set OEM Custom Vehicle Data", ^{
        SDLSubscribeVehicleDataResponse* testResponse = [[SDLSubscribeVehicleDataResponse alloc] init];
        [testResponse setOEMCustomVehicleData:@"customOEMVehicleData" withVehicleDataState:customOEMvehicleDataResult];

        it(@"expect OEM Custom Vehicle Data to be set properly", ^{
            expect([testResponse getOEMCustomVehicleData:@"customOEMVehicleData"]).to(equal(customOEMvehicleDataResult));
        });
    });
});

QuickSpecEnd
