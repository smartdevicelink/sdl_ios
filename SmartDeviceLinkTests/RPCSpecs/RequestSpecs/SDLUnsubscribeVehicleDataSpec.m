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
        
        testRequest.gps = @YES;
        testRequest.speed = @YES;
        testRequest.rpm = @YES;
        testRequest.fuelLevel = @YES;
        testRequest.fuelLevel_State = @YES;
        testRequest.instantFuelConsumption = @YES;
        testRequest.externalTemperature = @YES;
        testRequest.prndl = @YES;
        testRequest.tirePressure = @YES;
        testRequest.odometer = @YES;
        testRequest.beltStatus = @YES;
        testRequest.bodyInformation = @YES;
        testRequest.deviceStatus = @YES;
        testRequest.driverBraking = @YES;
        testRequest.wiperStatus = @YES;
        testRequest.headLampStatus = @YES;
        testRequest.engineTorque = @YES;
        testRequest.accPedalPosition = @YES;
        testRequest.steeringWheelAngle = @YES;
        testRequest.eCallInfo = @YES;
        testRequest.airbagStatus = @YES;
        testRequest.emergencyEvent = @YES;
        testRequest.clusterModeStatus = @YES;
        testRequest.myKey = @YES;
        
        expect(testRequest.gps).to(equal(@YES));
        expect(testRequest.speed).to(equal(@YES));
        expect(testRequest.rpm).to(equal(@YES));
        expect(testRequest.fuelLevel).to(equal(@YES));
        expect(testRequest.fuelLevel_State).to(equal(@YES));
        expect(testRequest.instantFuelConsumption).to(equal(@YES));
        expect(testRequest.externalTemperature).to(equal(@YES));
        expect(testRequest.prndl).to(equal(@YES));
        expect(testRequest.tirePressure).to(equal(@YES));
        expect(testRequest.odometer).to(equal(@YES));
        expect(testRequest.beltStatus).to(equal(@YES));
        expect(testRequest.bodyInformation).to(equal(@YES));
        expect(testRequest.deviceStatus).to(equal(@YES));
        expect(testRequest.driverBraking).to(equal(@YES));
        expect(testRequest.wiperStatus).to(equal(@YES));
        expect(testRequest.headLampStatus).to(equal(@YES));
        expect(testRequest.engineTorque).to(equal(@YES));
        expect(testRequest.accPedalPosition).to(equal(@YES));
        expect(testRequest.steeringWheelAngle).to(equal(@YES));
        expect(testRequest.eCallInfo).to(equal(@YES));
        expect(testRequest.airbagStatus).to(equal(@YES));
        expect(testRequest.emergencyEvent).to(equal(@YES));
        expect(testRequest.clusterModeStatus).to(equal(@YES));
        expect(testRequest.myKey).to(equal(@YES));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary<NSString *, id> *dict = [@{SDLNameRequest:
                                                           @{SDLNameParameters:
                                                                 @{SDLNameGPS:@YES,
                                                                   SDLNameSpeed:@YES,
                                                                   SDLNameRPM:@YES,
                                                                   SDLNameFuelLevel:@YES,
                                                                   SDLNameFuelLevelState:@YES,
                                                                   SDLNameInstantFuelConsumption:@YES,
                                                                   SDLNameExternalTemperature:@YES,
                                                                   SDLNamePRNDL:@YES,
                                                                   SDLNameTirePressure:@YES,
                                                                   SDLNameOdometer:@YES,
                                                                   SDLNameBeltStatus:@YES,
                                                                   SDLNameBodyInformation:@YES,
                                                                   SDLNameDeviceStatus:@YES,
                                                                   SDLNameDriverBraking:@YES,
                                                                   SDLNameWiperStatus:@YES,
                                                                   SDLNameHeadLampStatus:@YES,
                                                                   SDLNameEngineTorque:@YES,
                                                                   SDLNameAccelerationPedalPosition:@YES,
                                                                   SDLNameSteeringWheelAngle:@YES,
                                                                   SDLNameECallInfo:@YES,
                                                                   SDLNameAirbagStatus:@YES,
                                                                   SDLNameEmergencyEvent:@YES,
                                                                   SDLNameClusterModeStatus:@YES,
                                                                   SDLNameMyKey:@YES},
                                                             SDLNameOperationName:SDLNameUnsubscribeVehicleData}} mutableCopy];
        SDLUnsubscribeVehicleData* testRequest = [[SDLUnsubscribeVehicleData alloc] initWithDictionary:dict];
        
        expect(testRequest.gps).to(equal(@YES));
        expect(testRequest.speed).to(equal(@YES));
        expect(testRequest.rpm).to(equal(@YES));
        expect(testRequest.fuelLevel).to(equal(@YES));
        expect(testRequest.fuelLevel_State).to(equal(@YES));
        expect(testRequest.instantFuelConsumption).to(equal(@YES));
        expect(testRequest.externalTemperature).to(equal(@YES));
        expect(testRequest.prndl).to(equal(@YES));
        expect(testRequest.tirePressure).to(equal(@YES));
        expect(testRequest.odometer).to(equal(@YES));
        expect(testRequest.beltStatus).to(equal(@YES));
        expect(testRequest.bodyInformation).to(equal(@YES));
        expect(testRequest.deviceStatus).to(equal(@YES));
        expect(testRequest.driverBraking).to(equal(@YES));
        expect(testRequest.wiperStatus).to(equal(@YES));
        expect(testRequest.headLampStatus).to(equal(@YES));
        expect(testRequest.engineTorque).to(equal(@YES));
        expect(testRequest.accPedalPosition).to(equal(@YES));
        expect(testRequest.steeringWheelAngle).to(equal(@YES));
        expect(testRequest.eCallInfo).to(equal(@YES));
        expect(testRequest.airbagStatus).to(equal(@YES));
        expect(testRequest.emergencyEvent).to(equal(@YES));
        expect(testRequest.clusterModeStatus).to(equal(@YES));
        expect(testRequest.myKey).to(equal(@YES));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLUnsubscribeVehicleData* testRequest = [[SDLUnsubscribeVehicleData alloc] init];
        
        expect(testRequest.gps).to(beNil());
        expect(testRequest.speed).to(beNil());
        expect(testRequest.rpm).to(beNil());
        expect(testRequest.fuelLevel).to(beNil());
        expect(testRequest.fuelLevel_State).to(beNil());
        expect(testRequest.instantFuelConsumption).to(beNil());
        expect(testRequest.externalTemperature).to(beNil());
        expect(testRequest.prndl).to(beNil());
        expect(testRequest.tirePressure).to(beNil());
        expect(testRequest.odometer).to(beNil());
        expect(testRequest.beltStatus).to(beNil());
        expect(testRequest.bodyInformation).to(beNil());
        expect(testRequest.deviceStatus).to(beNil());
        expect(testRequest.driverBraking).to(beNil());
        expect(testRequest.wiperStatus).to(beNil());
        expect(testRequest.headLampStatus).to(beNil());
        expect(testRequest.engineTorque).to(beNil());
        expect(testRequest.accPedalPosition).to(beNil());
        expect(testRequest.steeringWheelAngle).to(beNil());
        expect(testRequest.eCallInfo).to(beNil());
        expect(testRequest.airbagStatus).to(beNil());
        expect(testRequest.emergencyEvent).to(beNil());
        expect(testRequest.clusterModeStatus).to(beNil());
        expect(testRequest.myKey).to(beNil());
    });
});

QuickSpecEnd
