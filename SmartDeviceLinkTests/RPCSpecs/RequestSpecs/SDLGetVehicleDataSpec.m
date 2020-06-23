//
//  SDLGetVehicleDataSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLGetVehicleData.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

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
                                                                   @"windowStatus":@YES
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

describe(@"initializers", ^{
    it(@"init", ^{
        SDLGetVehicleData* testRequest = [SDLGetVehicleData new];

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

        it(@"all set", ^{
            expect(testRequest.accPedalPosition).to(equal(@YES));
            expect(testRequest.airbagStatus).to(equal(@YES));
            expect(testRequest.beltStatus).to(equal(@YES));
            expect(testRequest.bodyInformation).to(equal(@YES));
            expect(testRequest.cloudAppVehicleID).to(equal(@NO));
            expect(testRequest.clusterModeStatus).to(equal(@YES));
            expect(testRequest.deviceStatus).to(equal(@YES));
            expect(testRequest.driverBraking).to(equal(@YES));
            expect(testRequest.eCallInfo).to(equal(@YES));
            expect(testRequest.electronicParkBrakeStatus).to(equal(@NO));
            expect(testRequest.emergencyEvent).to(equal(@YES));
            expect(testRequest.engineOilLife).to(equal(@NO));
            expect(testRequest.engineTorque).to(equal(@YES));
            expect(testRequest.externalTemperature).to(equal(@YES));
            expect(testRequest.fuelLevel).to(equal(@YES));
            expect(testRequest.fuelLevel_State).to(equal(@YES));
            expect(testRequest.fuelRange).to(equal(@NO));
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
            expect(testRequest.turnSignal).to(equal(@NO));
            expect(testRequest.wiperStatus).to(equal(@YES));
            expect(testRequest.windowStatus).to(beNil());
        });
    });
         context(@"initWithAccelerationPedalPosition:airbagStatus:beltStatus:bodyInformation:clusterModeStatus:deviceStatus:driverBraking:eCallInfo:emergencyEvent:engineOilLife:engineTorque:externalTemperature:fuelLevel:fuelLevelState:gps:headLampStatus:instantFuelConsumption:myKey:odometer:prndl:rpm:speed:steeringWheelAngle:tirePressure:wiperStatus:", ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLGetVehicleData *testRequest = [[SDLGetVehicleData alloc] initWithAccelerationPedalPosition:YES airbagStatus:YES beltStatus:YES bodyInformation:YES clusterModeStatus:YES deviceStatus:YES driverBraking:YES eCallInfo:YES electronicParkBrakeStatus:YES emergencyEvent:YES engineOilLife:YES engineTorque:YES externalTemperature:YES fuelLevel:YES fuelLevelState:YES fuelRange:YES gps:YES headLampStatus:YES instantFuelConsumption:YES myKey:YES odometer:YES prndl:YES rpm:YES speed:YES steeringWheelAngle:YES tirePressure:YES turnSignal:YES vin:YES wiperStatus:YES];
#pragma clang diagnostic pop

        it(@"all set", ^{
            expect(testRequest.accPedalPosition).to(equal(@YES));
            expect(testRequest.airbagStatus).to(equal(@YES));
            expect(testRequest.beltStatus).to(equal(@YES));
            expect(testRequest.bodyInformation).to(equal(@YES));
            expect(testRequest.cloudAppVehicleID).to(equal(@NO));
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

        it(@"all set", ^{
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


context(@"INIT-4", ^{
    SDLGetVehicleData *testRequest =
    [[SDLGetVehicleData alloc] initWithAccelerationPedalPosition:YES
                                                    airbagStatus:YES
                                                      beltStatus:YES
                                                 bodyInformation:YES
                                               cloudAppVehicleID:YES
                                               clusterModeStatus:YES
                                                    deviceStatus:YES
                                                   driverBraking:YES
                                                       eCallInfo:YES
                                       electronicParkBrakeStatus:YES
                                                  emergencyEvent:YES
                                                   engineOilLife:YES
                                                    engineTorque:YES
                                             externalTemperature:YES
                                                       fuelLevel:YES
                                                  fuelLevelState:YES
                                                       fuelRange:YES
                                                             gps:YES
                                                  headLampStatus:YES
                                          instantFuelConsumption:YES
                                                           myKey:YES
                                                        odometer:YES
                                                           prndl:YES
                                                             rpm:YES
                                                           speed:YES
                                              steeringWheelAngle:YES
                                                    tirePressure:YES
                                                      turnSignal:YES
                                                             vin:YES
                                                     wiperStatus:YES
                                                    windowStatus:YES];
        it(@"all props set to YES", ^{
             expect(testRequest.accPedalPosition).to(beTrue());
             expect(testRequest.airbagStatus).to(beTrue());
             expect(testRequest.beltStatus).to(beTrue());
             expect(testRequest.bodyInformation).to(beTrue());
             expect(testRequest.cloudAppVehicleID).to(beTrue());
             expect(testRequest.clusterModeStatus).to(beTrue());
             expect(testRequest.deviceStatus).to(beTrue());
             expect(testRequest.driverBraking).to(beTrue());
             expect(testRequest.eCallInfo).to(beTrue());
             expect(testRequest.electronicParkBrakeStatus).to(beTrue());
             expect(testRequest.emergencyEvent).to(beTrue());
             expect(testRequest.engineOilLife).to(beTrue());
             expect(testRequest.engineTorque).to(beTrue());
             expect(testRequest.externalTemperature).to(beTrue());
             expect(testRequest.fuelLevel).to(beTrue());
             expect(testRequest.fuelLevel_State).to(beTrue());
             expect(testRequest.fuelRange).to(beTrue());
             expect(testRequest.gps).to(beTrue());
             expect(testRequest.headLampStatus).to(beTrue());
             expect(testRequest.instantFuelConsumption).to(beTrue());
             expect(testRequest.myKey).to(beTrue());
             expect(testRequest.odometer).to(beTrue());
             expect(testRequest.prndl).to(beTrue());
             expect(testRequest.rpm).to(beTrue());
             expect(testRequest.speed).to(beTrue());
             expect(testRequest.steeringWheelAngle).to(beTrue());
             expect(testRequest.tirePressure).to(beTrue());
             expect(testRequest.turnSignal).to(beTrue());
             expect(testRequest.wiperStatus).to(beTrue());
             expect(testRequest.windowStatus).to(beTrue());
        });
});

         context(@"INIT-5", ^{
             SDLGetVehicleData *testRequest =
             [[SDLGetVehicleData alloc] initWithAccelerationPedalPosition:NO
                                                             airbagStatus:NO
                                                               beltStatus:NO
                                                          bodyInformation:NO
                                                        cloudAppVehicleID:NO
                                                        clusterModeStatus:NO
                                                             deviceStatus:NO
                                                            driverBraking:NO
                                                                eCallInfo:NO
                                                electronicParkBrakeStatus:NO
                                                           emergencyEvent:NO
                                                            engineOilLife:NO
                                                             engineTorque:NO
                                                      externalTemperature:NO
                                                                fuelLevel:NO
                                                           fuelLevelState:NO
                                                                fuelRange:NO
                                                                      gps:NO
                                                           headLampStatus:NO
                                                   instantFuelConsumption:NO
                                                                    myKey:NO
                                                                 odometer:NO
                                                                    prndl:NO
                                                                      rpm:NO
                                                                    speed:NO
                                                       steeringWheelAngle:NO
                                                             tirePressure:NO
                                                               turnSignal:NO
                                                                      vin:NO
                                                              wiperStatus:NO
                                                             windowStatus:NO];
                 it(@"all props set to NO", ^{
                      expect(testRequest.accPedalPosition).to(beFalse());
                      expect(testRequest.airbagStatus).to(beFalse());
                      expect(testRequest.beltStatus).to(beFalse());
                      expect(testRequest.bodyInformation).to(beFalse());
                      expect(testRequest.cloudAppVehicleID).to(beFalse());
                      expect(testRequest.clusterModeStatus).to(beFalse());
                      expect(testRequest.deviceStatus).to(beFalse());
                      expect(testRequest.driverBraking).to(beFalse());
                      expect(testRequest.eCallInfo).to(beFalse());
                      expect(testRequest.electronicParkBrakeStatus).to(beFalse());
                      expect(testRequest.emergencyEvent).to(beFalse());
                      expect(testRequest.engineOilLife).to(beFalse());
                      expect(testRequest.engineTorque).to(beFalse());
                      expect(testRequest.externalTemperature).to(beFalse());
                      expect(testRequest.fuelLevel).to(beFalse());
                      expect(testRequest.fuelLevel_State).to(beFalse());
                      expect(testRequest.fuelRange).to(beFalse());
                      expect(testRequest.gps).to(beFalse());
                      expect(testRequest.headLampStatus).to(beFalse());
                      expect(testRequest.instantFuelConsumption).to(beFalse());
                      expect(testRequest.myKey).to(beFalse());
                      expect(testRequest.odometer).to(beFalse());
                      expect(testRequest.prndl).to(beFalse());
                      expect(testRequest.rpm).to(beFalse());
                      expect(testRequest.speed).to(beFalse());
                      expect(testRequest.steeringWheelAngle).to(beFalse());
                      expect(testRequest.tirePressure).to(beFalse());
                      expect(testRequest.turnSignal).to(beFalse());
                      expect(testRequest.wiperStatus).to(beFalse());
                      expect(testRequest.windowStatus).to(beFalse());
                 });
         });

    context(@"Should set and get Generic Network Signal Data", ^{
        SDLGetVehicleData *testRequest = [SDLGetVehicleData new];
        [testRequest setOEMCustomVehicleData:@"OEMCustomVehicleData" withVehicleDataState:NO];
        [testRequest setOEMCustomVehicleData:@"OEMCustomVehicleData1" withVehicleDataState:YES];

        it(@"all set", ^{
            expect([testRequest getOEMCustomVehicleData:@"OEMCustomVehicleData"]).to(beFalse());
            expect([testRequest getOEMCustomVehicleData:@"OEMCustomVehicleData1"]).to(beTrue());
            expect(testRequest.windowStatus).to(beNil());
        });
    });
});

QuickSpecEnd
