//
//  SDLGetVehicleDataSpec.m
//  SmartDeviceLink

#import <Foundation/Foundation.h>
#import <Nimble/Nimble.h>
#import <Quick/Quick.h>

#import "SDLGetVehicleData.h"
#import "SDLRPCFunctionNames.h"
#import "SDLRPCParameterNames.h"

QuickSpecBegin(SDLGetVehicleDataSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLGetVehicleData* testRequest = [[SDLGetVehicleData alloc] init];
        
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
        testRequest.fuelLevel = @NO;
        testRequest.fuelLevel_State = @YES;
        testRequest.fuelRange = @YES;
        testRequest.gps = @NO;
        testRequest.headLampStatus = @YES;
        testRequest.instantFuelConsumption = @NO;
        testRequest.myKey = @YES;
        testRequest.odometer = @YES;
        testRequest.prndl = @YES;
        testRequest.rpm = @YES;
        testRequest.speed = @NO;
        testRequest.steeringWheelAngle = @NO;
        testRequest.tirePressure = @NO;
        testRequest.turnSignal = @YES;
        testRequest.wiperStatus = @NO;
        testRequest.windowStatus = @YES;

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
        expect(testRequest.fuelLevel).to(equal(@NO));
        expect(testRequest.fuelLevel_State).to(equal(@YES));
        expect(testRequest.fuelRange).to(equal(@YES));
        expect(testRequest.gps).to(equal(@NO));
        expect(testRequest.headLampStatus).to(equal(@YES));
        expect(testRequest.instantFuelConsumption).to(equal(@NO));
        expect(testRequest.myKey).to(equal(@YES));
        expect(testRequest.odometer).to(equal(@YES));
        expect(testRequest.prndl).to(equal(@YES));
        expect(testRequest.rpm).to(equal(@YES));
        expect(testRequest.speed).to(equal(@NO));
        expect(testRequest.steeringWheelAngle).to(equal(@NO));
        expect(testRequest.tirePressure).to(equal(@NO));
        expect(testRequest.turnSignal).to(equal(@YES));
        expect(testRequest.wiperStatus).to(equal(@NO));
        expect(testRequest.windowStatus).to(equal(@YES));
    });
    
    it(@"Should get correctly when initialized", ^ {
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
                                                                   SDLRPCParameterNameElectronicParkBrakeStatus:@YES,
                                                                   SDLRPCParameterNameEmergencyEvent:@NO,
                                                                   SDLRPCParameterNameEngineOilLife:@YES,
                                                                   SDLRPCParameterNameEngineTorque:@YES,
                                                                   SDLRPCParameterNameExternalTemperature:@NO,
                                                                   SDLRPCParameterNameFuelLevel:@YES,
                                                                   SDLRPCParameterNameFuelLevelState:@YES,
                                                                   SDLRPCParameterNameFuelRange:@YES,
                                                                   SDLRPCParameterNameGPS:@YES,
                                                                   SDLRPCParameterNameHeadLampStatus:@YES,
                                                                   SDLRPCParameterNameInstantFuelConsumption:@YES,
                                                                   SDLRPCParameterNameMyKey:@YES,
                                                                   SDLRPCParameterNameOdometer:@YES,
                                                                   SDLRPCParameterNamePRNDL:@YES,
                                                                   SDLRPCParameterNameRPM:@YES,
                                                                   SDLRPCParameterNameSpeed:@YES,
                                                                   SDLRPCParameterNameSteeringWheelAngle:@NO,
                                                                   SDLRPCParameterNameTirePressure:@YES,
                                                                   SDLRPCParameterNameTurnSignal:@NO,
                                                                   SDLRPCParameterNameWiperStatus:@YES,
                                                                   SDLRPCParameterNameWindowStatus:@YES
                                                                 },
                                                             SDLRPCParameterNameOperationName:SDLRPCFunctionNameGetVehicleData}};
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLGetVehicleData* testRequest = [[SDLGetVehicleData alloc] initWithDictionary:dict];
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
        expect(testRequest.fuelLevel).to(equal(@YES));
        expect(testRequest.fuelLevel_State).to(equal(@YES));
        expect(testRequest.fuelRange).to(equal(@YES));
        expect(testRequest.gps).to(equal(@YES));
        expect(testRequest.headLampStatus).to(equal(@YES));
        expect(testRequest.instantFuelConsumption).to(equal(@YES));
        expect(testRequest.myKey).to(equal(@YES));
        expect(testRequest.odometer).to(equal(@YES));
        expect(testRequest.prndl).to(equal(@YES));
        expect(testRequest.rpm).to(equal(@YES));
        expect(testRequest.speed).to(equal(@YES));
        expect(testRequest.steeringWheelAngle).to(equal(@NO));
        expect(testRequest.tirePressure).to(equal(@YES));
        expect(testRequest.turnSignal).to(equal(@NO));
        expect(testRequest.wiperStatus).to(equal(@YES));
        expect(testRequest.windowStatus).to(equal(@YES));
    });
});

