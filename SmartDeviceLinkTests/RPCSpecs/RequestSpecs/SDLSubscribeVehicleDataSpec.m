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
    it(@"should set and get correctly", ^{
        SDLSubscribeVehicleData* testRequest = [[SDLSubscribeVehicleData alloc] init];

        testRequest.accPedalPosition = @YES;
        testRequest.airbagStatus = @NO;
        testRequest.beltStatus = @NO;
        testRequest.bodyInformation = @YES;
        testRequest.cloudAppVehicleID = @YES;
        testRequest.clusterModeStatus = @NO;
        testRequest.deviceStatus = @NO;
        testRequest.driverBraking = @YES;
        testRequest.eCallInfo = @YES;
        testRequest.electronicParkBrakeStatus = @YES;
        testRequest.emergencyEvent = @YES;
        testRequest.engineOilLife = @YES;
        testRequest.engineTorque = @NO;
        testRequest.externalTemperature = @YES;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        testRequest.fuelLevel = @YES;
        testRequest.fuelLevel_State = @YES;
#pragma clang diagnostic pop
        testRequest.fuelRange = @YES;
        testRequest.gearStatus = @YES;
        testRequest.gps = @YES;
        testRequest.handsOffSteering = @YES;
        testRequest.headLampStatus = @YES;
        testRequest.instantFuelConsumption = @NO;
        testRequest.myKey = @YES;
        testRequest.odometer = @YES;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        testRequest.prndl = @YES;
#pragma clang diagnostic pop
        testRequest.gearStatus = @YES;
        testRequest.rpm = @YES;
        testRequest.speed = @NO;
        testRequest.steeringWheelAngle = @NO;
        testRequest.tirePressure = @NO;
        testRequest.turnSignal = @YES;
        testRequest.wiperStatus = @NO;

        expect(testRequest.accPedalPosition).to(equal(@YES));
        expect(testRequest.airbagStatus).to(equal(@NO));
        expect(testRequest.beltStatus).to(equal(@NO));
        expect(testRequest.bodyInformation).to(equal(@YES));
        expect(testRequest.cloudAppVehicleID).to(equal(@YES));
        expect(testRequest.clusterModeStatus).to(equal(@NO));
        expect(testRequest.deviceStatus).to(equal(@NO));
        expect(testRequest.driverBraking).to(equal(@YES));
        expect(testRequest.eCallInfo).to(equal(@YES));
        expect(testRequest.electronicParkBrakeStatus).to(equal(@YES));
        expect(testRequest.emergencyEvent).to(equal(@YES));
        expect(testRequest.engineOilLife).to(equal(@YES));
        expect(testRequest.engineTorque).to(equal(@NO));
        expect(testRequest.externalTemperature).to(equal(@YES));
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        expect(testRequest.fuelLevel).to(equal(@YES));
        expect(testRequest.fuelLevel_State).to(equal(@YES));
#pragma clang diagnostic pop
        expect(testRequest.fuelRange).to(equal(@YES));
        expect(testRequest.gearStatus).to(equal(@YES));
        expect(testRequest.gps).to(equal(@YES));
        expect(testRequest.handsOffSteering).to(equal(@YES));
        expect(testRequest.headLampStatus).to(equal(@YES));
        expect(testRequest.instantFuelConsumption).to(equal(@NO));
        expect(testRequest.myKey).to(equal(@YES));
        expect(testRequest.odometer).to(equal(@YES));
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        expect(testRequest.prndl).to(equal(@YES));
#pragma clang diagnostic pop
        expect(testRequest.gearStatus).to(equal(@YES));
        expect(testRequest.rpm).to(equal(@YES));
        expect(testRequest.speed).to(equal(@NO));
        expect(testRequest.steeringWheelAngle).to(equal(@NO));
        expect(testRequest.tirePressure).to(equal(@NO));
        expect(testRequest.turnSignal).to(equal(@YES));
        expect(testRequest.wiperStatus).to(equal(@NO));
    });
    
    it(@"should get correctly when initialized with a dictionary", ^ {
        NSDictionary<NSString *, id> *dict = @{SDLRPCParameterNameRequest:
                                                   @{SDLRPCParameterNameParameters:
                                                         @{SDLRPCParameterNameAccelerationPedalPosition:@YES,
                                                           SDLRPCParameterNameAirbagStatus:@YES,
                                                           SDLRPCParameterNameBeltStatus:@YES,
                                                           SDLRPCParameterNameBodyInformation:@YES,
                                                           SDLRPCParameterNameCloudAppVehicleID:@YES,
                                                           SDLRPCParameterNameClusterModeStatus:@YES,
                                                           SDLRPCParameterNameDeviceStatus:@YES,
                                                           SDLRPCParameterNameDriverBraking:@YES,
                                                           SDLRPCParameterNameECallInfo:@YES,
                                                           SDLRPCParameterNameElectronicParkBrakeStatus: @YES,
                                                           SDLRPCParameterNameEmergencyEvent:@NO,
                                                           SDLRPCParameterNameEngineOilLife:@YES,
                                                           SDLRPCParameterNameEngineTorque:@YES,
                                                           SDLRPCParameterNameExternalTemperature:@NO,
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
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
                                                           SDLRPCParameterNameSteeringWheelAngle:@NO,
                                                           SDLRPCParameterNameTirePressure:@YES,
                                                           SDLRPCParameterNameTurnSignal:@NO,
                                                           SDLRPCParameterNameWiperStatus:@NO,
                                                         },
                                                     SDLRPCParameterNameOperationName:SDLRPCFunctionNameSubscribeVehicleData}};
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLSubscribeVehicleData* testRequest = [[SDLSubscribeVehicleData alloc] initWithDictionary:dict];
#pragma clang diagnostic pop

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
        expect(testRequest.emergencyEvent).to(equal(@NO));
        expect(testRequest.engineOilLife).to(equal(@YES));
        expect(testRequest.engineTorque).to(equal(@YES));
        expect(testRequest.externalTemperature).to(equal(@NO));
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
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
        expect(testRequest.steeringWheelAngle).to(equal(@NO));
        expect(testRequest.tirePressure).to(equal(@YES));
        expect(testRequest.turnSignal).to(equal(@NO));
        expect(testRequest.wiperStatus).to(equal(@NO));
    });
});

