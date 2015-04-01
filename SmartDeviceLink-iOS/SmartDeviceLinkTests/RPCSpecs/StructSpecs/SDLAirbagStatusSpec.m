//
//  SDLAirbagStatusSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLAirbagStatus.h"
#import "SDLNames.h"
#import "SDLVehicleDataEventStatus.h"


QuickSpecBegin(SDLAirbagStatusSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLAirbagStatus* testStruct = [[SDLAirbagStatus alloc] init];
        
        testStruct.driverAirbagDeployed = [SDLVehicleDataEventStatus _YES];
        testStruct.driverSideAirbagDeployed = [SDLVehicleDataEventStatus NO_EVENT];
        testStruct.driverCurtainAirbagDeployed = [SDLVehicleDataEventStatus _NO];
        testStruct.passengerAirbagDeployed = [SDLVehicleDataEventStatus NOT_SUPPORTED];
        testStruct.passengerCurtainAirbagDeployed = [SDLVehicleDataEventStatus FAULT];
        testStruct.driverKneeAirbagDeployed = [SDLVehicleDataEventStatus _NO];
        testStruct.passengerSideAirbagDeployed = [SDLVehicleDataEventStatus _YES];
        testStruct.passengerKneeAirbagDeployed = [SDLVehicleDataEventStatus NO_EVENT];
        
        expect(testStruct.driverAirbagDeployed).to(equal([SDLVehicleDataEventStatus _YES]));
        expect(testStruct.driverSideAirbagDeployed).to(equal([SDLVehicleDataEventStatus NO_EVENT]));
        expect(testStruct.driverCurtainAirbagDeployed).to(equal([SDLVehicleDataEventStatus _NO]));
        expect(testStruct.passengerAirbagDeployed).to(equal([SDLVehicleDataEventStatus NOT_SUPPORTED]));
        expect(testStruct.passengerCurtainAirbagDeployed).to(equal([SDLVehicleDataEventStatus FAULT]));
        expect(testStruct.driverKneeAirbagDeployed).to(equal([SDLVehicleDataEventStatus _NO]));
        expect(testStruct.passengerSideAirbagDeployed).to(equal([SDLVehicleDataEventStatus _YES]));
        expect(testStruct.passengerKneeAirbagDeployed).to(equal([SDLVehicleDataEventStatus NO_EVENT]));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{NAMES_driverAirbagDeployed:[SDLVehicleDataEventStatus _YES],
                                       NAMES_driverSideAirbagDeployed:[SDLVehicleDataEventStatus NO_EVENT],
                                       NAMES_driverCurtainAirbagDeployed:[SDLVehicleDataEventStatus _NO],
                                       NAMES_passengerAirbagDeployed:[SDLVehicleDataEventStatus NOT_SUPPORTED],
                                       NAMES_passengerCurtainAirbagDeployed:[SDLVehicleDataEventStatus FAULT],
                                       NAMES_driverKneeAirbagDeployed:[SDLVehicleDataEventStatus _NO],
                                       NAMES_passengerSideAirbagDeployed:[SDLVehicleDataEventStatus _YES],
                                       NAMES_passengerKneeAirbagDeployed:[SDLVehicleDataEventStatus NO_EVENT]} mutableCopy];
        SDLAirbagStatus* testStruct = [[SDLAirbagStatus alloc] initWithDictionary:dict];
        
        expect(testStruct.driverAirbagDeployed).to(equal([SDLVehicleDataEventStatus _YES]));
        expect(testStruct.driverSideAirbagDeployed).to(equal([SDLVehicleDataEventStatus NO_EVENT]));
        expect(testStruct.driverCurtainAirbagDeployed).to(equal([SDLVehicleDataEventStatus _NO]));
        expect(testStruct.passengerAirbagDeployed).to(equal([SDLVehicleDataEventStatus NOT_SUPPORTED]));
        expect(testStruct.passengerCurtainAirbagDeployed).to(equal([SDLVehicleDataEventStatus FAULT]));
        expect(testStruct.driverKneeAirbagDeployed).to(equal([SDLVehicleDataEventStatus _NO]));
        expect(testStruct.passengerSideAirbagDeployed).to(equal([SDLVehicleDataEventStatus _YES]));
        expect(testStruct.passengerKneeAirbagDeployed).to(equal([SDLVehicleDataEventStatus NO_EVENT]));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLAirbagStatus* testStruct = [[SDLAirbagStatus alloc] init];
        
        expect(testStruct.driverAirbagDeployed).to(beNil());
        expect(testStruct.driverSideAirbagDeployed).to(beNil());
        expect(testStruct.driverCurtainAirbagDeployed).to(beNil());
        expect(testStruct.passengerAirbagDeployed).to(beNil());
        expect(testStruct.passengerCurtainAirbagDeployed).to(beNil());
        expect(testStruct.driverKneeAirbagDeployed).to(beNil());
        expect(testStruct.passengerSideAirbagDeployed).to(beNil());
        expect(testStruct.passengerKneeAirbagDeployed).to(beNil());
    });
});

QuickSpecEnd