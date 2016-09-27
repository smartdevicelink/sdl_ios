//
//  SDLSubscribeVehicleDataSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLSubscribeVehicleData.h"
#import "SDLNames.h"

QuickSpecBegin(SDLSubscribeVehicleDataSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLSubscribeVehicleData* testRequest = [[SDLSubscribeVehicleData alloc] init];
        
        testRequest.gps = @YES;
        testRequest.speed = @NO;
        testRequest.rpm = @YES;
        testRequest.fuelLevel = @NO;
        testRequest.fuelLevel_State = @YES;
        testRequest.instantFuelConsumption = @NO;
        testRequest.externalTemperature = @YES;
        testRequest.prndl = @YES;
        testRequest.tirePressure = @NO;
        testRequest.odometer = @YES;
        testRequest.beltStatus = @NO;
        testRequest.bodyInformation = @YES;
        testRequest.deviceStatus = @NO;
        testRequest.driverBraking = @YES;
        testRequest.wiperStatus = @NO;
        testRequest.headLampStatus = @YES;
        testRequest.engineTorque = @NO;
        testRequest.accPedalPosition = @YES;
        testRequest.steeringWheelAngle = @NO;
        testRequest.eCallInfo = @YES;
        testRequest.airbagStatus = @NO;
        testRequest.emergencyEvent = @YES;
        testRequest.clusterModeStatus = @NO;
        testRequest.myKey = @YES;
        
        expect(testRequest.gps).to(equal(@YES));
        expect(testRequest.speed).to(equal(@NO));
        expect(testRequest.rpm).to(equal(@YES));
        expect(testRequest.fuelLevel).to(equal(@NO));
        expect(testRequest.fuelLevel_State).to(equal(@YES));
        expect(testRequest.instantFuelConsumption).to(equal(@NO));
        expect(testRequest.externalTemperature).to(equal(@YES));
        expect(testRequest.prndl).to(equal(@YES));
        expect(testRequest.tirePressure).to(equal(@NO));
        expect(testRequest.odometer).to(equal(@YES));
        expect(testRequest.beltStatus).to(equal(@NO));
        expect(testRequest.bodyInformation).to(equal(@YES));
        expect(testRequest.deviceStatus).to(equal(@NO));
        expect(testRequest.driverBraking).to(equal(@YES));
        expect(testRequest.wiperStatus).to(equal(@NO));
        expect(testRequest.headLampStatus).to(equal(@YES));
        expect(testRequest.engineTorque).to(equal(@NO));
        expect(testRequest.accPedalPosition).to(equal(@YES));
        expect(testRequest.steeringWheelAngle).to(equal(@NO));
        expect(testRequest.eCallInfo).to(equal(@YES));
        expect(testRequest.airbagStatus).to(equal(@NO));
        expect(testRequest.emergencyEvent).to(equal(@YES));
        expect(testRequest.clusterModeStatus).to(equal(@NO));
        expect(testRequest.myKey).to(equal(@YES));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary<NSString *, id> *dict = [@{SDLNameRequest:
                                                           @{SDLNameParameters:
                                                                 @{SDLNameGPS:@YES,
                                                                   SDLNameSpeed:@NO,
                                                                   SDLNameRPM:@YES,
                                                                   SDLNameFuelLevel:@NO,
                                                                   SDLNameFuelLevelState:@YES,
                                                                   SDLNameInstantFuelConsumption:@NO,
                                                                   SDLNameExternalTemperature:@YES,
                                                                   SDLNamePRNDL:@YES,
                                                                   SDLNameTirePressure:@NO,
                                                                   SDLNameOdometer:@YES,
                                                                   SDLNameBeltStatus:@NO,
                                                                   SDLNameBodyInformation:@YES,
                                                                   SDLNameDeviceStatus:@NO,
                                                                   SDLNameDriverBraking:@YES,
                                                                   SDLNameWiperStatus:@NO,
                                                                   SDLNameHeadLampStatus:@YES,
                                                                   SDLNameEngineTorque:@NO,
                                                                   SDLNameAccelerationPedalPosition:@YES,
                                                                   SDLNameSteeringWheelAngle:@NO,
                                                                   SDLNameECallInfo:@YES,
                                                                   SDLNameAirbagStatus:@NO,
                                                                   SDLNameEmergencyEvent:@YES,
                                                                   SDLNameClusterModeStatus:@NO,
                                                                   SDLNameMyKey:@YES},
                                                             SDLNameOperationName:SDLNameSubscribeVehicleData}} mutableCopy];
        SDLSubscribeVehicleData* testRequest = [[SDLSubscribeVehicleData alloc] initWithDictionary:dict];
        
        expect(testRequest.gps).to(equal(@YES));
        expect(testRequest.speed).to(equal(@NO));
        expect(testRequest.rpm).to(equal(@YES));
        expect(testRequest.fuelLevel).to(equal(@NO));
        expect(testRequest.fuelLevel_State).to(equal(@YES));
        expect(testRequest.instantFuelConsumption).to(equal(@NO));
        expect(testRequest.externalTemperature).to(equal(@YES));
        expect(testRequest.prndl).to(equal(@YES));
        expect(testRequest.tirePressure).to(equal(@NO));
        expect(testRequest.odometer).to(equal(@YES));
        expect(testRequest.beltStatus).to(equal(@NO));
        expect(testRequest.bodyInformation).to(equal(@YES));
        expect(testRequest.deviceStatus).to(equal(@NO));
        expect(testRequest.driverBraking).to(equal(@YES));
        expect(testRequest.wiperStatus).to(equal(@NO));
        expect(testRequest.headLampStatus).to(equal(@YES));
        expect(testRequest.engineTorque).to(equal(@NO));
        expect(testRequest.accPedalPosition).to(equal(@YES));
        expect(testRequest.steeringWheelAngle).to(equal(@NO));
        expect(testRequest.eCallInfo).to(equal(@YES));
        expect(testRequest.airbagStatus).to(equal(@NO));
        expect(testRequest.emergencyEvent).to(equal(@YES));
        expect(testRequest.clusterModeStatus).to(equal(@NO));
        expect(testRequest.myKey).to(equal(@YES));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLSubscribeVehicleData* testRequest = [[SDLSubscribeVehicleData alloc] init];
        
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
