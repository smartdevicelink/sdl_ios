//
//  SDLBodyInformationSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLBodyInformation.h"
#import "SDLIgnitionStableStatus.h"
#import "SDLIgnitionStatus.h"
#import "SDLRPCParameterNames.h"

QuickSpecBegin(SDLBodyInformationSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLBodyInformation* testStruct = [[SDLBodyInformation alloc] init];
        
        testStruct.parkBrakeActive = @YES;
        testStruct.ignitionStableStatus = SDLIgnitionStableStatusStable;
        testStruct.ignitionStatus = SDLIgnitionStatusStart;
        testStruct.driverDoorAjar = @NO;
        testStruct.passengerDoorAjar = @NO;
        testStruct.rearLeftDoorAjar = @NO;
        testStruct.rearRightDoorAjar = @YES;
        
        expect(testStruct.parkBrakeActive).to(equal(@YES));
        expect(testStruct.ignitionStableStatus).to(equal(SDLIgnitionStableStatusStable));
        expect(testStruct.ignitionStatus).to(equal(SDLIgnitionStatusStart));
        expect(testStruct.driverDoorAjar).to(equal(@NO));
        expect(testStruct.passengerDoorAjar).to(equal(@NO));
        expect(testStruct.rearLeftDoorAjar).to(equal(@NO));
        expect(testStruct.rearRightDoorAjar).to(equal(@YES));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{SDLRPCParameterNameParkBrakeActive:@YES,
                                       SDLRPCParameterNameIgnitionStableStatus:SDLIgnitionStableStatusNotStable,
                                       SDLRPCParameterNameIgnitionStatus:SDLIgnitionStatusStart,
                                       SDLRPCParameterNameDriverDoorAjar:@NO,
                                       SDLRPCParameterNamePassengerDoorAjar:@NO,
                                       SDLRPCParameterNameRearLeftDoorAjar:@NO,
                                       SDLRPCParameterNameRearRightDoorAjar:@YES} mutableCopy];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLBodyInformation* testStruct = [[SDLBodyInformation alloc] initWithDictionary:dict];
#pragma clang diagnostic pop
        
        expect(testStruct.parkBrakeActive).to(equal(@YES));
        expect(testStruct.ignitionStableStatus).to(equal(SDLIgnitionStableStatusNotStable));
        expect(testStruct.ignitionStatus).to(equal(SDLIgnitionStatusStart));
        expect(testStruct.driverDoorAjar).to(equal(@NO));
        expect(testStruct.passengerDoorAjar).to(equal(@NO));
        expect(testStruct.rearLeftDoorAjar).to(equal(@NO));
        expect(testStruct.rearRightDoorAjar).to(equal(@YES));
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
