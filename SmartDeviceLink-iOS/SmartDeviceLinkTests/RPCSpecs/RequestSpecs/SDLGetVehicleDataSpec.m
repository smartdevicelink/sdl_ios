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
        
        testRequest.gps = @NO;
        testRequest.speed = @YES;
        testRequest.rpm = @NO;
        testRequest.fuelLevel = @YES;
        testRequest.fuelLevel_State = @NO;
        testRequest.instantFuelConsumption = @YES;
        testRequest.externalTemperature = @NO;
        testRequest.vin = @YES;
        testRequest.prndl = @NO;
        testRequest.tirePressure = @YES;
        testRequest.odometer = @NO;
        testRequest.beltStatus = @YES;
        testRequest.bodyInformation = @NO;
        testRequest.deviceStatus = @YES;
        testRequest.driverBraking = @NO;
        testRequest.wiperStatus = @YES;
        testRequest.headLampStatus = @NO;
        testRequest.engineTorque = @YES;
        testRequest.accPedalPosition = @NO;
        testRequest.steeringWheelAngle = @YES;
        testRequest.eCallInfo = @NO;
        testRequest.airbagStatus = @YES;
        testRequest.emergencyEvent = @NO;
        testRequest.clusterModeStatus = @YES;
        testRequest.myKey = @NO;
        
        expect(testRequest.gps).to(equal(@NO));
        expect(testRequest.speed).to(equal(@YES));
        expect(testRequest.rpm).to(equal(@NO));
        expect(testRequest.fuelLevel).to(equal(@YES));
        expect(testRequest.fuelLevel_State).to(equal(@NO));
        expect(testRequest.instantFuelConsumption).to(equal(@YES));
        expect(testRequest.externalTemperature).to(equal(@NO));
        expect(testRequest.vin).to(equal(@YES));
        expect(testRequest.prndl).to(equal(@NO));
        expect(testRequest.tirePressure).to(equal(@YES));
        expect(testRequest.odometer).to(equal(@NO));
        expect(testRequest.beltStatus).to(equal(@YES));
        expect(testRequest.bodyInformation).to(equal(@NO));
        expect(testRequest.deviceStatus).to(equal(@YES));
        expect(testRequest.driverBraking).to(equal(@NO));
        expect(testRequest.wiperStatus).to(equal(@YES));
        expect(testRequest.headLampStatus).to(equal(@NO));
        expect(testRequest.engineTorque).to(equal(@YES));
        expect(testRequest.accPedalPosition).to(equal(@NO));
        expect(testRequest.steeringWheelAngle).to(equal(@YES));
        expect(testRequest.eCallInfo).to(equal(@NO));
        expect(testRequest.airbagStatus).to(equal(@YES));
        expect(testRequest.emergencyEvent).to(equal(@NO));
        expect(testRequest.clusterModeStatus).to(equal(@YES));
        expect(testRequest.myKey).to(equal(@NO));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{NAMES_request:
                                           @{NAMES_parameters:
                                                 @{NAMES_gps:@NO,
                                                   NAMES_speed:@YES,
                                                   NAMES_rpm:@NO,
                                                   NAMES_fuelLevel:@YES,
                                                   NAMES_fuelLevel_State:@NO,
                                                   NAMES_instantFuelConsumption:@YES,
                                                   NAMES_externalTemperature:@NO,
                                                   NAMES_vin:@YES,
                                                   NAMES_prndl:@NO,
                                                   NAMES_tirePressure:@YES,
                                                   NAMES_odometer:@NO,
                                                   NAMES_beltStatus:@YES,
                                                   NAMES_bodyInformation:@NO,
                                                   NAMES_deviceStatus:@YES,
                                                   NAMES_driverBraking:@NO,
                                                   NAMES_wiperStatus:@YES,
                                                   NAMES_headLampStatus:@NO,
                                                   NAMES_engineTorque:@YES,
                                                   NAMES_accPedalPosition:@NO,
                                                   NAMES_steeringWheelAngle:@YES,
                                                   NAMES_eCallInfo:@NO,
                                                   NAMES_airbagStatus:@YES,
                                                   NAMES_emergencyEvent:@NO,
                                                   NAMES_clusterModeStatus:@YES,
                                                   NAMES_myKey:@NO},
                                             NAMES_operation_name:NAMES_GetVehicleData}} mutableCopy];
        SDLGetVehicleData* testRequest = [[SDLGetVehicleData alloc] initWithDictionary:dict];
        
        expect(testRequest.gps).to(equal(@NO));
        expect(testRequest.speed).to(equal(@YES));
        expect(testRequest.rpm).to(equal(@NO));
        expect(testRequest.fuelLevel).to(equal(@YES));
        expect(testRequest.fuelLevel_State).to(equal(@NO));
        expect(testRequest.instantFuelConsumption).to(equal(@YES));
        expect(testRequest.externalTemperature).to(equal(@NO));
        expect(testRequest.vin).to(equal(@YES));
        expect(testRequest.prndl).to(equal(@NO));
        expect(testRequest.tirePressure).to(equal(@YES));
        expect(testRequest.odometer).to(equal(@NO));
        expect(testRequest.beltStatus).to(equal(@YES));
        expect(testRequest.bodyInformation).to(equal(@NO));
        expect(testRequest.deviceStatus).to(equal(@YES));
        expect(testRequest.driverBraking).to(equal(@NO));
        expect(testRequest.wiperStatus).to(equal(@YES));
        expect(testRequest.headLampStatus).to(equal(@NO));
        expect(testRequest.engineTorque).to(equal(@YES));
        expect(testRequest.accPedalPosition).to(equal(@NO));
        expect(testRequest.steeringWheelAngle).to(equal(@YES));
        expect(testRequest.eCallInfo).to(equal(@NO));
        expect(testRequest.airbagStatus).to(equal(@YES));
        expect(testRequest.emergencyEvent).to(equal(@NO));
        expect(testRequest.clusterModeStatus).to(equal(@YES));
        expect(testRequest.myKey).to(equal(@NO));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLGetVehicleData* testRequest = [[SDLGetVehicleData alloc] init];
        
        expect(testRequest.gps).to(beNil());
        expect(testRequest.speed).to(beNil());
        expect(testRequest.rpm).to(beNil());
        expect(testRequest.fuelLevel).to(beNil());
        expect(testRequest.fuelLevel_State).to(beNil());
        expect(testRequest.instantFuelConsumption).to(beNil());
        expect(testRequest.externalTemperature).to(beNil());
        expect(testRequest.vin).to(beNil());
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
