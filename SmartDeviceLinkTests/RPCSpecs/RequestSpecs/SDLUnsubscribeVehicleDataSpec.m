//
//  SDLUnsubscribeVehicleDataSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLUnsubscribeVehicleData.h"
#import "SDLNames.h"

QuickSpecBegin(SDLUnsubscribeVehicleDataSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLUnsubscribeVehicleData* testRequest = [[SDLUnsubscribeVehicleData alloc] init];
        
        testRequest.accPedalPosition = @YES;
        testRequest.airbagStatus = @YES;
        testRequest.beltStatus = @YES;
        testRequest.bodyInformation = @YES;
        testRequest.clusterModeStatus = @YES;
        testRequest.deviceStatus = @YES;
        testRequest.driverBraking = @YES;
        testRequest.eCallInfo = @YES;
        testRequest.electronicParkBrakeStatus = @YES;
        testRequest.emergencyEvent = @YES;
        testRequest.engineOilLife = @YES;
        testRequest.engineTorque = @YES;
        testRequest.externalTemperature = @YES;
        testRequest.fuelLevel = @YES;
        testRequest.fuelLevel_State = @YES;
        testRequest.fuelRange = @YES;
        testRequest.gps = @YES;
        testRequest.headLampStatus = @YES;
        testRequest.instantFuelConsumption = @YES;
        testRequest.myKey = @YES;
        testRequest.odometer = @YES;
        testRequest.prndl = @YES;
        testRequest.rpm = @YES;
        testRequest.speed = @YES;
        testRequest.steeringWheelAngle = @YES;
        testRequest.tirePressure = @YES;
        testRequest.turnSignal = @NO;
        testRequest.wiperStatus = @YES;

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
        expect(testRequest.turnSignal).to(equal(@NO));
        expect(testRequest.wiperStatus).to(equal(@YES));
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
                                                           SDLNameElectronicParkBrakeStatus: @YES,
                                                           SDLNameEmergencyEvent:@YES,
                                                           SDLNameEngineOilLife:@YES,
                                                           SDLNameEngineTorque:@YES,
                                                           SDLNameExternalTemperature:@YES,
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
                                                           SDLNameSteeringWheelAngle:@YES,
                                                           SDLNameTirePressure:@YES,
                                                           SDLNameTurnSignal:@YES,
                                                           SDLNameWiperStatus:@YES},
                                                     SDLNameOperationName:SDLNameUnsubscribeVehicleData}};
        SDLUnsubscribeVehicleData* testRequest = [[SDLUnsubscribeVehicleData alloc] initWithDictionary:dict];
        
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

describe(@"initializers", ^{
    context(@"init", ^{
        SDLUnsubscribeVehicleData *testRequest = [[SDLUnsubscribeVehicleData alloc] init];

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

    context(@"initWithAccelerationPedalPosition:airbagStatus:beltStatus:bodyInformation:clusterModeStatus:deviceStatus:driverBraking:eCallInfo:electronicParkBrakeStatus:emergencyEvent:engineOilLife:engineTorque:externalTemperature:fuelLevel:fuelLevelState:gps:headLampStatus:instantFuelConsumption:myKey:odometer:prndl:rpm:speed:steeringWheelAngle:tirePressure:turnSignal:wiperStatus:", ^{
        SDLUnsubscribeVehicleData *testRequest = [[SDLUnsubscribeVehicleData alloc] initWithAccelerationPedalPosition:YES airbagStatus:YES beltStatus:YES bodyInformation:YES clusterModeStatus:YES deviceStatus:YES driverBraking:YES eCallInfo:YES electronicParkBrakeStatus:YES emergencyEvent:YES engineOilLife:YES engineTorque:YES externalTemperature:YES fuelLevel:YES fuelLevelState:YES fuelRange:YES gps:YES headLampStatus:YES instantFuelConsumption:YES myKey:YES odometer:YES prndl:YES rpm:YES speed:YES steeringWheelAngle:YES tirePressure:YES turnSignal:YES wiperStatus:YES];

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

    context(@"initWithAccelerationPedalPosition:airbagStatus:beltStatus:bodyInformation:clusterModeStatus:deviceStatus:driverBraking:eCallInfo:emergencyEvent:engineTorque:externalTemperature:fuelLevel:fuelLevelState:gps:headLampStatus:instantFuelConsumption:myKey:odometer:prndl:rpm:speed:steeringWheelAngle:tirePressure:wiperStatus:", ^{
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLUnsubscribeVehicleData *testRequest = [[SDLUnsubscribeVehicleData alloc] initWithAccelerationPedalPosition:YES airbagStatus:YES beltStatus:YES bodyInformation:YES clusterModeStatus:YES deviceStatus:YES driverBraking:YES eCallInfo:YES emergencyEvent:YES engineTorque:YES externalTemperature:YES fuelLevel:YES fuelLevelState:YES gps:YES headLampStatus:NO instantFuelConsumption:YES myKey:YES odometer:YES prndl:YES rpm:YES speed:YES steeringWheelAngle:YES tirePressure:YES wiperStatus:YES];

        expect(testRequest.accPedalPosition).to(equal(@YES));
        expect(testRequest.airbagStatus).to(equal(@YES));
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
        expect(testRequest.headLampStatus).to(equal(@NO));
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
        #pragma clang diagnostic pop
    });
});

QuickSpecEnd
