//
//  SDLSubscribeVehicleDataResponseSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLNames.h"
#import "SDLSubscribeVehicleDataResponse.h"
#import "SDLVehicleDataResult.h"


QuickSpecBegin(SDLSubscribeVehicleDataResponseSpec)

SDLVehicleDataResult* vehicleDataResult = [[SDLVehicleDataResult alloc] init];

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLSubscribeVehicleDataResponse* testResponse = [[SDLSubscribeVehicleDataResponse alloc] init];
        
        testResponse.gps = vehicleDataResult;
        testResponse.speed = vehicleDataResult;
        testResponse.rpm = vehicleDataResult;
        testResponse.fuelLevel = vehicleDataResult;
        testResponse.fuelLevel_State = vehicleDataResult;
        testResponse.instantFuelConsumption = vehicleDataResult;
        testResponse.externalTemperature = vehicleDataResult;
        testResponse.prndl = vehicleDataResult;
        testResponse.tirePressure = vehicleDataResult;
        testResponse.odometer = vehicleDataResult;
        testResponse.beltStatus = vehicleDataResult;
        testResponse.bodyInformation = vehicleDataResult;
        testResponse.deviceStatus = vehicleDataResult;
        testResponse.driverBraking = vehicleDataResult;
        testResponse.wiperStatus = vehicleDataResult;
        testResponse.headLampStatus = vehicleDataResult;
        testResponse.engineTorque = vehicleDataResult;
        testResponse.accPedalPosition = vehicleDataResult;
        testResponse.steeringWheelAngle = vehicleDataResult;
        testResponse.eCallInfo = vehicleDataResult;
        testResponse.airbagStatus = vehicleDataResult;
        testResponse.emergencyEvent = vehicleDataResult;
        testResponse.clusterModes = vehicleDataResult;
        testResponse.myKey = vehicleDataResult;
        
        expect(testResponse.gps).to(equal(vehicleDataResult));
        expect(testResponse.speed).to(equal(vehicleDataResult));
        expect(testResponse.rpm).to(equal(vehicleDataResult));
        expect(testResponse.fuelLevel).to(equal(vehicleDataResult));
        expect(testResponse.fuelLevel_State).to(equal(vehicleDataResult));
        expect(testResponse.instantFuelConsumption).to(equal(vehicleDataResult));
        expect(testResponse.externalTemperature).to(equal(vehicleDataResult));
        expect(testResponse.prndl).to(equal(vehicleDataResult));
        expect(testResponse.tirePressure).to(equal(vehicleDataResult));
        expect(testResponse.odometer).to(equal(vehicleDataResult));
        expect(testResponse.beltStatus).to(equal(vehicleDataResult));
        expect(testResponse.bodyInformation).to(equal(vehicleDataResult));
        expect(testResponse.deviceStatus).to(equal(vehicleDataResult));
        expect(testResponse.driverBraking).to(equal(vehicleDataResult));
        expect(testResponse.wiperStatus).to(equal(vehicleDataResult));
        expect(testResponse.headLampStatus).to(equal(vehicleDataResult));
        expect(testResponse.engineTorque).to(equal(vehicleDataResult));
        expect(testResponse.accPedalPosition).to(equal(vehicleDataResult));
        expect(testResponse.steeringWheelAngle).to(equal(vehicleDataResult));
        expect(testResponse.eCallInfo).to(equal(vehicleDataResult));
        expect(testResponse.airbagStatus).to(equal(vehicleDataResult));
        expect(testResponse.emergencyEvent).to(equal(vehicleDataResult));
        expect(testResponse.clusterModes).to(equal(vehicleDataResult));
        expect(testResponse.myKey).to(equal(vehicleDataResult));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{NAMES_response:
                                           @{NAMES_parameters:
                                                 @{NAMES_gps:vehicleDataResult,
                                                   NAMES_speed:vehicleDataResult,
                                                   NAMES_rpm:vehicleDataResult,
                                                   NAMES_fuelLevel:vehicleDataResult,
                                                   NAMES_fuelLevel_State:vehicleDataResult,
                                                   NAMES_instantFuelConsumption:vehicleDataResult,
                                                   NAMES_externalTemperature:vehicleDataResult,
                                                   NAMES_prndl:vehicleDataResult,
                                                   NAMES_tirePressure:vehicleDataResult,
                                                   NAMES_odometer:vehicleDataResult,
                                                   NAMES_beltStatus:vehicleDataResult,
                                                   NAMES_bodyInformation:vehicleDataResult,
                                                   NAMES_deviceStatus:vehicleDataResult,
                                                   NAMES_driverBraking:vehicleDataResult,
                                                   NAMES_wiperStatus:vehicleDataResult,
                                                   NAMES_headLampStatus:vehicleDataResult,
                                                   NAMES_engineTorque:vehicleDataResult,
                                                   NAMES_accPedalPosition:vehicleDataResult,
                                                   NAMES_steeringWheelAngle:vehicleDataResult,
                                                   NAMES_eCallInfo:vehicleDataResult,
                                                   NAMES_airbagStatus:vehicleDataResult,
                                                   NAMES_emergencyEvent:vehicleDataResult,
                                                   NAMES_clusterModes:vehicleDataResult,
                                                   NAMES_myKey:vehicleDataResult},
                                             NAMES_operation_name:NAMES_SubscribeVehicleData}} mutableCopy];
        SDLSubscribeVehicleDataResponse* testResponse = [[SDLSubscribeVehicleDataResponse alloc] initWithDictionary:dict];
        
        expect(testResponse.gps).to(equal(vehicleDataResult));
        expect(testResponse.speed).to(equal(vehicleDataResult));
        expect(testResponse.rpm).to(equal(vehicleDataResult));
        expect(testResponse.fuelLevel).to(equal(vehicleDataResult));
        expect(testResponse.fuelLevel_State).to(equal(vehicleDataResult));
        expect(testResponse.instantFuelConsumption).to(equal(vehicleDataResult));
        expect(testResponse.externalTemperature).to(equal(vehicleDataResult));
        expect(testResponse.prndl).to(equal(vehicleDataResult));
        expect(testResponse.tirePressure).to(equal(vehicleDataResult));
        expect(testResponse.odometer).to(equal(vehicleDataResult));
        expect(testResponse.beltStatus).to(equal(vehicleDataResult));
        expect(testResponse.bodyInformation).to(equal(vehicleDataResult));
        expect(testResponse.deviceStatus).to(equal(vehicleDataResult));
        expect(testResponse.driverBraking).to(equal(vehicleDataResult));
        expect(testResponse.wiperStatus).to(equal(vehicleDataResult));
        expect(testResponse.headLampStatus).to(equal(vehicleDataResult));
        expect(testResponse.engineTorque).to(equal(vehicleDataResult));
        expect(testResponse.accPedalPosition).to(equal(vehicleDataResult));
        expect(testResponse.steeringWheelAngle).to(equal(vehicleDataResult));
        expect(testResponse.eCallInfo).to(equal(vehicleDataResult));
        expect(testResponse.airbagStatus).to(equal(vehicleDataResult));
        expect(testResponse.emergencyEvent).to(equal(vehicleDataResult));
        expect(testResponse.clusterModes).to(equal(vehicleDataResult));
        expect(testResponse.myKey).to(equal(vehicleDataResult));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLSubscribeVehicleDataResponse* testResponse = [[SDLSubscribeVehicleDataResponse alloc] init];
        
        expect(testResponse.gps).to(beNil());
        expect(testResponse.speed).to(beNil());
        expect(testResponse.rpm).to(beNil());
        expect(testResponse.fuelLevel).to(beNil());
        expect(testResponse.fuelLevel_State).to(beNil());
        expect(testResponse.instantFuelConsumption).to(beNil());
        expect(testResponse.externalTemperature).to(beNil());
        expect(testResponse.prndl).to(beNil());
        expect(testResponse.tirePressure).to(beNil());
        expect(testResponse.odometer).to(beNil());
        expect(testResponse.beltStatus).to(beNil());
        expect(testResponse.bodyInformation).to(beNil());
        expect(testResponse.deviceStatus).to(beNil());
        expect(testResponse.driverBraking).to(beNil());
        expect(testResponse.wiperStatus).to(beNil());
        expect(testResponse.headLampStatus).to(beNil());
        expect(testResponse.engineTorque).to(beNil());
        expect(testResponse.accPedalPosition).to(beNil());
        expect(testResponse.steeringWheelAngle).to(beNil());
        expect(testResponse.eCallInfo).to(beNil());
        expect(testResponse.airbagStatus).to(beNil());
        expect(testResponse.emergencyEvent).to(beNil());
        expect(testResponse.clusterModes).to(beNil());
        expect(testResponse.myKey).to(beNil());
    });
});

QuickSpecEnd
