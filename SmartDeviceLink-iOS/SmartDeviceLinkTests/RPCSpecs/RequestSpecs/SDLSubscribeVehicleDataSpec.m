//
//  SDLSubscribeVehicleDataSpec.m
//  SmartDeviceLink
//
//  Created by Jacob Keeler on 1/29/15.
//  Copyright (c) 2015 Ford Motor Company. All rights reserved.
//
//#define EXP_SHORTHAND

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLSubscribeVehicleData.h"
#import "SDLNames.h"

QuickSpecBegin(SDLSubscribeVehicleDataSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLSubscribeVehicleData* testRequest = [[SDLSubscribeVehicleData alloc] init];
        
        testRequest.gps = [NSNumber numberWithBool:YES];
        testRequest.speed = [NSNumber numberWithBool:NO];
        testRequest.rpm = [NSNumber numberWithBool:YES];
        testRequest.fuelLevel = [NSNumber numberWithBool:NO];
        testRequest.fuelLevel_State = [NSNumber numberWithBool:YES];
        testRequest.instantFuelConsumption = [NSNumber numberWithBool:NO];
        testRequest.externalTemperature = [NSNumber numberWithBool:YES];
        testRequest.prndl = [NSNumber numberWithBool:YES];
        testRequest.tirePressure = [NSNumber numberWithBool:NO];
        testRequest.odometer = [NSNumber numberWithBool:YES];
        testRequest.beltStatus = [NSNumber numberWithBool:NO];
        testRequest.bodyInformation = [NSNumber numberWithBool:YES];
        testRequest.deviceStatus = [NSNumber numberWithBool:NO];
        testRequest.driverBraking = [NSNumber numberWithBool:YES];
        testRequest.wiperStatus = [NSNumber numberWithBool:NO];
        testRequest.headLampStatus = [NSNumber numberWithBool:YES];
        testRequest.engineTorque = [NSNumber numberWithBool:NO];
        testRequest.accPedalPosition = [NSNumber numberWithBool:YES];
        testRequest.steeringWheelAngle = [NSNumber numberWithBool:NO];
        testRequest.eCallInfo = [NSNumber numberWithBool:YES];
        testRequest.airbagStatus = [NSNumber numberWithBool:NO];
        testRequest.emergencyEvent = [NSNumber numberWithBool:YES];
        testRequest.clusterModeStatus = [NSNumber numberWithBool:NO];
        testRequest.myKey = [NSNumber numberWithBool:YES];
        
        expect(testRequest.gps).to(equal([NSNumber numberWithBool:YES]));
        expect(testRequest.speed).to(equal([NSNumber numberWithBool:NO]));
        expect(testRequest.rpm).to(equal([NSNumber numberWithBool:YES]));
        expect(testRequest.fuelLevel).to(equal([NSNumber numberWithBool:NO]));
        expect(testRequest.fuelLevel_State).to(equal([NSNumber numberWithBool:YES]));
        expect(testRequest.instantFuelConsumption).to(equal([NSNumber numberWithBool:NO]));
        expect(testRequest.externalTemperature).to(equal([NSNumber numberWithBool:YES]));
        expect(testRequest.prndl).to(equal([NSNumber numberWithBool:YES]));
        expect(testRequest.tirePressure).to(equal([NSNumber numberWithBool:NO]));
        expect(testRequest.odometer).to(equal([NSNumber numberWithBool:YES]));
        expect(testRequest.beltStatus).to(equal([NSNumber numberWithBool:NO]));
        expect(testRequest.bodyInformation).to(equal([NSNumber numberWithBool:YES]));
        expect(testRequest.deviceStatus).to(equal([NSNumber numberWithBool:NO]));
        expect(testRequest.driverBraking).to(equal([NSNumber numberWithBool:YES]));
        expect(testRequest.wiperStatus).to(equal([NSNumber numberWithBool:NO]));
        expect(testRequest.headLampStatus).to(equal([NSNumber numberWithBool:YES]));
        expect(testRequest.engineTorque).to(equal([NSNumber numberWithBool:NO]));
        expect(testRequest.accPedalPosition).to(equal([NSNumber numberWithBool:YES]));
        expect(testRequest.steeringWheelAngle).to(equal([NSNumber numberWithBool:NO]));
        expect(testRequest.eCallInfo).to(equal([NSNumber numberWithBool:YES]));
        expect(testRequest.airbagStatus).to(equal([NSNumber numberWithBool:NO]));
        expect(testRequest.emergencyEvent).to(equal([NSNumber numberWithBool:YES]));
        expect(testRequest.clusterModeStatus).to(equal([NSNumber numberWithBool:NO]));
        expect(testRequest.myKey).to(equal([NSNumber numberWithBool:YES]));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{NAMES_request:
                                           @{NAMES_parameters:
                                                 @{NAMES_gps:[NSNumber numberWithBool:YES],
                                                   NAMES_speed:[NSNumber numberWithBool:NO],
                                                   NAMES_rpm:[NSNumber numberWithBool:YES],
                                                   NAMES_fuelLevel:[NSNumber numberWithBool:NO],
                                                   NAMES_fuelLevel_State:[NSNumber numberWithBool:YES],
                                                   NAMES_instantFuelConsumption:[NSNumber numberWithBool:NO],
                                                   NAMES_externalTemperature:[NSNumber numberWithBool:YES],
                                                   NAMES_prndl:[NSNumber numberWithBool:YES],
                                                   NAMES_tirePressure:[NSNumber numberWithBool:NO],
                                                   NAMES_odometer:[NSNumber numberWithBool:YES],
                                                   NAMES_beltStatus:[NSNumber numberWithBool:NO],
                                                   NAMES_bodyInformation:[NSNumber numberWithBool:YES],
                                                   NAMES_deviceStatus:[NSNumber numberWithBool:NO],
                                                   NAMES_driverBraking:[NSNumber numberWithBool:YES],
                                                   NAMES_wiperStatus:[NSNumber numberWithBool:NO],
                                                   NAMES_headLampStatus:[NSNumber numberWithBool:YES],
                                                   NAMES_engineTorque:[NSNumber numberWithBool:NO],
                                                   NAMES_accPedalPosition:[NSNumber numberWithBool:YES],
                                                   NAMES_steeringWheelAngle:[NSNumber numberWithBool:NO],
                                                   NAMES_eCallInfo:[NSNumber numberWithBool:YES],
                                                   NAMES_airbagStatus:[NSNumber numberWithBool:NO],
                                                   NAMES_emergencyEvent:[NSNumber numberWithBool:YES],
                                                   NAMES_clusterModeStatus:[NSNumber numberWithBool:NO],
                                                   NAMES_myKey:[NSNumber numberWithBool:YES]},
                                             NAMES_operation_name:NAMES_SubscribeVehicleData}} mutableCopy];
        SDLSubscribeVehicleData* testRequest = [[SDLSubscribeVehicleData alloc] initWithDictionary:dict];
        
        expect(testRequest.gps).to(equal([NSNumber numberWithBool:YES]));
        expect(testRequest.speed).to(equal([NSNumber numberWithBool:NO]));
        expect(testRequest.rpm).to(equal([NSNumber numberWithBool:YES]));
        expect(testRequest.fuelLevel).to(equal([NSNumber numberWithBool:NO]));
        expect(testRequest.fuelLevel_State).to(equal([NSNumber numberWithBool:YES]));
        expect(testRequest.instantFuelConsumption).to(equal([NSNumber numberWithBool:NO]));
        expect(testRequest.externalTemperature).to(equal([NSNumber numberWithBool:YES]));
        expect(testRequest.prndl).to(equal([NSNumber numberWithBool:YES]));
        expect(testRequest.tirePressure).to(equal([NSNumber numberWithBool:NO]));
        expect(testRequest.odometer).to(equal([NSNumber numberWithBool:YES]));
        expect(testRequest.beltStatus).to(equal([NSNumber numberWithBool:NO]));
        expect(testRequest.bodyInformation).to(equal([NSNumber numberWithBool:YES]));
        expect(testRequest.deviceStatus).to(equal([NSNumber numberWithBool:NO]));
        expect(testRequest.driverBraking).to(equal([NSNumber numberWithBool:YES]));
        expect(testRequest.wiperStatus).to(equal([NSNumber numberWithBool:NO]));
        expect(testRequest.headLampStatus).to(equal([NSNumber numberWithBool:YES]));
        expect(testRequest.engineTorque).to(equal([NSNumber numberWithBool:NO]));
        expect(testRequest.accPedalPosition).to(equal([NSNumber numberWithBool:YES]));
        expect(testRequest.steeringWheelAngle).to(equal([NSNumber numberWithBool:NO]));
        expect(testRequest.eCallInfo).to(equal([NSNumber numberWithBool:YES]));
        expect(testRequest.airbagStatus).to(equal([NSNumber numberWithBool:NO]));
        expect(testRequest.emergencyEvent).to(equal([NSNumber numberWithBool:YES]));
        expect(testRequest.clusterModeStatus).to(equal([NSNumber numberWithBool:NO]));
        expect(testRequest.myKey).to(equal([NSNumber numberWithBool:YES]));
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