describe(@"Test initializers", ^{
    it(@"expect all properties to be nil", ^{
        SDLGetVehicleData* testRequest = [[SDLGetVehicleData alloc] init];

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
        expect(testRequest.fuelLevel).to(beNil());
        expect(testRequest.fuelLevel_State).to(beNil());
        expect(testRequest.fuelRange).to(beNil());
        expect(testRequest.gps).to(beNil());
        expect(testRequest.headLampStatus).to(beNil());
        expect(testRequest.instantFuelConsumption).to(beNil());
        expect(testRequest.myKey).to(beNil());
        expect(testRequest.odometer).to(beNil());
        expect(testRequest.prndl).to(beNil());
        expect(testRequest.rpm).to(beNil());
        expect(testRequest.speed).to(beNil());
        expect(testRequest.steeringWheelAngle).to(beNil());
        expect(testRequest.tirePressure).to(beNil());
        expect(testRequest.turnSignal).to(beNil());
        expect(testRequest.wiperStatus).to(beNil());
        expect(testRequest.windowStatus).to(beNil());
    });
    context(@"initWithAccelerationPedalPosition:airbagStatus:beltStatus:bodyInformation:clusterModeStatus:deviceStatus:driverBraking:eCallInfo:emergencyEvent:engineTorque:externalTemperature:fuelLevel:fuelLevelState:gps:headLampStatus:instantFuelConsumption:myKey:odometer:prndl:rpm:speed:steeringWheelAngle:tirePressure:wiperStatus:windowStatus:", ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    SDLGetVehicleData *testRequest = [[SDLGetVehicleData alloc] initWithAccelerationPedalPosition:YES airbagStatus:YES beltStatus:YES bodyInformation:YES clusterModeStatus:YES deviceStatus:YES driverBraking:YES eCallInfo:YES emergencyEvent:YES engineTorque:YES externalTemperature:YES fuelLevel:YES fuelLevelState:YES gps:YES headLampStatus:YES instantFuelConsumption:YES myKey:YES odometer:YES prndl:YES rpm:YES speed:YES steeringWheelAngle:YES tirePressure:YES vin:YES wiperStatus:YES];
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
            expect(testRequest.electronicParkBrakeStatus).to(beNil());
            expect(testRequest.emergencyEvent).to(equal(@YES));
            expect(testRequest.engineOilLife).to(beNil());
            expect(testRequest.engineTorque).to(equal(@YES));
            expect(testRequest.externalTemperature).to(equal(@YES));
            expect(testRequest.fuelLevel).to(equal(@YES));
            expect(testRequest.fuelLevel_State).to(equal(@YES));
            expect(testRequest.fuelRange).to(beNil());
            expect(testRequest.gps).to(equal(@YES));
            expect(testRequest.headLampStatus).to(equal(@YES));
            expect(testRequest.instantFuelConsumption).to(equal(@YES));
            expect(testRequest.myKey).to(equal(@YES));
            expect(testRequest.odometer).to(equal(@YES));
            expect(testRequest.prndl).to(equal(@YES));
            expect(testRequest.rpm).to(equal(@YES));
            expect(testRequest.speed).to(equal(@YES));
            expect(testRequest.steeringWheelAngle).to(equal(@YES));
            expect(testRequest.tirePressure).to(equal(@YES));
            expect(testRequest.turnSignal).to(beNil());
            expect(testRequest.wiperStatus).to(equal(@YES));
            expect(testRequest.windowStatus).to(beNil());
        });
    });
    context(@"initWithAccelerationPedalPosition:airbagStatus:beltStatus:bodyInformation:clusterModeStatus:deviceStatus:driverBraking:eCallInfo:emergencyEvent:engineOilLife:engineTorque:externalTemperature:fuelLevel:fuelLevelState:gps:headLampStatus:instantFuelConsumption:myKey:odometer:prndl:rpm:speed:steeringWheelAngle:tirePressure:wiperStatus:", ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLGetVehicleData *testRequest = [[SDLGetVehicleData alloc] initWithAccelerationPedalPosition:YES airbagStatus:YES beltStatus:YES bodyInformation:YES clusterModeStatus:YES deviceStatus:YES driverBraking:YES eCallInfo:YES electronicParkBrakeStatus:YES emergencyEvent:YES engineOilLife:YES engineTorque:YES externalTemperature:YES fuelLevel:YES fuelLevelState:YES fuelRange:YES gps:YES headLampStatus:YES instantFuelConsumption:YES myKey:YES odometer:YES prndl:YES rpm:YES speed:YES steeringWheelAngle:YES tirePressure:YES turnSignal:YES vin:YES wiperStatus:YES];
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
            expect(testRequest.fuelLevel).to(equal(@YES));
            expect(testRequest.fuelLevel_State).to(equal(@YES));
            expect(testRequest.fuelRange).to(equal(@YES));
            expect(testRequest.gps).to(equal(@YES));
            expect(testRequest.headLampStatus).to(equal(@YES));
            expect(testRequest.instantFuelConsumption).to(equal(@YES));
            expect(testRequest.myKey).to(equal(@YES));
            expect(testRequest.odometer).to(equal(@YES));
            expect(testRequest.prndl).to(equal(@YES));
            expect(testRequest.rpm).to(equal(@YES));
            expect(testRequest.speed).to(equal(@YES));
            expect(testRequest.steeringWheelAngle).to(equal(@YES));
            expect(testRequest.tirePressure).to(equal(@YES));
            expect(testRequest.turnSignal).to(equal(@YES));
            expect(testRequest.wiperStatus).to(equal(@YES));
            expect(testRequest.windowStatus).to(beNil());
        });
    });
    context(@"initWithAccelerationPedalPosition:airbagStatus:beltStatus:bodyInformation:cloudAppVehicleID:clusterModeStatus:deviceStatus:driverBraking:eCallInfo:emergencyEvent:engineOilLife:engineTorque:externalTemperature:fuelLevel:fuelLevelState:gps:headLampStatus:instantFuelConsumption:myKey:odometer:prndl:rpm:speed:steeringWheelAngle:tirePressure:wiperStatus:", ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLGetVehicleData *testRequest = [[SDLGetVehicleData alloc] initWithAccelerationPedalPosition:YES airbagStatus:YES beltStatus:YES bodyInformation:YES cloudAppVehicleID:YES clusterModeStatus:YES deviceStatus:YES driverBraking:YES eCallInfo:YES electronicParkBrakeStatus:YES emergencyEvent:YES engineOilLife:YES engineTorque:YES externalTemperature:YES fuelLevel:YES fuelLevelState:YES fuelRange:YES gps:YES headLampStatus:YES instantFuelConsumption:YES myKey:YES odometer:YES prndl:YES rpm:YES speed:YES steeringWheelAngle:YES tirePressure:YES turnSignal:YES vin:YES wiperStatus:YES];
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
            expect(testRequest.externalTemperature).to(equal(@YES));
            expect(testRequest.fuelLevel).to(equal(@YES));
            expect(testRequest.fuelLevel_State).to(equal(@YES));
            expect(testRequest.fuelRange).to(equal(@YES));
            expect(testRequest.gps).to(equal(@YES));
            expect(testRequest.headLampStatus).to(equal(@YES));
            expect(testRequest.instantFuelConsumption).to(equal(@YES));
            expect(testRequest.myKey).to(equal(@YES));
            expect(testRequest.odometer).to(equal(@YES));
            expect(testRequest.prndl).to(equal(@YES));
            expect(testRequest.rpm).to(equal(@YES));
            expect(testRequest.speed).to(equal(@YES));
            expect(testRequest.steeringWheelAngle).to(equal(@YES));
            expect(testRequest.tirePressure).to(equal(@YES));
            expect(testRequest.turnSignal).to(equal(@YES));
            expect(testRequest.wiperStatus).to(equal(@YES));
            expect(testRequest.windowStatus).to(beNil());
        });
    });

    context(@"Test initializer: initWithGps:speed:rpm:fuelLevel:fuelLevel_State:instantFuelConsumption:fuelRange:externalTemperature:turnSignal:vin:prndl:tirePressure:odometer:beltStatus:bodyInformation:deviceStatus:driverBraking:wiperStatus:headLampStatus:engineTorque:accPedalPosition:steeringWheelAngle:engineOilLife:electronicParkBrakeStatus:cloudAppVehicleID:eCallInfo:airbagStatus:emergencyEvent:clusterModeStatus:myKey:windowStatus:", ^{
        SDLGetVehicleData *testRequest = [[SDLGetVehicleData alloc] initWithGps:@YES speed:@YES rpm:@YES fuelLevel:@YES fuelLevel_State:@YES instantFuelConsumption:@YES fuelRange:@YES externalTemperature:@YES turnSignal:@YES vin:@YES prndl:@YES tirePressure:@YES odometer:@YES beltStatus:@YES bodyInformation:@YES deviceStatus:@YES driverBraking:@YES wiperStatus:@YES headLampStatus:@YES engineTorque:@YES accPedalPosition:@YES steeringWheelAngle:@YES engineOilLife:@YES electronicParkBrakeStatus:@YES cloudAppVehicleID:@YES eCallInfo:@YES airbagStatus:@YES emergencyEvent:@YES clusterModeStatus:@YES myKey:@YES windowStatus:@YES];
        it(@"expect all properties to be set to YES", ^{
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
             expect(testRequest.fuelLevel).to(equal(@YES));
             expect(testRequest.fuelLevel_State).to(equal(@YES));
             expect(testRequest.fuelRange).to(equal(@YES));
             expect(testRequest.gps).to(equal(@YES));
             expect(testRequest.headLampStatus).to(equal(@YES));
             expect(testRequest.instantFuelConsumption).to(equal(@YES));
             expect(testRequest.myKey).to(equal(@YES));
             expect(testRequest.odometer).to(equal(@YES));
             expect(testRequest.prndl).to(equal(@YES));
             expect(testRequest.rpm).to(equal(@YES));
             expect(testRequest.speed).to(equal(@YES));
             expect(testRequest.steeringWheelAngle).to(equal(@YES));
             expect(testRequest.tirePressure).to(equal(@YES));
             expect(testRequest.turnSignal).to(equal(@YES));
             expect(testRequest.wiperStatus).to(equal(@YES));
             expect(testRequest.windowStatus).to(equal(@YES));
        });
    });

    context(@"Test initializer: initWithGps:speed:rpm:fuelLevel:fuelLevel_State:instantFuelConsumption:fuelRange:externalTemperature:turnSignal:vin:prndl:tirePressure:odometer:beltStatus:bodyInformation:deviceStatus:driverBraking:wiperStatus:headLampStatus:engineTorque:accPedalPosition:steeringWheelAngle:engineOilLife:electronicParkBrakeStatus:cloudAppVehicleID:eCallInfo:airbagStatus:emergencyEvent:clusterModeStatus:myKey:windowStatus:", ^{
        SDLGetVehicleData *testRequest = [[SDLGetVehicleData alloc] initWithGps:@NO speed:@NO rpm:@NO fuelLevel:@NO fuelLevel_State:@NO instantFuelConsumption:@NO fuelRange:@NO externalTemperature:@NO turnSignal:@NO vin:@NO prndl:@NO tirePressure:@NO odometer:@NO beltStatus:@NO bodyInformation:@NO deviceStatus:@NO driverBraking:@NO wiperStatus:@NO headLampStatus:@NO engineTorque:@NO accPedalPosition:@NO steeringWheelAngle:@NO engineOilLife:@NO electronicParkBrakeStatus:@NO cloudAppVehicleID:@NO eCallInfo:@NO airbagStatus:@NO emergencyEvent:@NO clusterModeStatus:@NO myKey:@NO windowStatus:@NO];
        it(@"expect all properties to be set to NO", ^{
                      expect(testRequest.accPedalPosition).to(equal(@NO));
                      expect(testRequest.airbagStatus).to(equal(@NO));
                      expect(testRequest.beltStatus).to(equal(@NO));
                      expect(testRequest.bodyInformation).to(equal(@NO));
                      expect(testRequest.cloudAppVehicleID).to(equal(@NO));
                      expect(testRequest.clusterModeStatus).to(equal(@NO));
                      expect(testRequest.deviceStatus).to(equal(@NO));
                      expect(testRequest.driverBraking).to(equal(@NO));
                      expect(testRequest.eCallInfo).to(equal(@NO));
                      expect(testRequest.electronicParkBrakeStatus).to(equal(@NO));
                      expect(testRequest.emergencyEvent).to(equal(@NO));
                      expect(testRequest.engineOilLife).to(equal(@NO));
                      expect(testRequest.engineTorque).to(equal(@NO));
                      expect(testRequest.externalTemperature).to(equal(@NO));
                      expect(testRequest.fuelLevel).to(equal(@NO));
                      expect(testRequest.fuelLevel_State).to(equal(@NO));
                      expect(testRequest.fuelRange).to(equal(@NO));
                      expect(testRequest.gps).to(equal(@NO));
                      expect(testRequest.headLampStatus).to(equal(@NO));
                      expect(testRequest.instantFuelConsumption).to(equal(@NO));
                      expect(testRequest.myKey).to(equal(@NO));
                      expect(testRequest.odometer).to(equal(@NO));
                      expect(testRequest.prndl).to(equal(@NO));
                      expect(testRequest.rpm).to(equal(@NO));
                      expect(testRequest.speed).to(equal(@NO));
                      expect(testRequest.steeringWheelAngle).to(equal(@NO));
                      expect(testRequest.tirePressure).to(equal(@NO));
                      expect(testRequest.turnSignal).to(equal(@NO));
                      expect(testRequest.wiperStatus).to(equal(@NO));
                      expect(testRequest.windowStatus).to(equal(@NO));
        });
    });

    context(@"Should set and get OEM Custom Vehicle Data", ^{
        SDLGetVehicleData *testRequest = [[SDLGetVehicleData alloc] init];
        [testRequest setOEMCustomVehicleData:@"OEMCustomVehicleData" withVehicleDataState:NO];
        [testRequest setOEMCustomVehicleData:@"OEMCustomVehicleData1" withVehicleDataState:YES];

        it(@"expect all properties to be set properly", ^{
            expect([testRequest getOEMCustomVehicleData:@"OEMCustomVehicleData"]).to(equal(@NO));
            expect([testRequest getOEMCustomVehicleData:@"OEMCustomVehicleData1"]).to(equal(@YES));
            expect(testRequest.windowStatus).to(beNil());
        });
    });
});

QuickSpecEnd
