//
//  SDLOnVehicleDataSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SmartDeviceLink.h"
#import "SDLNames.h"


QuickSpecBegin(SDLOnVehicleDataSpec)

SDLGPSData* gps = [[SDLGPSData alloc] init];
SDLTireStatus* tires = [[SDLTireStatus alloc] init];
SDLBeltStatus* belt = [[SDLBeltStatus alloc] init];
SDLBodyInformation* body = [[SDLBodyInformation alloc] init];
SDLDeviceStatus* device = [[SDLDeviceStatus alloc] init];
SDLHeadLampStatus* headLamp = [[SDLHeadLampStatus alloc] init];
SDLECallInfo* eCall = [[SDLECallInfo alloc] init];
SDLAirbagStatus* airbag = [[SDLAirbagStatus alloc] init];
SDLEmergencyEvent* event = [[SDLEmergencyEvent alloc] init];
SDLClusterModeStatus* clusterMode = [[SDLClusterModeStatus alloc] init];
SDLMyKey* myKey = [[SDLMyKey alloc] init];

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLOnVehicleData* testNotification = [[SDLOnVehicleData alloc] init];
        
        testNotification.gps = gps;
        testNotification.speed = @70.1;
        testNotification.rpm = @4242;
        testNotification.fuelLevel = @10.3;
        testNotification.fuelLevel_State = [SDLComponentVolumeStatus ALERT];
        testNotification.instantFuelConsumption = @4000.63;
        testNotification.externalTemperature = @-10;
        testNotification.vin = @"222222222722";
        testNotification.prndl = [SDLPRNDL DRIVE];
        testNotification.tirePressure = tires;
        testNotification.odometer = @100050;
        testNotification.beltStatus = belt;
        testNotification.bodyInformation = body;
        testNotification.deviceStatus = device;
        testNotification.driverBraking = [SDLVehicleDataEventStatus _YES];
        testNotification.wiperStatus = [SDLWiperStatus STALLED];
        testNotification.headLampStatus = headLamp;
        testNotification.engineTorque = @-200.124;
        testNotification.accPedalPosition = @99.99999999;
        testNotification.steeringWheelAngle = @0.000000001;
        testNotification.eCallInfo = eCall;
        testNotification.airbagStatus = airbag;
        testNotification.emergencyEvent = event;
        testNotification.clusterModeStatus = clusterMode;
        testNotification.myKey = myKey;
        
        expect(testNotification.gps).to(equal(gps));
        expect(testNotification.speed).to(equal(@70.1));
        expect(testNotification.rpm).to(equal(@4242));
        expect(testNotification.fuelLevel).to(equal(@10.3));
        expect(testNotification.fuelLevel_State).to(equal([SDLComponentVolumeStatus ALERT]));
        expect(testNotification.instantFuelConsumption).to(equal(@4000.63));
        expect(testNotification.externalTemperature).to(equal(@-10));
        expect(testNotification.vin).to(equal(@"222222222722"));
        expect(testNotification.prndl).to(equal([SDLPRNDL DRIVE]));
        expect(testNotification.tirePressure).to(equal(tires));
        expect(testNotification.odometer).to(equal(@100050));
        expect(testNotification.beltStatus).to(equal(belt));
        expect(testNotification.bodyInformation).to(equal(body));
        expect(testNotification.deviceStatus).to(equal(device));
        expect(testNotification.driverBraking).to(equal([SDLVehicleDataEventStatus _YES]));
        expect(testNotification.wiperStatus).to(equal([SDLWiperStatus STALLED]));
        expect(testNotification.headLampStatus).to(equal(headLamp));
        expect(testNotification.engineTorque).to(equal(@-200.124));
        expect(testNotification.accPedalPosition).to(equal(@99.99999999));
        expect(testNotification.steeringWheelAngle).to(equal(@0.000000001));
        expect(testNotification.eCallInfo).to(equal(eCall));
        expect(testNotification.airbagStatus).to(equal(airbag));
        expect(testNotification.emergencyEvent).to(equal(event));
        expect(testNotification.clusterModeStatus).to(equal(clusterMode));
        expect(testNotification.myKey).to(equal(myKey));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{NAMES_notification:
                                           @{NAMES_parameters:
                                                 @{NAMES_gps:gps,
                                                   NAMES_speed:@70.1,
                                                   NAMES_rpm:@4242,
                                                   NAMES_fuelLevel:@10.3,
                                                   NAMES_fuelLevel_State:[SDLComponentVolumeStatus ALERT],
                                                   NAMES_instantFuelConsumption:@4000.63,
                                                   NAMES_externalTemperature:@-10,
                                                   NAMES_vin:@"222222222722",
                                                   NAMES_prndl:[SDLPRNDL DRIVE],
                                                   NAMES_tirePressure:tires,
                                                   NAMES_odometer:@100050,
                                                   NAMES_beltStatus:belt,
                                                   NAMES_bodyInformation:body,
                                                   NAMES_deviceStatus:device,
                                                   NAMES_driverBraking:[SDLVehicleDataEventStatus _YES],
                                                   NAMES_wiperStatus:[SDLWiperStatus STALLED],
                                                   NAMES_headLampStatus:headLamp,
                                                   NAMES_engineTorque:@-200.124,
                                                   NAMES_accPedalPosition:@99.99999999,
                                                   NAMES_steeringWheelAngle:@0.000000001,
                                                   NAMES_eCallInfo:eCall,
                                                   NAMES_airbagStatus:airbag,
                                                   NAMES_emergencyEvent:event,
                                                   NAMES_clusterModeStatus:clusterMode,
                                                   NAMES_myKey:myKey},
                                             NAMES_operation_name:NAMES_OnVehicleData}} mutableCopy];
        SDLOnVehicleData* testNotification = [[SDLOnVehicleData alloc] initWithDictionary:dict];
        
        expect(testNotification.gps).to(equal(gps));
        expect(testNotification.speed).to(equal(@70.1));
        expect(testNotification.rpm).to(equal(@4242));
        expect(testNotification.fuelLevel).to(equal(@10.3));
        expect(testNotification.fuelLevel_State).to(equal([SDLComponentVolumeStatus ALERT]));
        expect(testNotification.instantFuelConsumption).to(equal(@4000.63));
        expect(testNotification.externalTemperature).to(equal(@-10));
        expect(testNotification.vin).to(equal(@"222222222722"));
        expect(testNotification.prndl).to(equal([SDLPRNDL DRIVE]));
        expect(testNotification.tirePressure).to(equal(tires));
        expect(testNotification.odometer).to(equal(@100050));
        expect(testNotification.beltStatus).to(equal(belt));
        expect(testNotification.bodyInformation).to(equal(body));
        expect(testNotification.deviceStatus).to(equal(device));
        expect(testNotification.driverBraking).to(equal([SDLVehicleDataEventStatus _YES]));
        expect(testNotification.wiperStatus).to(equal([SDLWiperStatus STALLED]));
        expect(testNotification.headLampStatus).to(equal(headLamp));
        expect(testNotification.engineTorque).to(equal(@-200.124));
        expect(testNotification.accPedalPosition).to(equal(@99.99999999));
        expect(testNotification.steeringWheelAngle).to(equal(@0.000000001));
        expect(testNotification.eCallInfo).to(equal(eCall));
        expect(testNotification.airbagStatus).to(equal(airbag));
        expect(testNotification.emergencyEvent).to(equal(event));
        expect(testNotification.clusterModeStatus).to(equal(clusterMode));
        expect(testNotification.myKey).to(equal(myKey));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLOnVehicleData* testNotification = [[SDLOnVehicleData alloc] init];
        
        expect(testNotification.gps).to(beNil());
        expect(testNotification.speed).to(beNil());
        expect(testNotification.rpm).to(beNil());
        expect(testNotification.fuelLevel).to(beNil());
        expect(testNotification.fuelLevel_State).to(beNil());
        expect(testNotification.instantFuelConsumption).to(beNil());
        expect(testNotification.externalTemperature).to(beNil());
        expect(testNotification.vin).to(beNil());
        expect(testNotification.prndl).to(beNil());
        expect(testNotification.tirePressure).to(beNil());
        expect(testNotification.odometer).to(beNil());
        expect(testNotification.beltStatus).to(beNil());
        expect(testNotification.bodyInformation).to(beNil());
        expect(testNotification.deviceStatus).to(beNil());
        expect(testNotification.driverBraking).to(beNil());
        expect(testNotification.wiperStatus).to(beNil());
        expect(testNotification.headLampStatus).to(beNil());
        expect(testNotification.engineTorque).to(beNil());
        expect(testNotification.accPedalPosition).to(beNil());
        expect(testNotification.steeringWheelAngle).to(beNil());
        expect(testNotification.eCallInfo).to(beNil());
        expect(testNotification.airbagStatus).to(beNil());
        expect(testNotification.emergencyEvent).to(beNil());
        expect(testNotification.clusterModeStatus).to(beNil());
        expect(testNotification.myKey).to(beNil());
    });
});

QuickSpecEnd