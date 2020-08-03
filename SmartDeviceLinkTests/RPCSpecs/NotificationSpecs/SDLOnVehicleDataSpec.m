//
//  SDLOnVehicleDataSpec.m
//  SmartDeviceLink

#import <Foundation/Foundation.h>
#import <Nimble/Nimble.h>
#import <Quick/Quick.h>

#import "SDLRPCFunctionNames.h"
#import "SDLRPCParameterNames.h"
#import "SmartDeviceLink.h"

QuickSpecBegin(SDLOnVehicleDataSpec)

describe(@"Getter/Setter Tests", ^ {
    __block SDLGPSData* gps = nil;
    __block SDLTireStatus* tires = nil;
    __block SDLBeltStatus* belt = nil;
    __block SDLBodyInformation* body = nil;
    __block SDLDeviceStatus* device = nil;
    __block SDLHeadLampStatus* headLamp = nil;
    __block SDLECallInfo* eCall = nil;
    __block SDLAirbagStatus* airbag = nil;
    __block SDLEmergencyEvent* event = nil;
    __block SDLClusterModeStatus* clusterMode = nil;
    __block SDLMyKey* myKey = nil;
    __block SDLFuelRange* fuelRange = nil;
    __block NSString* cloudAppVehicleID = nil;

    beforeEach(^{
        gps = [[SDLGPSData alloc] init];
        tires = [[SDLTireStatus alloc] init];
        belt = [[SDLBeltStatus alloc] init];
        body = [[SDLBodyInformation alloc] init];
        device = [[SDLDeviceStatus alloc] init];
        headLamp = [[SDLHeadLampStatus alloc] init];
        eCall = [[SDLECallInfo alloc] init];
        airbag = [[SDLAirbagStatus alloc] init];
        event = [[SDLEmergencyEvent alloc] init];
        clusterMode = [[SDLClusterModeStatus alloc] init];
        myKey = [[SDLMyKey alloc] init];
        fuelRange = [[SDLFuelRange alloc] init];
        cloudAppVehicleID = @"testCloudAppVehicleID";
    });

    it(@"should correctly initialize with init", ^ {
        SDLOnVehicleData* testNotification = [[SDLOnVehicleData alloc] init];

        testNotification.accPedalPosition = @99.99999999;
        testNotification.airbagStatus = airbag;
        testNotification.beltStatus = belt;
        testNotification.bodyInformation = body;
        testNotification.cloudAppVehicleID = cloudAppVehicleID;
        testNotification.clusterModeStatus = clusterMode;
        testNotification.deviceStatus = device;
        testNotification.driverBraking = SDLVehicleDataEventStatusYes;
        testNotification.eCallInfo = eCall;
        testNotification.electronicParkBrakeStatus = SDLElectronicParkBrakeStatusDriveActive;
        testNotification.emergencyEvent = event;
        testNotification.engineOilLife = @34.45;
        testNotification.engineTorque = @-200.124;
        testNotification.externalTemperature = @-10;
        testNotification.fuelLevel = @10.3;
        testNotification.fuelLevel_State = SDLComponentVolumeStatusAlert;
        testNotification.fuelRange = @[fuelRange, fuelRange];
        testNotification.gps = gps;
        testNotification.headLampStatus = headLamp;
        testNotification.instantFuelConsumption = @4000.63;
        testNotification.myKey = myKey;
        testNotification.odometer = @100050;
        testNotification.prndl = SDLPRNDLDrive;
        testNotification.rpm = @4242;
        testNotification.speed = @70.1;
        testNotification.steeringWheelAngle = @0.000000001;
        testNotification.tirePressure = tires;
        testNotification.turnSignal = SDLTurnSignalRight;
        testNotification.vin = @"222222222722";
        testNotification.wiperStatus = SDLWiperStatusStalled;
        testNotification.handsOffSteering = @YES;

        expect(testNotification.accPedalPosition).to(equal(@99.99999999));
        expect(testNotification.airbagStatus).to(equal(airbag));
        expect(testNotification.beltStatus).to(equal(belt));
        expect(testNotification.bodyInformation).to(equal(body));
        expect(testNotification.cloudAppVehicleID).to(equal(cloudAppVehicleID));
        expect(testNotification.clusterModeStatus).to(equal(clusterMode));
        expect(testNotification.deviceStatus).to(equal(device));
        expect(testNotification.driverBraking).to(equal(SDLVehicleDataEventStatusYes));
        expect(testNotification.eCallInfo).to(equal(eCall));
        expect(testNotification.electronicParkBrakeStatus).to(equal(SDLElectronicParkBrakeStatusDriveActive));
        expect(testNotification.emergencyEvent).to(equal(event));
        expect(testNotification.engineOilLife).to(equal(@34.45));
        expect(testNotification.engineTorque).to(equal(@-200.124));
        expect(testNotification.externalTemperature).to(equal(@-10));
        expect(testNotification.fuelLevel).to(equal(@10.3));
        expect(testNotification.fuelLevel_State).to(equal(SDLComponentVolumeStatusAlert));
        expect(testNotification.fuelRange).to(equal(@[fuelRange, fuelRange]));
        expect(testNotification.gps).to(equal(gps));
        expect(testNotification.headLampStatus).to(equal(headLamp));
        expect(testNotification.instantFuelConsumption).to(equal(@4000.63));
        expect(testNotification.myKey).to(equal(myKey));
        expect(testNotification.odometer).to(equal(@100050));
        expect(testNotification.prndl).to(equal(SDLPRNDLDrive));
        expect(testNotification.rpm).to(equal(@4242));
        expect(testNotification.speed).to(equal(@70.1));
        expect(testNotification.steeringWheelAngle).to(equal(@0.000000001));
        expect(testNotification.tirePressure).to(equal(tires));
        expect(testNotification.turnSignal).to(equal(SDLTurnSignalRight));
        expect(testNotification.vin).to(equal(@"222222222722"));
        expect(testNotification.wiperStatus).to(equal(SDLWiperStatusStalled));
        expect(testNotification.handsOffSteering).to(equal(@YES));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSDictionary* dict = @{SDLRPCParameterNameNotification:
                                   @{SDLRPCParameterNameParameters:
                                         @{SDLRPCParameterNameAccelerationPedalPosition:@99.99999999,
                                           SDLRPCParameterNameAirbagStatus:airbag,
                                           SDLRPCParameterNameBeltStatus:belt,
                                           SDLRPCParameterNameBodyInformation:body,
                                           SDLRPCParameterNameCloudAppVehicleID:cloudAppVehicleID,
                                           SDLRPCParameterNameClusterModeStatus:clusterMode,
                                           SDLRPCParameterNameDeviceStatus:device,
                                           SDLRPCParameterNameDriverBraking:SDLVehicleDataEventStatusYes,
                                           SDLRPCParameterNameECallInfo:eCall,
                                           SDLRPCParameterNameElectronicParkBrakeStatus:SDLElectronicParkBrakeStatusDriveActive,
                                           SDLRPCParameterNameEmergencyEvent:event,
                                           SDLRPCParameterNameEngineOilLife:@45.1,
                                           SDLRPCParameterNameEngineTorque:@-200.124,
                                           SDLRPCParameterNameExternalTemperature:@-10,
                                           SDLRPCParameterNameFuelLevel:@10.3,
                                           SDLRPCParameterNameFuelLevelState:SDLComponentVolumeStatusAlert,
                                           SDLRPCParameterNameFuelRange:@[fuelRange],
                                           SDLRPCParameterNameGPS:gps,
                                           SDLRPCParameterNameHeadLampStatus:headLamp,
                                           SDLRPCParameterNameInstantFuelConsumption:@4000.63,
                                           SDLRPCParameterNameMyKey:myKey,
                                           SDLRPCParameterNameOdometer:@100050,
                                           SDLRPCParameterNamePRNDL:SDLPRNDLDrive,
                                           SDLRPCParameterNameRPM:@4242,
                                           SDLRPCParameterNameSpeed:@70.1,
                                           SDLRPCParameterNameSteeringWheelAngle:@0.000000001,
                                           SDLRPCParameterNameTirePressure:tires,
                                           SDLRPCParameterNameTurnSignal:SDLTurnSignalOff,
                                           SDLRPCParameterNameVIN:@"222222222722",
                                           SDLRPCParameterNameWiperStatus:SDLWiperStatusStalled,
                                           SDLRPCParameterNameHandsOffSteering:@YES
                                         },
                                     SDLRPCParameterNameOperationName:SDLRPCFunctionNameOnVehicleData}};
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLOnVehicleData* testNotification = [[SDLOnVehicleData alloc] initWithDictionary:dict];
#pragma clang diagnostic pop
        
        expect(testNotification.accPedalPosition).to(equal(@99.99999999));
        expect(testNotification.airbagStatus).to(equal(airbag));
        expect(testNotification.beltStatus).to(equal(belt));
        expect(testNotification.bodyInformation).to(equal(body));
        expect(testNotification.cloudAppVehicleID).to(equal(cloudAppVehicleID));
        expect(testNotification.clusterModeStatus).to(equal(clusterMode));
        expect(testNotification.deviceStatus).to(equal(device));
        expect(testNotification.driverBraking).to(equal(SDLVehicleDataEventStatusYes));
        expect(testNotification.eCallInfo).to(equal(eCall));
        expect(testNotification.electronicParkBrakeStatus).to(equal(SDLElectronicParkBrakeStatusDriveActive));
        expect(testNotification.emergencyEvent).to(equal(event));
        expect(testNotification.engineOilLife).to(equal(@45.1));
        expect(testNotification.engineTorque).to(equal(@-200.124));
        expect(testNotification.externalTemperature).to(equal(@-10));
        expect(testNotification.fuelLevel).to(equal(@10.3));
        expect(testNotification.fuelLevel_State).to(equal(SDLComponentVolumeStatusAlert));
        expect(testNotification.fuelRange).to(equal(@[fuelRange]));
        expect(testNotification.gps).to(equal(gps));
        expect(testNotification.headLampStatus).to(equal(headLamp));
        expect(testNotification.instantFuelConsumption).to(equal(@4000.63));
        expect(testNotification.myKey).to(equal(myKey));
        expect(testNotification.odometer).to(equal(@100050));
        expect(testNotification.prndl).to(equal(SDLPRNDLDrive));
        expect(testNotification.rpm).to(equal(@4242));
        expect(testNotification.speed).to(equal(@70.1));
        expect(testNotification.steeringWheelAngle).to(equal(@0.000000001));
        expect(testNotification.tirePressure).to(equal(tires));
        expect(testNotification.turnSignal).to(equal(SDLTurnSignalOff));
        expect(testNotification.vin).to(equal(@"222222222722"));
        expect(testNotification.wiperStatus).to(equal(SDLWiperStatusStalled));
        expect(testNotification.handsOffSteering).to(equal(@YES));
    });
    
    it(@"Should return nil if not set", ^ {
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
        expect(testNotification.handsOffSteering).to(beNil());
    });

    it(@"Should set and get generic Network Signal Data", ^{
        SDLOnVehicleData *testRequest = [[SDLOnVehicleData alloc] init];

        [testRequest setOEMCustomVehicleData:@"customVehicleData" withVehicleDataState:@"oemVehicleData"];

        expect([testRequest getOEMCustomVehicleData:@"customVehicleData"]).to(equal(@"oemVehicleData"));
    });

    it(@"Should initialize an object correctly", ^{
        const float speed = 123.45;
        const NSUInteger rpm = 42;
        const float fuelLevel = 10.3;
        SDLComponentVolumeStatus fuelLevel_State = SDLComponentVolumeStatusAlert;
        const float instantFuelConsumption = 4000.63;
        NSArray *fuelRangeArray = @[fuelRange, fuelRange];
        const float externalTemperature = -10.5;
        NSString * const vin = @"222222222722";
        SDLTurnSignal turnSignal = SDLTurnSignalOff;
        SDLPRNDL prndl = SDLPRNDLDrive;
        NSUInteger odometer = 100500;
        SDLVehicleDataEventStatus driverBraking = SDLVehicleDataEventStatusYes;
        SDLWiperStatus wiperStatus = SDLWiperStatusStalled;
        const float engineTorque = -200.124;
        const float accPedalPosition = 99.99999999;
        const float steeringWheelAngle = M_PI_4;
        const float engineOilLife = 34.45;
        SDLElectronicParkBrakeStatus electronicParkBrakeStatus = SDLElectronicParkBrakeStatusDriveActive;
        const BOOL handsOffSteering = YES;
        NSString * const OEMCustomVehicleData = @"customVehicleData";
        NSString * const OEMVehicleDataState = @"oemVehicleData";

        SDLOnVehicleData *onVehicleData =
    [[SDLOnVehicleData alloc] initWithGps:gps
                                    speed:speed
                                      rpm:@(rpm)
                                fuelLevel:fuelLevel
                          fuelLevel_State:fuelLevel_State
                   instantFuelConsumption:instantFuelConsumption
                                fuelRange:fuelRangeArray
                      externalTemperature:externalTemperature
                               turnSignal:turnSignal
                                      vin:vin
                                    prndl:prndl
                             tirePressure:tires
                                 odometer:@(odometer)
                               beltStatus:belt
                          bodyInformation:body
                             deviceStatus:device
                            driverBraking:driverBraking
                              wiperStatus:wiperStatus
                           headLampStatus:headLamp
                             engineTorque:engineTorque
                         accPedalPosition:accPedalPosition
                       steeringWheelAngle:steeringWheelAngle
                            engineOilLife:engineOilLife
                electronicParkBrakeStatus:electronicParkBrakeStatus
                        cloudAppVehicleID:cloudAppVehicleID
                                eCallInfo:eCall
                             airbagStatus:airbag
                           emergencyEvent:event
                        clusterModeStatus:clusterMode
                                    myKey:myKey
                         handsOffSteering:@(handsOffSteering)];
        [onVehicleData setOEMCustomVehicleData:OEMCustomVehicleData withVehicleDataState:OEMVehicleDataState];

        expect([onVehicleData getOEMCustomVehicleData:OEMCustomVehicleData]).to(equal(OEMVehicleDataState));
        expect(onVehicleData.accPedalPosition).to(equal(@(accPedalPosition)));
        expect(onVehicleData.airbagStatus).to(equal(airbag));
        expect(onVehicleData.beltStatus).to(equal(belt));
        expect(onVehicleData.bodyInformation).to(equal(body));
        expect(onVehicleData.cloudAppVehicleID).to(equal(cloudAppVehicleID));
        expect(onVehicleData.clusterModeStatus).to(equal(clusterMode));
        expect(onVehicleData.deviceStatus).to(equal(device));
        expect(onVehicleData.driverBraking).to(equal(driverBraking));
        expect(onVehicleData.eCallInfo).to(equal(eCall));
        expect(onVehicleData.electronicParkBrakeStatus).to(equal(electronicParkBrakeStatus));
        expect(onVehicleData.emergencyEvent).to(equal(event));
        expect(onVehicleData.engineOilLife).to(equal(@(engineOilLife)));
        expect(onVehicleData.engineTorque).to(equal(@(engineTorque)));
        expect(onVehicleData.externalTemperature).to(equal(@(externalTemperature)));
        expect(onVehicleData.fuelLevel).to(equal(@(fuelLevel)));
        expect(onVehicleData.fuelLevel_State).to(equal(fuelLevel_State));
        expect(onVehicleData.fuelRange).to(equal(fuelRangeArray));
        expect(onVehicleData.gps).to(equal(gps));
        expect(onVehicleData.handsOffSteering).to(equal(@(handsOffSteering)));
        expect(onVehicleData.headLampStatus).to(equal(headLamp));
        expect(onVehicleData.instantFuelConsumption).to(equal(@(instantFuelConsumption)));
        expect(onVehicleData.myKey).to(equal(myKey));
        expect(onVehicleData.odometer).to(equal(@(odometer)));
        expect(onVehicleData.prndl).to(equal(prndl));
        expect(onVehicleData.rpm).to(equal(@(rpm)));
        expect(onVehicleData.speed).to(equal(@(speed)));
        expect(onVehicleData.steeringWheelAngle).to(equal((steeringWheelAngle)));
        expect(onVehicleData.tirePressure).to(equal(tires));
        expect(onVehicleData.turnSignal).to(equal(turnSignal));
        expect(onVehicleData.vin).to(equal(vin));
        expect(onVehicleData.wiperStatus).to(equal(wiperStatus));
    });
});

QuickSpecEnd