describe(@"initializers", ^{
    context(@"init", ^{
        SDLSubscribeVehicleData* testRequest = [[SDLSubscribeVehicleData alloc] init];

        it(@"expect all properties to be set properly", ^{
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
            expect(testRequest.externalTemperature).to(beNil());
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
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
            expect(testRequest.steeringWheelAngle).to(beNil());
            expect(testRequest.tirePressure).to(beNil());
            expect(testRequest.turnSignal).to(beNil());
            expect(testRequest.wiperStatus).to(beNil());
        });
    });

    context(@"initWithAccelerationPedalPosition:airbagStatus:beltStatus:bodyInformation:clusterModeStatus:deviceStatus:driverBraking:eCallInfo:emergencyEvent:engineOilLife:engineTorque:externalTemperature:fuelLevel:fuelLevelState:gps:headLampStatus:instantFuelConsumption:myKey:odometer:prndl:rpm:speed:steeringWheelAngle:tirePressure:wiperStatus:", ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLSubscribeVehicleData* testRequest = [[SDLSubscribeVehicleData alloc] initWithAccelerationPedalPosition:YES airbagStatus:YES beltStatus:YES bodyInformation:YES clusterModeStatus:YES deviceStatus:YES driverBraking:YES eCallInfo:YES electronicParkBrakeStatus:YES emergencyEvent:YES engineOilLife:YES engineTorque:YES externalTemperature:YES fuelLevel:YES fuelLevelState:YES fuelRange:YES gps:YES headLampStatus:YES instantFuelConsumption:YES myKey:YES odometer:YES prndl:YES rpm:YES speed:YES steeringWheelAngle:YES tirePressure:YES turnSignal:YES wiperStatus:YES];
#pragma clang diagnostic pop

        it(@"expect all properties to be set properly", ^{
            expect(testRequest.accPedalPosition).to(equal(@YES));
            expect(testRequest.airbagStatus).to(equal(@YES));
            expect(testRequest.beltStatus).to(equal(@YES));
            expect(testRequest.bodyInformation).to(equal(@YES));
            expect(testRequest.cloudAppVehicleID).to(beNil());
            expect(testRequest.clusterModeStatus).to(equal(@YES));
            expect(testRequest.deviceStatus).to(equal(@YES));
            expect(testRequest.driverBraking).to(equal(@YES));
            expect(testRequest.eCallInfo).to(equal(@YES));
            expect(testRequest.electronicParkBrakeStatus).to(equal(@YES));
            expect(testRequest.emergencyEvent).to(equal(@YES));
            expect(testRequest.engineOilLife).to(equal(@YES));
            expect(testRequest.engineTorque).to(equal(@YES));
            expect(testRequest.externalTemperature).to(equal(@YES));
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            expect(testRequest.fuelLevel).to(equal(@YES));
            expect(testRequest.fuelLevel_State).to(equal(@YES));
#pragma clang diagnostic pop
            expect(testRequest.fuelRange).to(equal(@YES));
            expect(testRequest.gearStatus).to(beNil());
            expect(testRequest.gps).to(equal(@YES));
            expect(testRequest.handsOffSteering).to(beNil());
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
            expect(testRequest.steeringWheelAngle).to(equal(@YES));
            expect(testRequest.tirePressure).to(equal(@YES));
            expect(testRequest.turnSignal).to(equal(@YES));
            expect(testRequest.wiperStatus).to(equal(@YES));
        });
    });
    context(@"initWithAccelerationPedalPosition:airbagStatus:beltStatus:bodyInformation:clusterModeStatus:deviceStatus:driverBraking:eCallInfo:emergencyEvent:engineTorque:externalTemperature:fuelLevel:fuelLevelState:gps:headLampStatus:instantFuelConsumption:myKey:odometer:prndl:rpm:speed:steeringWheelAngle:tirePressure:wiperStatus:", ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLSubscribeVehicleData* testRequest = [[SDLSubscribeVehicleData alloc] initWithAccelerationPedalPosition:YES airbagStatus:YES beltStatus:YES bodyInformation:YES clusterModeStatus:YES deviceStatus:YES driverBraking:YES eCallInfo:YES emergencyEvent:YES engineTorque:YES externalTemperature:YES fuelLevel:YES fuelLevelState:YES gps:YES headLampStatus:YES instantFuelConsumption:YES myKey:YES odometer:YES prndl:YES rpm:YES speed:YES steeringWheelAngle:YES tirePressure:YES wiperStatus:YES];
#pragma clang diagnostic pop

        it(@"expect all properties to be set properly", ^{
            expect(testRequest.accPedalPosition).to(equal(@YES));
            expect(testRequest.airbagStatus).to(equal(@YES));
            expect(testRequest.beltStatus).to(equal(@YES));
            expect(testRequest.bodyInformation).to(equal(@YES));
            expect(testRequest.cloudAppVehicleID).to(beNil());
            expect(testRequest.clusterModeStatus).to(equal(@YES));
            expect(testRequest.deviceStatus).to(equal(@YES));
            expect(testRequest.driverBraking).to(equal(@YES));
            expect(testRequest.eCallInfo).to(equal(@YES));
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            expect(testRequest.fuelLevel).to(equal(@YES));
            expect(testRequest.fuelLevel_State).to(equal(@YES));
#pragma clang diagnostic pop
            expect(testRequest.fuelRange).to(beNil());
            expect(testRequest.gearStatus).to(beNil());
            expect(testRequest.gps).to(equal(@YES));
            expect(testRequest.handsOffSteering).to(beNil());
            expect(testRequest.electronicParkBrakeStatus).to(beNil());
            expect(testRequest.emergencyEvent).to(equal(@YES));
            expect(testRequest.engineOilLife).to(beNil());
            expect(testRequest.engineTorque).to(equal(@YES));
            expect(testRequest.externalTemperature).to(equal(@YES));
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
            expect(testRequest.steeringWheelAngle).to(equal(@YES));
            expect(testRequest.tirePressure).to(equal(@YES));
            expect(testRequest.turnSignal).to(beNil());
            expect(testRequest.wiperStatus).to(equal(@YES));
        });
    });

    context(@"initWithGps:speed:rpm:instantFuelConsumption:fuelRange:externalTemperature:turnSignal:gearStatus:tirePressure:odometer:beltStatus:bodyInformation:deviceStatus:driverBraking:wiperStatus:headLampStatus:engineTorque:accPedalPosition:steeringWheelAngle:engineOilLife:electronicParkBrakeStatus:cloudAppVehicleID:eCallInfo:airbagStatus:emergencyEvent:clusterModeStatus:myKey:handsOffSteering:", ^{
        SDLSubscribeVehicleData* testRequest = [[SDLSubscribeVehicleData alloc] initWithGps:@YES speed:@YES rpm:@YES instantFuelConsumption:@YES fuelRange:@YES externalTemperature:@YES turnSignal:@YES gearStatus:@YES tirePressure:@YES odometer:@YES beltStatus:@YES bodyInformation:@YES deviceStatus:@YES driverBraking:@YES wiperStatus:@YES headLampStatus:@YES engineTorque:@YES accPedalPosition:@YES steeringWheelAngle:@YES engineOilLife:@YES electronicParkBrakeStatus:@YES cloudAppVehicleID:@YES eCallInfo:@YES airbagStatus:@YES emergencyEvent:@YES clusterModeStatus:@YES myKey:@YES handsOffSteering:@YES];

        it(@"should set all the parameters properly", ^{
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
            expect(testRequest.externalTemperature).to(equal(@YES));
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
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
            expect(testRequest.steeringWheelAngle).to(equal(@YES));
            expect(testRequest.tirePressure).to(equal(@YES));
            expect(testRequest.turnSignal).to(equal(@YES));
            expect(testRequest.wiperStatus).to(equal(@YES));
        });
    });

    context(@"should set and get OEM Custom Vehicle Data", ^{
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
