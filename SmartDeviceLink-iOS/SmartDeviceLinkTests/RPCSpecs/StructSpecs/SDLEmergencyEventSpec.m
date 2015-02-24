//
//  SDLEmergencyEventSpec.m
//  SmartDeviceLink
//
//  Created by Jacob Keeler on 1/23/15.
//  Copyright (c) 2015 Ford Motor Company. All rights reserved.
//
//#define EXP_SHORTHAND

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLEmergencyEvent.h"
#import "SDLNames.h"

QuickSpecBegin(SDLEmergencyEventSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLEmergencyEvent* testStruct = [[SDLEmergencyEvent alloc] init];
        
        testStruct.emergencyEventType = [SDLEmergencyEventType FRONTAL];
        testStruct.fuelCutoffStatus = [SDLFuelCutoffStatus NORMAL_OPERATION];
        testStruct.rolloverEvent = [SDLVehicleDataEventStatus _YES];
        testStruct.maximumChangeVelocity = @33;
        testStruct.multipleEvents = [SDLVehicleDataEventStatus _NO];
        
        expect(testStruct.emergencyEventType).to(equal([SDLEmergencyEventType FRONTAL]));
        expect(testStruct.fuelCutoffStatus).to(equal([SDLFuelCutoffStatus NORMAL_OPERATION]));
        expect(testStruct.rolloverEvent).to(equal([SDLVehicleDataEventStatus _YES]));
        expect(testStruct.maximumChangeVelocity).to(equal(@33));
        expect(testStruct.multipleEvents).to(equal([SDLVehicleDataEventStatus _NO]));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{NAMES_emergencyEventType:[SDLEmergencyEventType FRONTAL],
                                       NAMES_fuelCutoffStatus:[SDLFuelCutoffStatus NORMAL_OPERATION],
                                       NAMES_rolloverEvent:[SDLVehicleDataEventStatus _YES],
                                       NAMES_maximumChangeVelocity:@33,
                                       NAMES_multipleEvents:[SDLVehicleDataEventStatus _NO]} mutableCopy];
        SDLEmergencyEvent* testStruct = [[SDLEmergencyEvent alloc] initWithDictionary:dict];
        
        expect(testStruct.emergencyEventType).to(equal([SDLEmergencyEventType FRONTAL]));
        expect(testStruct.fuelCutoffStatus).to(equal([SDLFuelCutoffStatus NORMAL_OPERATION]));
        expect(testStruct.rolloverEvent).to(equal([SDLVehicleDataEventStatus _YES]));
        expect(testStruct.maximumChangeVelocity).to(equal(@33));
        expect(testStruct.multipleEvents).to(equal([SDLVehicleDataEventStatus _NO]));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLEmergencyEvent* testStruct = [[SDLEmergencyEvent alloc] init];
        
        expect(testStruct.emergencyEventType).to(beNil());
        expect(testStruct.fuelCutoffStatus).to(beNil());
        expect(testStruct.rolloverEvent).to(beNil());
        expect(testStruct.maximumChangeVelocity).to(beNil());
        expect(testStruct.multipleEvents).to(beNil());
    });
});

QuickSpecEnd