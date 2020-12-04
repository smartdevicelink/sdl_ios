//
//  SDLSubscribeVehicleDataSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLSubscribeVehicleData.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

QuickSpecBegin(SDLSubscribeVehicleDataSpec)

describe(@"getter/setter tests", ^{
    context(@"init and assign", ^{
        SDLSubscribeVehicleData* testRequest = [[SDLSubscribeVehicleData alloc] init];
        testRequest.accPedalPosition = @YES;
        testRequest.airbagStatus = @YES;
        testRequest.beltStatus = @YES;
        testRequest.bodyInformation = @YES;
        testRequest.cloudAppVehicleID = @YES;
        testRequest.clusterModeStatus = @YES;
        testRequest.deviceStatus = @YES;
        testRequest.driverBraking = @YES;
        testRequest.eCallInfo = @YES;
        testRequest.electronicParkBrakeStatus = @YES;
        testRequest.emergencyEvent = @YES;
        testRequest.engineOilLife = @YES;
        testRequest.engineTorque = @YES;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        testRequest.externalTemperature = @YES;
        testRequest.fuelLevel = @YES;
        testRequest.fuelLevel_State = @YES;
#pragma clang diagnostic pop
        testRequest.fuelRange = @YES;
        testRequest.gearStatus = @YES;
        testRequest.gps = @YES;
        testRequest.handsOffSteering = @YES;
        testRequest.headLampStatus = @YES;
        testRequest.instantFuelConsumption = @YES;
        testRequest.myKey = @YES;
        testRequest.odometer = @YES;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        testRequest.prndl = @YES;
#pragma clang diagnostic pop
        testRequest.rpm = @YES;
        testRequest.speed = @YES;
        testRequest.stabilityControlsStatus = @YES;
        testRequest.steeringWheelAngle = @YES;
        testRequest.tirePressure = @YES;
        testRequest.turnSignal = @YES;
        testRequest.windowStatus = @YES;
        testRequest.wiperStatus = @YES;

        it(@"expect all properties to be set properly", ^{
            expect(testRequest.accPedalPosition).to(equal(@YES));
            expect(testRequest.airbagStatus).to(equal(@YES));
            expect(testRequest.beltStatus).to(equal(@YES));
            expect(testRequest.bodyInformation).to(equal(@YES));
            expect(testRequest.cloudAppVehicleID).to(equal(@YES));
            expect(testRequest.clusterModeStatus).to(equal(@YES));
            expect(testRequest.deviceStatus).to(equal(@YES));
            expect(testRequest.driverBraking).to(equal(@YES));
            expect(testRequest.eCallInfo).to(equal(@YES));
            expect(testRequest.electronicParkBrakeStatus).to(equal(@YES));
            expect(testRequest.emergencyEvent).to(equal(@YES));
            expect(testRequest.engineOilLife).to(equal(@YES));
            expect(testRequest.engineTorque).to(equal(@YES));
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            expect(testRequest.externalTemperature).to(equal(@YES));
            expect(testRequest.fuelLevel).to(equal(@YES));
            expect(testRequest.fuelLevel_State).to(equal(@YES));
#pragma clang diagnostic pop
            expect(testRequest.fuelRange).to(equal(@YES));
            expect(testRequest.gearStatus).to(equal(@YES));
            expect(testRequest.gps).to(equal(@YES));
            expect(testRequest.handsOffSteering).to(equal(@YES));
            expect(testRequest.headLampStatus).to(equal(@YES));
            expect(testRequest.instantFuelConsumption).to(equal(@YES));
            expect(testRequest.myKey).to(equal(@YES));
            expect(testRequest.odometer).to(equal(@YES));
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            expect(testRequest.prndl).to(equal(@YES));
#pragma clang diagnostic pop
            expect(testRequest.rpm).to(equal(@YES));
            expect(testRequest.speed).to(equal(@YES));
            expect(testRequest.stabilityControlsStatus).to(equal(@YES));
            expect(testRequest.steeringWheelAngle).to(equal(@YES));
            expect(testRequest.tirePressure).to(equal(@YES));
            expect(testRequest.turnSignal).to(equal(@YES));
            expect(testRequest.windowStatus).to(equal(@YES));
            expect(testRequest.wiperStatus).to(equal(@YES));
        });
    });
    
    context(@"initWithDictionary:", ^{
        NSDictionary<NSString *, id> *dict = @{SDLRPCParameterNameRequest:
                                                   @{SDLRPCParameterNameParameters:@{
                                                            SDLRPCParameterNameAccelerationPedalPosition:@YES,
                                                            SDLRPCParameterNameAirbagStatus:@YES,
                                                            SDLRPCParameterNameBeltStatus:@YES,
                                                            SDLRPCParameterNameBodyInformation:@YES,
                                                            SDLRPCParameterNameCloudAppVehicleID:@YES,
                                                            SDLRPCParameterNameClusterModeStatus:@YES,
                                                            SDLRPCParameterNameDeviceStatus:@YES,
                                                            SDLRPCParameterNameDriverBraking:@YES,
                                                            SDLRPCParameterNameECallInfo:@YES,
                                                            SDLRPCParameterNameElectronicParkBrakeStatus: @YES,
                                                            SDLRPCParameterNameEmergencyEvent:@YES,
                                                            SDLRPCParameterNameEngineOilLife:@YES,
                                                            SDLRPCParameterNameEngineTorque:@YES,
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                                                            SDLRPCParameterNameExternalTemperature:@YES,
                                                            SDLRPCParameterNameFuelLevel:@YES,
                                                            SDLRPCParameterNameFuelLevelState:@YES,
#pragma clang diagnostic pop
                                                            SDLRPCParameterNameFuelRange:@YES,
                                                            SDLRPCParameterNameGearStatus:@YES,
                                                            SDLRPCParameterNameGPS:@YES,
                                                            SDLRPCParameterNameHandsOffSteering:@YES,
                                                            SDLRPCParameterNameHeadLampStatus:@YES,
                                                            SDLRPCParameterNameInstantFuelConsumption:@YES,
                                                            SDLRPCParameterNameMyKey:@YES,
                                                            SDLRPCParameterNameOdometer:@YES,
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                                                            SDLRPCParameterNamePRNDL:@YES,
#pragma clang diagnostic pop
                                                            SDLRPCParameterNameRPM:@YES,
                                                            SDLRPCParameterNameSpeed:@YES,
                                                            SDLRPCParameterNameStabilityControlsStatus:@YES,
                                                            SDLRPCParameterNameSteeringWheelAngle:@YES,
                                                            SDLRPCParameterNameTirePressure:@YES,
                                                            SDLRPCParameterNameTurnSignal:@YES,
                                                            SDLRPCParameterNameWindowStatus:@YES,
                                                            SDLRPCParameterNameWiperStatus:@YES,
                                                         },
                                                     SDLRPCParameterNameOperationName:SDLRPCFunctionNameSubscribeVehicleData}};
        SDLSubscribeVehicleData* testRequest = [[SDLSubscribeVehicleData alloc] initWithDictionary:dict];

        it(@"expect all properties to be set properly", ^{
            expect(testRequest.accPedalPosition).to(equal(@YES));
            expect(testRequest.airbagStatus).to(equal(@YES));
            expect(testRequest.beltStatus).to(equal(@YES));
            expect(testRequest.bodyInformation).to(equal(@YES));
            expect(testRequest.cloudAppVehicleID).to(equal(@YES));
            expect(testRequest.clusterModeStatus).to(equal(@YES));
            expect(testRequest.deviceStatus).to(equal(@YES));
            expect(testRequest.driverBraking).to(equal(@YES));
            expect(testRequest.eCallInfo).to(equal(@YES));
            expect(testRequest.electronicParkBrakeStatus).to(equal(@YES));
            expect(testRequest.emergencyEvent).to(equal(@YES));
            expect(testRequest.engineOilLife).to(equal(@YES));
            expect(testRequest.engineTorque).to(equal(@YES));
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            expect(testRequest.externalTemperature).to(equal(@YES));
            expect(testRequest.fuelLevel).to(equal(@YES));
            expect(testRequest.fuelLevel_State).to(equal(@YES));
#pragma clang diagnostic pop
            expect(testRequest.fuelRange).to(equal(@YES));
            expect(testRequest.gearStatus).to(equal(@YES));
            expect(testRequest.gps).to(equal(@YES));
            expect(testRequest.handsOffSteering).to(equal(@YES));
            expect(testRequest.headLampStatus).to(equal(@YES));
            expect(testRequest.instantFuelConsumption).to(equal(@YES));
            expect(testRequest.myKey).to(equal(@YES));
            expect(testRequest.odometer).to(equal(@YES));
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            expect(testRequest.prndl).to(equal(@YES));
#pragma clang diagnostic pop
            expect(testRequest.rpm).to(equal(@YES));
            expect(testRequest.speed).to(equal(@YES));
            expect(testRequest.stabilityControlsStatus).to(equal(@YES));
            expect(testRequest.steeringWheelAngle).to(equal(@YES));
            expect(testRequest.tirePressure).to(equal(@YES));
            expect(testRequest.turnSignal).to(equal(@YES));
            expect(testRequest.windowStatus).to(equal(@YES));
            expect(testRequest.wiperStatus).to(equal(@YES));
        });
    });
});

