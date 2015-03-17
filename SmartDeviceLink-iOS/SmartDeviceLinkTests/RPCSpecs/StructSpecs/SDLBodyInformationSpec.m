//
//  SDLBodyInformationSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLBodyInformation.h"
#import "SDLNames.h"

QuickSpecBegin(SDLBodyInformationSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLBodyInformation* testStruct = [[SDLBodyInformation alloc] init];
        
        testStruct.parkBrakeActive = [NSNumber numberWithBool:YES];
        testStruct.ignitionStableStatus = [SDLIgnitionStableStatus IGNITION_SWITCH_STABLE];
        testStruct.ignitionStatus = [SDLIgnitionStatus START];
        testStruct.driverDoorAjar = [NSNumber numberWithBool:NO];
        testStruct.passengerDoorAjar = [NSNumber numberWithBool:NO];
        testStruct.rearLeftDoorAjar = [NSNumber numberWithBool:NO];
        testStruct.rearRightDoorAjar = [NSNumber numberWithBool:YES];
        
        expect(testStruct.parkBrakeActive).to(equal([NSNumber numberWithBool:YES]));
        expect(testStruct.ignitionStableStatus).to(equal([SDLIgnitionStableStatus IGNITION_SWITCH_STABLE]));
        expect(testStruct.ignitionStatus).to(equal([SDLIgnitionStatus START]));
        expect(testStruct.driverDoorAjar).to(equal([NSNumber numberWithBool:NO]));
        expect(testStruct.passengerDoorAjar).to(equal([NSNumber numberWithBool:NO]));
        expect(testStruct.rearLeftDoorAjar).to(equal([NSNumber numberWithBool:NO]));
        expect(testStruct.rearRightDoorAjar).to(equal([NSNumber numberWithBool:YES]));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{NAMES_parkBrakeActive:[NSNumber numberWithBool:YES],
                                       NAMES_ignitionStableStatus:[SDLIgnitionStableStatus IGNITION_SWITCH_NOT_STABLE],
                                       NAMES_ignitionStatus:[SDLIgnitionStatus START],
                                       NAMES_driverDoorAjar:[NSNumber numberWithBool:NO],
                                       NAMES_passengerDoorAjar:[NSNumber numberWithBool:NO],
                                       NAMES_rearLeftDoorAjar:[NSNumber numberWithBool:NO],
                                       NAMES_rearRightDoorAjar:[NSNumber numberWithBool:YES]} mutableCopy];
        SDLBodyInformation* testStruct = [[SDLBodyInformation alloc] initWithDictionary:dict];
        
        expect(testStruct.parkBrakeActive).to(equal([NSNumber numberWithBool:YES]));
        expect(testStruct.ignitionStableStatus).to(equal([SDLIgnitionStableStatus IGNITION_SWITCH_NOT_STABLE]));
        expect(testStruct.ignitionStatus).to(equal([SDLIgnitionStatus START]));
        expect(testStruct.driverDoorAjar).to(equal([NSNumber numberWithBool:NO]));
        expect(testStruct.passengerDoorAjar).to(equal([NSNumber numberWithBool:NO]));
        expect(testStruct.rearLeftDoorAjar).to(equal([NSNumber numberWithBool:NO]));
        expect(testStruct.rearRightDoorAjar).to(equal([NSNumber numberWithBool:YES]));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLBodyInformation* testStruct = [[SDLBodyInformation alloc] init];
        
        expect(testStruct.parkBrakeActive).to(beNil());
        expect(testStruct.ignitionStableStatus).to(beNil());
        expect(testStruct.ignitionStatus).to(beNil());
        expect(testStruct.driverDoorAjar).to(beNil());
        expect(testStruct.passengerDoorAjar).to(beNil());
        expect(testStruct.rearLeftDoorAjar).to(beNil());
        expect(testStruct.rearRightDoorAjar).to(beNil());
    });
});

QuickSpecEnd