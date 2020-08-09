//
//  SDLOnVehicleDataSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SmartDeviceLink.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"


QuickSpecBegin(SDLOnVehicleDataSpec)

// set up all test constants
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
SDLFuelRange* fuelRange = [[SDLFuelRange alloc] init];
NSArray<SDLFuelRange *> *fuelRangeArray = @[fuelRange, fuelRange];
NSString *const vin = @"6574839201a";
NSString *const cloudAppVehicleID = @"cloud-6f56054e-d633-11ea-999a-14109fcf4b5b";
const float speed = 123.45;
const NSUInteger rpm = 3599;
const float fuelLevel = 34.45;
SDLComponentVolumeStatus fuelLevel_State = SDLComponentVolumeStatusLow;
const float instantFuelConsumption = 45.67;
const float externalTemperature = 56.67;
SDLTurnSignal turnSignal = SDLTurnSignalLeft;
SDLPRNDL prndl = SDLPRNDLReverse;
SDLTireStatus *tirePressure = [[SDLTireStatus alloc] init];
const NSUInteger odometer = 100999;
SDLVehicleDataEventStatus driverBraking = SDLVehicleDataEventStatusYes;
SDLWiperStatus wiperStatus = SDLWiperStatusWash;
const float steeringWheelAngle = 359.99;
const float engineTorque = 999.123;
const float accPedalPosition = 35.88;
const float engineOilLife = 98.76;
SDLElectronicParkBrakeStatus electronicParkBrakeStatus = SDLElectronicParkBrakeStatusTransition;
NSArray<SDLWindowStatus *> *windowStatus = @[[[SDLWindowStatus alloc] init], [[SDLWindowStatus alloc] init]];