describe(@"test initializers", ^{
    context(@"init", ^{
        SDLSubscribeVehicleData* testRequest = [[SDLSubscribeVehicleData alloc] init];

        it(@"expect all properties to be nil", ^{
            expect(testRequest.accPedalPosition).to(beNil());
            expect(testRequest.airbagStatus).to(beNil());
            expect(testRequest.beltStatus).to(beNil());
            expect(testRequest.bodyInformation).to(beNil());
            expect(testRequest.cloudAppVehicleID).to(beNil());
            expect(testRequest.clusterModeStatus).to(beNil());
            expect(testRequest.deviceStatus).to(beNil());
            expect(testRequest.driverBraking).to(beNil());
            expect(testRequest.eCallInfo).to(beNil());
            expect(testRequest.electronicParkBrakeStatus).to(beNil());
            expect(testRequest.emergencyEvent).to(beNil());
            expect(testRequest.engineOilLife).to(beNil());
            expect(testRequest.engineTorque).to(beNil());
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            expect(testRequest.externalTemperature).to(beNil());
            expect(testRequest.fuelLevel).to(beNil());
            expect(testRequest.fuelLevel_State).to(beNil());
#pragma clang diagnostic pop
            expect(testRequest.fuelRange).to(beNil());
            expect(testRequest.gearStatus).to(beNil());
            expect(testRequest.gps).to(beNil());
            expect(testRequest.handsOffSteering).to(beNil());
            expect(testRequest.headLampStatus).to(beNil());
            expect(testRequest.instantFuelConsumption).to(beNil());
            expect(testRequest.myKey).to(beNil());
            expect(testRequest.odometer).to(beNil());
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            expect(testRequest.prndl).to(beNil());
#pragma clang diagnostic pop
            expect(testRequest.rpm).to(beNil());
            expect(testRequest.speed).to(beNil());
            expect(testRequest.stabilityControlsStatus).to(beNil());
            expect(testRequest.steeringWheelAngle).to(beNil());
            expect(testRequest.tirePressure).to(beNil());
            expect(testRequest.turnSignal).to(beNil());
            expect(testRequest.windowStatus).to(beNil());
            expect(testRequest.wiperStatus).to(beNil());
        });
    });

    context(@"initWithGps:speed:rpm:instantFuelConsumption:fuelRange:externalTemperature:turnSignal:gearStatus:tirePressure:odometer:beltStatus:bodyInformation:deviceStatus:driverBraking:wiperStatus:headLampStatus:engineTorque:accPedalPosition:steeringWheelAngle:engineOilLife:electronicParkBrakeStatus:cloudAppVehicleID:stabilityControlsStatus:eCallInfo:airbagStatus:emergencyEvent:clusterModeStatus:myKey:handsOffSteering:windowStatus:", ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLSubscribeVehicleData* testRequest = [[SDLSubscribeVehicleData alloc] initWithGps:@YES speed:@YES rpm:@YES instantFuelConsumption:@YES fuelRange:@YES externalTemperature:@YES turnSignal:@YES gearStatus:@YES tirePressure:@YES odometer:@YES beltStatus:@YES bodyInformation:@YES deviceStatus:@YES driverBraking:@YES wiperStatus:@YES headLampStatus:@YES engineTorque:@YES accPedalPosition:@YES steeringWheelAngle:@YES engineOilLife:@YES electronicParkBrakeStatus:@YES cloudAppVehicleID:@YES stabilityControlsStatus:@YES eCallInfo:@YES airbagStatus:@YES emergencyEvent:@YES clusterModeStatus:@YES myKey:@YES handsOffSteering:@YES windowStatus:@YES];
#pragma clang diagnostic pop

        it(@"expect all properties to be set properly", ^{
            expect(testRequest.accPedalPosition).to(equal(@YES));
            expect(testRequest.airbagStatus).to(equal(@YES));
            expect(testRequest.beltStatus).to(equal(@YES));
            expect(testRequest.bodyInformation).to(equal(@YES));
            expect(testRequest.cloudAppVehicleID).to(equal(@YES));
            expect(testRequest.clusterModeStatus).to(equal(@YES));
            expect(testRequest.deviceStatus).to(equal(@YES));
            expect(testRequest.driverBraking).to(equal(@YES));
            expect(testRequest.eCallInfo).to(equal(@YES));
            expect(testRequest.electronicParkBrakeStatus).to(equal(@YES));
            expect(testRequest.emergencyEvent).to(equal(@YES));
            expect(testRequest.engineOilLife).to(equal(@YES));
            expect(testRequest.engineTorque).to(equal(@YES));
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            expect(testRequest.externalTemperature).to(equal(@YES));
            expect(testRequest.fuelLevel).to(beNil());
            expect(testRequest.fuelLevel_State).to(beNil());
#pragma clang diagnostic pop
            expect(testRequest.fuelRange).to(equal(@YES));
            expect(testRequest.gearStatus).to(equal(@YES));
            expect(testRequest.gps).to(equal(@YES));
            expect(testRequest.handsOffSteering).to(equal(@YES));
            expect(testRequest.headLampStatus).to(equal(@YES));
            expect(testRequest.instantFuelConsumption).to(equal(@YES));
            expect(testRequest.myKey).to(equal(@YES));
            expect(testRequest.odometer).to(equal(@YES));
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            expect(testRequest.prndl).to(beNil());
#pragma clang diagnostic pop
            expect(testRequest.rpm).to(equal(@YES));
            expect(testRequest.speed).to(equal(@YES));
            expect(testRequest.stabilityControlsStatus).to(equal(@YES));
            expect(testRequest.steeringWheelAngle).to(equal(@YES));
            expect(testRequest.tirePressure).to(equal(@YES));
            expect(testRequest.turnSignal).to(equal(@YES));
            expect(testRequest.windowStatus).to(equal(@YES));
            expect(testRequest.wiperStatus).to(equal(@YES));
        });
    });

    context(@"should set OEM Custom Vehicle Data", ^{
        SDLSubscribeVehicleData *testRequest = [[SDLSubscribeVehicleData alloc] init];
        [testRequest setOEMCustomVehicleData:@"customVehicleData" withVehicleDataState:NO];
        [testRequest setOEMCustomVehicleData:@"customVehicleData1" withVehicleDataState:YES];

        it(@"expect OEM Custom Vehicle Data to be set properly", ^{
            expect([testRequest getOEMCustomVehicleData:@"customVehicleData"]).to(equal(@NO));
            expect([testRequest getOEMCustomVehicleData:@"customVehicleData1"]).to(equal(@YES));
        });
    });
});

QuickSpecEnd
