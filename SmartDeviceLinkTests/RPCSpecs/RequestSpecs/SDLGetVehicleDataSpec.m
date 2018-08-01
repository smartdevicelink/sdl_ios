//
//  SDLGetVehicleDataSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLGetVehicleData.h"
#import "SDLNames.h"

QuickSpecBegin(SDLGetVehicleDataSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLGetVehicleData* testRequest = [[SDLGetVehicleData alloc] init];
        
        testRequest.accPedalPosition = @YES;
        testRequest.airbagStatus = @NO;
        testRequest.beltStatus = @NO;
        testRequest.bodyInformation = @YES;
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

        expect(testRequest.accPedalPosition).to(equal(@YES));
        expect(testRequest.airbagStatus).to(equal(@NO));
        expect(testRequest.beltStatus).to(equal(@NO));
        expect(testRequest.bodyInformation).to(equal(@YES));
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
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSDictionary<NSString *, id> *dict = @{SDLNameRequest:
                                                           @{SDLNameParameters:
                                                                 @{SDLNameAccelerationPedalPosition:@YES,
                                                                   SDLNameAirbagStatus:@YES,
                                                                   SDLNameBeltStatus:@YES,
                                                                   SDLNameBodyInformation:@YES,
                                                                   SDLNameClusterModeStatus:@YES,
                                                                   SDLNameDeviceStatus:@YES,
                                                                   SDLNameDriverBraking:@YES,
                                                                   SDLNameECallInfo:@YES,
                                                                   SDLNameElectronicParkBrakeStatus:@YES,
                                                                   SDLNameEmergencyEvent:@NO,
                                                                   SDLNameEngineOilLife:@YES,
                                                                   SDLNameEngineTorque:@YES,
                                                                   SDLNameExternalTemperature:@NO,
                                                                   SDLNameFuelLevel:@YES,
                                                                   SDLNameFuelLevelState:@YES,
                                                                   SDLNameFuelRange:@YES,
                                                                   SDLNameGPS:@YES,
                                                                   SDLNameHeadLampStatus:@YES,
                                                                   SDLNameInstantFuelConsumption:@YES,
                                                                   SDLNameMyKey:@YES,
                                                                   SDLNameOdometer:@YES,
                                                                   SDLNamePRNDL:@YES,
                                                                   SDLNameRPM:@YES,
                                                                   SDLNameSpeed:@YES,
                                                                   SDLNameSteeringWheelAngle:@NO,
                                                                   SDLNameTirePressure:@YES,
                                                                   SDLNameTurnSignal:@NO,
                                                                   SDLNameWiperStatus:@YES},
                                                             SDLNameOperationName:SDLNameGetVehicleData}};
        SDLGetVehicleData* testRequest = [[SDLGetVehicleData alloc] initWithDictionary:dict];
        
        expect(testRequest.accPedalPosition).to(equal(@YES));
        expect(testRequest.airbagStatus).to(equal(@YES));
        expect(testRequest.beltStatus).to(equal(@YES));
        expect(testRequest.bodyInformation).to(equal(@YES));
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
    });
});

describe(@"initializers", ^{
    context(@"init", ^{
        SDLGetVehicleData* testRequest = [[SDLGetVehicleData alloc] init];

        expect(testRequest.accPedalPosition).to(beNil());
        expect(testRequest.airbagStatus).to(beNil());
        expect(testRequest.beltStatus).to(beNil());
        expect(testRequest.bodyInformation).to(beNil());
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
    });

    context(@"initWithAccelerationPedalPosition:airbagStatus:beltStatus:bodyInformation:clusterModeStatus:deviceStatus:driverBraking:eCallInfo:emergencyEvent:engineTorque:externalTemperature:fuelLevel:fuelLevelState:gps:headLampStatus:instantFuelConsumption:myKey:odometer:prndl:rpm:speed:steeringWheelAngle:tirePressure:wiperStatus:", ^{
        SDLGetVehicleData *testRequest = [[SDLGetVehicleData alloc] initWithAccelerationPedalPosition:YES airbagStatus:NO beltStatus:YES bodyInformation:YES clusterModeStatus:YES deviceStatus:YES driverBraking:YES eCallInfo:YES emergencyEvent:YES engineTorque:YES externalTemperature:YES fuelLevel:YES fuelLevelState:YES gps:YES headLampStatus:YES instantFuelConsumption:YES myKey:YES odometer:YES prndl:YES rpm:YES speed:YES steeringWheelAngle:YES tirePressure:YES vin:YES wiperStatus:YES];

        expect(testRequest.accPedalPosition).to(equal(@YES));
        expect(testRequest.airbagStatus).to(equal(@NO));
        expect(testRequest.beltStatus).to(equal(@YES));
        expect(testRequest.bodyInformation).to(equal(@YES));
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
    });

    context(@"initWithAccelerationPedalPosition:airbagStatus:beltStatus:bodyInformation:clusterModeStatus:deviceStatus:driverBraking:eCallInfo:emergencyEvent:engineOilLife:engineTorque:externalTemperature:fuelLevel:fuelLevelState:gps:headLampStatus:instantFuelConsumption:myKey:odometer:prndl:rpm:speed:steeringWheelAngle:tirePressure:wiperStatus:", ^{
        SDLGetVehicleData *testRequest = [[SDLGetVehicleData alloc] initWithAccelerationPedalPosition:YES airbagStatus:YES beltStatus:YES bodyInformation:YES clusterModeStatus:YES deviceStatus:YES driverBraking:YES eCallInfo:YES electronicParkBrakeStatus:YES emergencyEvent:YES engineOilLife:YES engineTorque:YES externalTemperature:YES fuelLevel:YES fuelLevelState:YES fuelRange:YES gps:YES headLampStatus:YES instantFuelConsumption:YES myKey:YES odometer:YES prndl:YES rpm:YES speed:YES steeringWheelAngle:YES tirePressure:YES turnSignal:YES vin:YES wiperStatus:YES];

        expect(testRequest.accPedalPosition).to(equal(@YES));
        expect(testRequest.airbagStatus).to(equal(@YES));
        expect(testRequest.beltStatus).to(equal(@YES));
        expect(testRequest.bodyInformation).to(equal(@YES));
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
    });
});

QuickSpecEnd
