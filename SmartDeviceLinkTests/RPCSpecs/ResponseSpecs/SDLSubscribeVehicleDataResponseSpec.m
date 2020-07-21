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


describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
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
        testResponse.fuelLevel = vehicleDataResult;
        testResponse.fuelLevel_State = vehicleDataResult;
        testResponse.fuelRange = vehicleDataResult;
        testResponse.gps = vehicleDataResult;
        testResponse.headLampStatus = vehicleDataResult;
        testResponse.instantFuelConsumption = vehicleDataResult;
        testResponse.myKey = vehicleDataResult;
        testResponse.odometer = vehicleDataResult;
        testResponse.prndl = vehicleDataResult;
        testResponse.rpm = vehicleDataResult;
        testResponse.speed = vehicleDataResult;
        testResponse.steeringWheelAngle = vehicleDataResult;
        testResponse.tirePressure = vehicleDataResult;
        testResponse.turnSignal = vehicleDataResult;
        testResponse.wiperStatus = vehicleDataResult;
        testResponse.handsOffSteering = vehicleDataResult;

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
        expect(testResponse.fuelLevel).to(equal(vehicleDataResult));
        expect(testResponse.fuelLevel_State).to(equal(vehicleDataResult));
        expect(testResponse.fuelRange).to(equal(vehicleDataResult));
        expect(testResponse.gps).to(equal(vehicleDataResult));
        expect(testResponse.headLampStatus).to(equal(vehicleDataResult));
        expect(testResponse.instantFuelConsumption).to(equal(vehicleDataResult));
        expect(testResponse.myKey).to(equal(vehicleDataResult));
        expect(testResponse.odometer).to(equal(vehicleDataResult));
        expect(testResponse.prndl).to(equal(vehicleDataResult));
        expect(testResponse.rpm).to(equal(vehicleDataResult));
        expect(testResponse.speed).to(equal(vehicleDataResult));
        expect(testResponse.steeringWheelAngle).to(equal(vehicleDataResult));
        expect(testResponse.tirePressure).to(equal(vehicleDataResult));
        expect(testResponse.turnSignal).to(equal(vehicleDataResult));
        expect(testResponse.wiperStatus).to(equal(vehicleDataResult));
        expect(testResponse.handsOffSteering).to(equal(vehicleDataResult));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSDictionary<NSString *, id> *dict = @{SDLRPCParameterNameResponse:
                                                           @{SDLRPCParameterNameParameters:
                                                                 @{SDLRPCParameterNameAccelerationPedalPosition:vehicleDataResult,
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
                                                                   SDLRPCParameterNameFuelLevel:vehicleDataResult,
                                                                   SDLRPCParameterNameFuelLevelState:vehicleDataResult,
                                                                   SDLRPCParameterNameFuelRange:vehicleDataResult,
                                                                   SDLRPCParameterNameGPS:vehicleDataResult,
                                                                   SDLRPCParameterNameHeadLampStatus:vehicleDataResult,
                                                                   SDLRPCParameterNameInstantFuelConsumption:vehicleDataResult,
                                                                   SDLRPCParameterNameMyKey:vehicleDataResult,
                                                                   SDLRPCParameterNameOdometer:vehicleDataResult,
                                                                   SDLRPCParameterNamePRNDL:vehicleDataResult,
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
        expect(testResponse.fuelLevel).to(equal(vehicleDataResult));
        expect(testResponse.fuelLevel_State).to(equal(vehicleDataResult));
        expect(testResponse.fuelRange).to(equal(vehicleDataResult));
        expect(testResponse.gps).to(equal(vehicleDataResult));
        expect(testResponse.headLampStatus).to(equal(vehicleDataResult));
        expect(testResponse.instantFuelConsumption).to(equal(vehicleDataResult));
        expect(testResponse.myKey).to(equal(vehicleDataResult));
        expect(testResponse.odometer).to(equal(vehicleDataResult));
        expect(testResponse.prndl).to(equal(vehicleDataResult));
        expect(testResponse.rpm).to(equal(vehicleDataResult));
        expect(testResponse.speed).to(equal(vehicleDataResult));
        expect(testResponse.steeringWheelAngle).to(equal(vehicleDataResult));
        expect(testResponse.tirePressure).to(equal(vehicleDataResult));
        expect(testResponse.turnSignal).to(equal(vehicleDataResult));
        expect(testResponse.wiperStatus).to(equal(vehicleDataResult));
        expect(testResponse.handsOffSteering).to(equal(vehicleDataResult));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLSubscribeVehicleDataResponse* testResponse = [[SDLSubscribeVehicleDataResponse alloc] init];
        
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
        expect(testResponse.wiperStatus).to(beNil());
        expect(testResponse.handsOffSteering).to(beNil());
    });

    it(@"Should set and get OEMCustomVehicleData", ^{
        SDLSubscribeVehicleDataResponse *testRequest = [[SDLSubscribeVehicleDataResponse alloc] init];

        [testRequest setOEMCustomVehicleData:@"customOEMVehicleData" withVehicleDataState:customOEMvehicleDataResult];

        expect([testRequest getOEMCustomVehicleData:@"customOEMVehicleData"]).to(equal(customOEMvehicleDataResult));
    });
});

