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
        
        testRequest.gps = [NSNumber numberWithBool:NO];
        testRequest.speed = [NSNumber numberWithBool:YES];
        testRequest.rpm = [NSNumber numberWithBool:NO];
        testRequest.fuelLevel = [NSNumber numberWithBool:YES];
        testRequest.fuelLevel_State = [NSNumber numberWithBool:NO];
        testRequest.instantFuelConsumption = [NSNumber numberWithBool:YES];
        testRequest.externalTemperature = [NSNumber numberWithBool:NO];
        testRequest.vin = [NSNumber numberWithBool:YES];
        testRequest.prndl = [NSNumber numberWithBool:NO];
        testRequest.tirePressure = [NSNumber numberWithBool:YES];
        testRequest.odometer = [NSNumber numberWithBool:NO];
        testRequest.beltStatus = [NSNumber numberWithBool:YES];
        testRequest.bodyInformation = [NSNumber numberWithBool:NO];
        testRequest.deviceStatus = [NSNumber numberWithBool:YES];
        testRequest.driverBraking = [NSNumber numberWithBool:NO];
        testRequest.wiperStatus = [NSNumber numberWithBool:YES];
        testRequest.headLampStatus = [NSNumber numberWithBool:NO];
        testRequest.engineTorque = [NSNumber numberWithBool:YES];
        testRequest.accPedalPosition = [NSNumber numberWithBool:NO];
        testRequest.steeringWheelAngle = [NSNumber numberWithBool:YES];
        testRequest.eCallInfo = [NSNumber numberWithBool:NO];
        testRequest.airbagStatus = [NSNumber numberWithBool:YES];
        testRequest.emergencyEvent = [NSNumber numberWithBool:NO];
        testRequest.clusterModeStatus = [NSNumber numberWithBool:YES];
        testRequest.myKey = [NSNumber numberWithBool:NO];
        
        expect(testRequest.gps).to(equal([NSNumber numberWithBool:NO]));
        expect(testRequest.speed).to(equal([NSNumber numberWithBool:YES]));
        expect(testRequest.rpm).to(equal([NSNumber numberWithBool:NO]));
        expect(testRequest.fuelLevel).to(equal([NSNumber numberWithBool:YES]));
        expect(testRequest.fuelLevel_State).to(equal([NSNumber numberWithBool:NO]));
        expect(testRequest.instantFuelConsumption).to(equal([NSNumber numberWithBool:YES]));
        expect(testRequest.externalTemperature).to(equal([NSNumber numberWithBool:NO]));
        expect(testRequest.vin).to(equal([NSNumber numberWithBool:YES]));
        expect(testRequest.prndl).to(equal([NSNumber numberWithBool:NO]));
        expect(testRequest.tirePressure).to(equal([NSNumber numberWithBool:YES]));
        expect(testRequest.odometer).to(equal([NSNumber numberWithBool:NO]));
        expect(testRequest.beltStatus).to(equal([NSNumber numberWithBool:YES]));
        expect(testRequest.bodyInformation).to(equal([NSNumber numberWithBool:NO]));
        expect(testRequest.deviceStatus).to(equal([NSNumber numberWithBool:YES]));
        expect(testRequest.driverBraking).to(equal([NSNumber numberWithBool:NO]));
        expect(testRequest.wiperStatus).to(equal([NSNumber numberWithBool:YES]));
        expect(testRequest.headLampStatus).to(equal([NSNumber numberWithBool:NO]));
        expect(testRequest.engineTorque).to(equal([NSNumber numberWithBool:YES]));
        expect(testRequest.accPedalPosition).to(equal([NSNumber numberWithBool:NO]));
        expect(testRequest.steeringWheelAngle).to(equal([NSNumber numberWithBool:YES]));
        expect(testRequest.eCallInfo).to(equal([NSNumber numberWithBool:NO]));
        expect(testRequest.airbagStatus).to(equal([NSNumber numberWithBool:YES]));
        expect(testRequest.emergencyEvent).to(equal([NSNumber numberWithBool:NO]));
        expect(testRequest.clusterModeStatus).to(equal([NSNumber numberWithBool:YES]));
        expect(testRequest.myKey).to(equal([NSNumber numberWithBool:NO]));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{NAMES_request:
                                           @{NAMES_parameters:
                                                 @{NAMES_gps:[NSNumber numberWithBool:NO],
                                                   NAMES_speed:[NSNumber numberWithBool:YES],
                                                   NAMES_rpm:[NSNumber numberWithBool:NO],
                                                   NAMES_fuelLevel:[NSNumber numberWithBool:YES],
                                                   NAMES_fuelLevel_State:[NSNumber numberWithBool:NO],
                                                   NAMES_instantFuelConsumption:[NSNumber numberWithBool:YES],
                                                   NAMES_externalTemperature:[NSNumber numberWithBool:NO],
                                                   NAMES_vin:[NSNumber numberWithBool:YES],
                                                   NAMES_prndl:[NSNumber numberWithBool:NO],
                                                   NAMES_tirePressure:[NSNumber numberWithBool:YES],
                                                   NAMES_odometer:[NSNumber numberWithBool:NO],
                                                   NAMES_beltStatus:[NSNumber numberWithBool:YES],
                                                   NAMES_bodyInformation:[NSNumber numberWithBool:NO],
                                                   NAMES_deviceStatus:[NSNumber numberWithBool:YES],
                                                   NAMES_driverBraking:[NSNumber numberWithBool:NO],
                                                   NAMES_wiperStatus:[NSNumber numberWithBool:YES],
                                                   NAMES_headLampStatus:[NSNumber numberWithBool:NO],
                                                   NAMES_engineTorque:[NSNumber numberWithBool:YES],
                                                   NAMES_accPedalPosition:[NSNumber numberWithBool:NO],
                                                   NAMES_steeringWheelAngle:[NSNumber numberWithBool:YES],
                                                   NAMES_eCallInfo:[NSNumber numberWithBool:NO],
                                                   NAMES_airbagStatus:[NSNumber numberWithBool:YES],
                                                   NAMES_emergencyEvent:[NSNumber numberWithBool:NO],
                                                   NAMES_clusterModeStatus:[NSNumber numberWithBool:YES],
                                                   NAMES_myKey:[NSNumber numberWithBool:NO]},
                                             NAMES_operation_name:NAMES_GetVehicleData}} mutableCopy];
        SDLGetVehicleData* testRequest = [[SDLGetVehicleData alloc] initWithDictionary:dict];
        
        expect(testRequest.gps).to(equal([NSNumber numberWithBool:NO]));
        expect(testRequest.speed).to(equal([NSNumber numberWithBool:YES]));
        expect(testRequest.rpm).to(equal([NSNumber numberWithBool:NO]));
        expect(testRequest.fuelLevel).to(equal([NSNumber numberWithBool:YES]));
        expect(testRequest.fuelLevel_State).to(equal([NSNumber numberWithBool:NO]));
        expect(testRequest.instantFuelConsumption).to(equal([NSNumber numberWithBool:YES]));
        expect(testRequest.externalTemperature).to(equal([NSNumber numberWithBool:NO]));
        expect(testRequest.vin).to(equal([NSNumber numberWithBool:YES]));
        expect(testRequest.prndl).to(equal([NSNumber numberWithBool:NO]));
        expect(testRequest.tirePressure).to(equal([NSNumber numberWithBool:YES]));
        expect(testRequest.odometer).to(equal([NSNumber numberWithBool:NO]));
        expect(testRequest.beltStatus).to(equal([NSNumber numberWithBool:YES]));
        expect(testRequest.bodyInformation).to(equal([NSNumber numberWithBool:NO]));
        expect(testRequest.deviceStatus).to(equal([NSNumber numberWithBool:YES]));
        expect(testRequest.driverBraking).to(equal([NSNumber numberWithBool:NO]));
        expect(testRequest.wiperStatus).to(equal([NSNumber numberWithBool:YES]));
        expect(testRequest.headLampStatus).to(equal([NSNumber numberWithBool:NO]));
        expect(testRequest.engineTorque).to(equal([NSNumber numberWithBool:YES]));
        expect(testRequest.accPedalPosition).to(equal([NSNumber numberWithBool:NO]));
        expect(testRequest.steeringWheelAngle).to(equal([NSNumber numberWithBool:YES]));
        expect(testRequest.eCallInfo).to(equal([NSNumber numberWithBool:NO]));
        expect(testRequest.airbagStatus).to(equal([NSNumber numberWithBool:YES]));
        expect(testRequest.emergencyEvent).to(equal([NSNumber numberWithBool:NO]));
        expect(testRequest.clusterModeStatus).to(equal([NSNumber numberWithBool:YES]));
        expect(testRequest.myKey).to(equal([NSNumber numberWithBool:NO]));
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