describe(@"getter/setter tests", ^ {
    it(@"should correctly initialize with init", ^ {
        SDLOnVehicleData* testNotification = [[SDLOnVehicleData alloc] init];

        testNotification.accPedalPosition = @(accPedalPosition);
        testNotification.airbagStatus = airbag;
        testNotification.beltStatus = belt;
        testNotification.bodyInformation = body;
        testNotification.cloudAppVehicleID = cloudAppVehicleID;
        testNotification.clusterModeStatus = clusterMode;
        testNotification.deviceStatus = device;
        testNotification.driverBraking = driverBraking;
        testNotification.eCallInfo = eCall;
        testNotification.electronicParkBrakeStatus = electronicParkBrakeStatus;
        testNotification.emergencyEvent = event;
        testNotification.engineOilLife = @(engineOilLife);
        testNotification.engineTorque = @(engineTorque);
        testNotification.externalTemperature = @(externalTemperature);
        testNotification.fuelLevel = @(fuelLevel);
        testNotification.fuelLevel_State = fuelLevel_State;
        testNotification.fuelRange = fuelRangeArray;
        testNotification.gps = gps;
        testNotification.headLampStatus = headLamp;
        testNotification.instantFuelConsumption = @(instantFuelConsumption);
        testNotification.myKey = myKey;
        testNotification.odometer = @(odometer);
        testNotification.prndl = prndl;
        testNotification.rpm = @(rpm);
        testNotification.speed = @(speed);
        testNotification.steeringWheelAngle = @(steeringWheelAngle);
        testNotification.tirePressure = tires;
        testNotification.turnSignal = turnSignal;
        testNotification.vin = vin;
        testNotification.wiperStatus = wiperStatus;
        testNotification.windowStatus = windowStatus;

        expect(testNotification.accPedalPosition).to(equal(@(accPedalPosition)));
        expect(testNotification.airbagStatus).to(equal(airbag));
        expect(testNotification.beltStatus).to(equal(belt));
        expect(testNotification.bodyInformation).to(equal(body));
        expect(testNotification.cloudAppVehicleID).to(equal(cloudAppVehicleID));
        expect(testNotification.clusterModeStatus).to(equal(clusterMode));
        expect(testNotification.deviceStatus).to(equal(device));
        expect(testNotification.driverBraking).to(equal(driverBraking));
        expect(testNotification.eCallInfo).to(equal(eCall));
        expect(testNotification.electronicParkBrakeStatus).to(equal(electronicParkBrakeStatus));
        expect(testNotification.emergencyEvent).to(equal(event));
        expect(testNotification.engineOilLife).to(equal(@(engineOilLife)));
        expect(testNotification.engineTorque).to(equal(@(engineTorque)));
        expect(testNotification.externalTemperature).to(equal(@(externalTemperature)));
        expect(testNotification.fuelLevel).to(equal(@(fuelLevel)));
        expect(testNotification.fuelLevel_State).to(equal(fuelLevel_State));
        expect(testNotification.fuelRange).to(equal(fuelRangeArray));
        expect(testNotification.gps).to(equal(gps));
        expect(testNotification.headLampStatus).to(equal(headLamp));
        expect(testNotification.instantFuelConsumption).to(equal(@(instantFuelConsumption)));
        expect(testNotification.myKey).to(equal(myKey));
        expect(testNotification.odometer).to(equal(@(odometer)));
        expect(testNotification.prndl).to(equal(prndl));
        expect(testNotification.rpm).to(equal(@(rpm)));
        expect(testNotification.speed).to(equal(@(speed)));
        expect(testNotification.steeringWheelAngle).to(equal(@(steeringWheelAngle)));
        expect(testNotification.tirePressure).to(equal(tires));
        expect(testNotification.turnSignal).to(equal(turnSignal));
        expect(testNotification.vin).to(equal(vin));
        expect(testNotification.wiperStatus).to(equal(wiperStatus));
        expect(testNotification.windowStatus).to(equal(windowStatus));
});
    
    it(@"should get correctly when initialized", ^ {
        NSDictionary* dict = @{SDLRPCParameterNameNotification:
                                   @{SDLRPCParameterNameParameters:
                                         @{SDLRPCParameterNameAccelerationPedalPosition:@(accPedalPosition),
                                           SDLRPCParameterNameAirbagStatus:airbag,
                                           SDLRPCParameterNameBeltStatus:belt,
                                           SDLRPCParameterNameBodyInformation:body,
                                           SDLRPCParameterNameCloudAppVehicleID:cloudAppVehicleID,
                                           SDLRPCParameterNameClusterModeStatus:clusterMode,
                                           SDLRPCParameterNameDeviceStatus:device,
                                           SDLRPCParameterNameDriverBraking:driverBraking,
                                           SDLRPCParameterNameECallInfo:eCall,
                                           SDLRPCParameterNameElectronicParkBrakeStatus:electronicParkBrakeStatus,
                                           SDLRPCParameterNameEmergencyEvent:event,
                                           SDLRPCParameterNameEngineOilLife:@(engineOilLife),
                                           SDLRPCParameterNameEngineTorque:@(engineTorque),
                                           SDLRPCParameterNameExternalTemperature:@(externalTemperature),
                                           SDLRPCParameterNameFuelLevel:@(fuelLevel),
                                           SDLRPCParameterNameFuelLevelState:fuelLevel_State,
                                           SDLRPCParameterNameFuelRange:fuelRangeArray,
                                           SDLRPCParameterNameGPS:gps,
                                           SDLRPCParameterNameHeadLampStatus:headLamp,
                                           SDLRPCParameterNameInstantFuelConsumption:@(instantFuelConsumption),
                                           SDLRPCParameterNameMyKey:myKey,
                                           SDLRPCParameterNameOdometer:@(odometer),
                                           SDLRPCParameterNamePRNDL:prndl,
                                           SDLRPCParameterNameRPM:@(rpm),
                                           SDLRPCParameterNameSpeed:@(speed),
                                           SDLRPCParameterNameSteeringWheelAngle:@(steeringWheelAngle),
                                           SDLRPCParameterNameTirePressure:tires,
                                           SDLRPCParameterNameTurnSignal:turnSignal,
                                           SDLRPCParameterNameVIN:vin,
                                           SDLRPCParameterNameWiperStatus:wiperStatus,
                                           SDLRPCParameterNameWindowStatus:windowStatus
                                         },
                                     SDLRPCParameterNameOperationName:SDLRPCFunctionNameOnVehicleData}};
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLOnVehicleData* testNotification = [[SDLOnVehicleData alloc] initWithDictionary:dict];
#pragma clang diagnostic pop
        
        expect(testNotification.accPedalPosition).to(equal(@(accPedalPosition)));
        expect(testNotification.airbagStatus).to(equal(airbag));
        expect(testNotification.beltStatus).to(equal(belt));
        expect(testNotification.bodyInformation).to(equal(body));
        expect(testNotification.cloudAppVehicleID).to(equal(cloudAppVehicleID));
        expect(testNotification.clusterModeStatus).to(equal(clusterMode));
        expect(testNotification.deviceStatus).to(equal(device));
        expect(testNotification.driverBraking).to(equal(driverBraking));
        expect(testNotification.eCallInfo).to(equal(eCall));
        expect(testNotification.electronicParkBrakeStatus).to(equal(electronicParkBrakeStatus));
        expect(testNotification.emergencyEvent).to(equal(event));
        expect(testNotification.engineOilLife).to(equal(@(engineOilLife)));
        expect(testNotification.engineTorque).to(equal(@(engineTorque)));
        expect(testNotification.externalTemperature).to(equal(@(externalTemperature)));
        expect(testNotification.fuelLevel).to(equal(@(fuelLevel)));
        expect(testNotification.fuelLevel_State).to(equal(fuelLevel_State));
        expect(testNotification.fuelRange).to(equal(fuelRangeArray));
        expect(testNotification.gps).to(equal(gps));
        expect(testNotification.headLampStatus).to(equal(headLamp));
        expect(testNotification.instantFuelConsumption).to(equal(@(instantFuelConsumption)));
        expect(testNotification.myKey).to(equal(myKey));
        expect(testNotification.odometer).to(equal(@(odometer)));
        expect(testNotification.prndl).to(equal(prndl));
        expect(testNotification.rpm).to(equal(@(rpm)));
        expect(testNotification.speed).to(equal(@(speed)));
        expect(testNotification.steeringWheelAngle).to(equal(@(steeringWheelAngle)));
        expect(testNotification.tirePressure).to(equal(tires));
        expect(testNotification.turnSignal).to(equal(turnSignal));
        expect(testNotification.vin).to(equal(vin));
        expect(testNotification.wiperStatus).to(equal(wiperStatus));
        expect(testNotification.windowStatus).to(equal(windowStatus));
    });
    
    it(@"should return nil if not set", ^ {
        SDLOnVehicleData* testNotification = [[SDLOnVehicleData alloc] init];
        
        expect(testNotification.accPedalPosition).to(beNil());
        expect(testNotification.airbagStatus).to(beNil());
        expect(testNotification.beltStatus).to(beNil());
        expect(testNotification.bodyInformation).to(beNil());
        expect(testNotification.cloudAppVehicleID).to(beNil());
        expect(testNotification.clusterModeStatus).to(beNil());
        expect(testNotification.deviceStatus).to(beNil());
        expect(testNotification.driverBraking).to(beNil());
        expect(testNotification.eCallInfo).to(beNil());
        expect(testNotification.electronicParkBrakeStatus).to(beNil());
        expect(testNotification.emergencyEvent).to(beNil());
        expect(testNotification.engineOilLife).to(beNil());
        expect(testNotification.engineTorque).to(beNil());
        expect(testNotification.externalTemperature).to(beNil());
        expect(testNotification.fuelLevel).to(beNil());
        expect(testNotification.fuelLevel_State).to(beNil());
        expect(testNotification.fuelRange).to(beNil());
        expect(testNotification.gps).to(beNil());
        expect(testNotification.headLampStatus).to(beNil());
        expect(testNotification.instantFuelConsumption).to(beNil());
        expect(testNotification.myKey).to(beNil());
        expect(testNotification.odometer).to(beNil());
        expect(testNotification.prndl).to(beNil());
        expect(testNotification.rpm).to(beNil());
        expect(testNotification.speed).to(beNil());
        expect(testNotification.steeringWheelAngle).to(beNil());
        expect(testNotification.tirePressure).to(beNil());
        expect(testNotification.turnSignal).to(beNil());
        expect(testNotification.vin).to(beNil());
        expect(testNotification.wiperStatus).to(beNil());
        expect(testNotification.windowStatus).to(beNil());
    });

    context(@"initWithGps:speed:rpm:fuelLevel:fuelLevel_State:instantFuelConsumption:fuelRange:externalTemperature:turnSignal:vin:prndl:tirePressure:odometer:beltStatus:bodyInformation:deviceStatus:driverBraking:wiperStatus:headLampStatus:engineTorque:accPedalPosition:steeringWheelAngle:engineOilLife:electronicParkBrakeStatus:cloudAppVehicleID:eCallInfo:airbagStatus:emergencyEvent:clusterModeStatus:myKey:windowStatus:", ^{
        SDLOnVehicleData* testNotification = [[SDLOnVehicleData alloc] initWithGps:gps speed:speed rpm:@(rpm) fuelLevel:fuelLevel fuelLevel_State:fuelLevel_State instantFuelConsumption:instantFuelConsumption fuelRange:fuelRangeArray externalTemperature:externalTemperature turnSignal:turnSignal vin:vin prndl:prndl tirePressure:tirePressure odometer:@(odometer) beltStatus:belt bodyInformation:body deviceStatus:device driverBraking:driverBraking wiperStatus:wiperStatus headLampStatus:headLamp engineTorque:engineTorque accPedalPosition:accPedalPosition steeringWheelAngle:steeringWheelAngle engineOilLife:engineOilLife electronicParkBrakeStatus:electronicParkBrakeStatus cloudAppVehicleID:cloudAppVehicleID eCallInfo:eCall airbagStatus:airbag emergencyEvent:event clusterModeStatus:clusterMode myKey:myKey windowStatus:windowStatus];

        it(@"expect all properties to be set properly", ^{
            expect(testNotification.accPedalPosition).to(equal(accPedalPosition));
            expect(testNotification.airbagStatus).to(equal(airbag));
            expect(testNotification.beltStatus).to(equal(belt));
            expect(testNotification.bodyInformation).to(equal(body));
            expect(testNotification.cloudAppVehicleID).to(equal(cloudAppVehicleID));
            expect(testNotification.clusterModeStatus).to(equal(clusterMode));
            expect(testNotification.deviceStatus).to(equal(device));
            expect(testNotification.driverBraking).to(equal(driverBraking));
            expect(testNotification.eCallInfo).to(equal(eCall));
            expect(testNotification.electronicParkBrakeStatus).to(equal(electronicParkBrakeStatus));
            expect(testNotification.emergencyEvent).to(equal(event));
            expect(testNotification.engineOilLife).to(equal(engineOilLife));
            expect(testNotification.engineTorque).to(equal(engineTorque));
            expect(testNotification.externalTemperature).to(equal(@(externalTemperature)));
            expect(testNotification.fuelLevel).to(equal(@(fuelLevel)));
            expect(testNotification.fuelLevel_State).to(equal(fuelLevel_State));
            expect(testNotification.fuelRange).to(equal(fuelRangeArray));
            expect(testNotification.gps).to(equal(gps));
            expect(testNotification.headLampStatus).to(equal(headLamp));
            expect(testNotification.instantFuelConsumption).to(equal(@(instantFuelConsumption)));
            expect(testNotification.myKey).to(equal(myKey));
            expect(testNotification.odometer).to(equal(@(odometer)));
            expect(testNotification.prndl).to(equal(prndl));
            expect(testNotification.rpm).to(equal(@(rpm)));
            expect(testNotification.speed).to(equal(@(speed)));
            expect(testNotification.steeringWheelAngle).to(equal(@(steeringWheelAngle)));
            expect(testNotification.tirePressure).to(equal(tires));
            expect(testNotification.turnSignal).to(equal(turnSignal));
            expect(testNotification.vin).to(equal(vin));
            expect(testNotification.wiperStatus).to(equal(wiperStatus));
            expect(testNotification.windowStatus).to(equal(windowStatus));
        });
    });

    it(@"should set and get OEM Custom Vehicle Data", ^{
        SDLOnVehicleData *testRequest = [[SDLOnVehicleData alloc] init];
        [testRequest setOEMCustomVehicleData:@"customVehicleData" withVehicleDataState:@"oemVehicleData"];

        expect([testRequest getOEMCustomVehicleData:@"customVehicleData"]).to(equal(@"oemVehicleData"));
        expect(testRequest.windowStatus).to(beNil());
    });
});

QuickSpecEnd