describe(@"Convenience init test", ^ {
    it(@"Should set all the params to vehicleDataResult", ^{
        SDLSubscribeVehicleDataResponse *testResponse =
    [[SDLSubscribeVehicleDataResponse alloc] initWithAccPedalPosition:vehicleDataResult
                                                         airbagStatus:vehicleDataResult
                                                           beltStatus:vehicleDataResult
                                                      bodyInformation:vehicleDataResult
                                                    cloudAppVehicleID:vehicleDataResult
                                                         clusterModes:vehicleDataResult
                                                         deviceStatus:vehicleDataResult
                                                        driverBraking:vehicleDataResult
                                                            eCallInfo:vehicleDataResult
                                            electronicParkBrakeStatus:vehicleDataResult
                                                       emergencyEvent:vehicleDataResult
                                                        engineOilLife:vehicleDataResult
                                                         engineTorque:vehicleDataResult
                                                  externalTemperature:vehicleDataResult
                                                            fuelLevel:vehicleDataResult
                                                      fuelLevel_State:vehicleDataResult
                                                            fuelRange:vehicleDataResult
                                                                  gps:vehicleDataResult
                                                     handsOffSteering:vehicleDataResult
                                                       headLampStatus:vehicleDataResult
                                               instantFuelConsumption:vehicleDataResult
                                                                myKey:vehicleDataResult
                                                             odometer:vehicleDataResult
                                                                prndl:vehicleDataResult
                                                                  rpm:vehicleDataResult
                                                                speed:vehicleDataResult
                                                   steeringWheelAngle:vehicleDataResult
                                                         tirePressure:vehicleDataResult
                                                           turnSignal:vehicleDataResult
                                                          wiperStatus:vehicleDataResult];
        [testResponse setOEMCustomVehicleData:@"customOEMVehicleData" withVehicleDataState:customOEMvehicleDataResult];

        expect([testResponse getOEMCustomVehicleData:@"customOEMVehicleData"]).to(equal(customOEMvehicleDataResult));
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
        expect(testResponse.fuelLevel).to(equal(vehicleDataResult));
        expect(testResponse.fuelLevel_State).to(equal(vehicleDataResult));
        expect(testResponse.fuelRange).to(equal(vehicleDataResult));
        expect(testResponse.gps).to(equal(vehicleDataResult));
        expect(testResponse.handsOffSteering).to(equal(vehicleDataResult));
        expect(testResponse.headLampStatus).to(equal(vehicleDataResult));
        expect(testResponse.instantFuelConsumption).to(equal(vehicleDataResult));
        expect(testResponse.myKey).to(equal(vehicleDataResult));
        expect(testResponse.odometer).to(equal(vehicleDataResult));
        expect(testResponse.prndl).to(equal(vehicleDataResult));
        expect(testResponse.rpm).to(equal(vehicleDataResult));
        expect(testResponse.speed).to(equal(vehicleDataResult));
        expect(testResponse.steeringWheelAngle).to(equal(vehicleDataResult));
        expect(testResponse.tirePressure).to(equal(vehicleDataResult));
        expect(testResponse.turnSignal).to(equal(vehicleDataResult));
        expect(testResponse.wiperStatus).to(equal(vehicleDataResult));
    });
});

QuickSpecEnd
