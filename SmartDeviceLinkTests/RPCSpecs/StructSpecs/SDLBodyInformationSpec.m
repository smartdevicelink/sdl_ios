//
//  SDLBodyInformationSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLBodyInformation.h"
#import "SDLDoorStatus.h"
#import "SDLGateStatus.h"
#import "SDLIgnitionStableStatus.h"
#import "SDLIgnitionStatus.h"
#import "SDLRoofStatus.h"
#import "SDLRPCParameterNames.h"

QuickSpecBegin(SDLBodyInformationSpec)

NSArray<SDLDoorStatus *> *doorStatuses = @[[[SDLDoorStatus alloc] init]];
NSArray<SDLGateStatus *> *gateStatuses = @[[[SDLGateStatus alloc] init]];
NSArray<SDLRoofStatus *> *roofStatuses = @[[[SDLRoofStatus alloc] init]];
SDLIgnitionStableStatus ignitionStableStatus = SDLIgnitionStableStatusStable;
SDLIgnitionStatus ignitionStatus = SDLIgnitionStatusStart;
__block SDLBodyInformation* testStruct = nil;

describe(@"getter/setter tests", ^{
    afterEach(^{
        testStruct = nil;
    });
    
    context(@"init and assign", ^{
        beforeEach(^{
            testStruct = [[SDLBodyInformation alloc] init];
            testStruct.parkBrakeActive = @YES;
            testStruct.ignitionStableStatus = SDLIgnitionStableStatusStable;
            testStruct.ignitionStatus = SDLIgnitionStatusStart;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            testStruct.driverDoorAjar = @NO;
            testStruct.passengerDoorAjar = @NO;
            testStruct.rearLeftDoorAjar = @NO;
            testStruct.rearRightDoorAjar = @YES;
#pragma clang diagnostic pop
            testStruct.doorStatuses = doorStatuses;
            testStruct.gateStatuses = gateStatuses;
            testStruct.roofStatuses = roofStatuses;
        });

        it(@"expect struct is not nil", ^{
            expect(testStruct).notTo(beNil());
        });

        it(@"expect all properties to be set correctly", ^{
            expect(testStruct.parkBrakeActive).to(equal(@YES));
            expect(testStruct.ignitionStableStatus).to(equal(SDLIgnitionStableStatusStable));
            expect(testStruct.ignitionStatus).to(equal(SDLIgnitionStatusStart));
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            expect(testStruct.driverDoorAjar).to(equal(@NO));
            expect(testStruct.passengerDoorAjar).to(equal(@NO));
            expect(testStruct.rearLeftDoorAjar).to(equal(@NO));
            expect(testStruct.rearRightDoorAjar).to(equal(@YES));
#pragma clang diagnostic pop
            expect(testStruct.doorStatuses).to(equal(doorStatuses));
            expect(testStruct.gateStatuses).to(equal(gateStatuses));
            expect(testStruct.roofStatuses).to(equal(roofStatuses));
        });
    });

    context(@"initWithDictionary:", ^{
        beforeEach(^{
            NSDictionary* dict = @{
                SDLRPCParameterNameParkBrakeActive:@YES,
                SDLRPCParameterNameIgnitionStableStatus:SDLIgnitionStableStatusNotStable,
                SDLRPCParameterNameIgnitionStatus:SDLIgnitionStatusStart,
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                SDLRPCParameterNameDriverDoorAjar:@NO,
                SDLRPCParameterNamePassengerDoorAjar:@NO,
                SDLRPCParameterNameRearLeftDoorAjar:@NO,
                SDLRPCParameterNameRearRightDoorAjar:@YES,
#pragma clang diagnostic pop
                SDLRPCParameterNameDoorStatuses:doorStatuses,
                SDLRPCParameterNameGateStatuses:gateStatuses,
                SDLRPCParameterNameRoofStatuses:roofStatuses,
            };
            testStruct = [[SDLBodyInformation alloc] initWithDictionary:dict];
        });

        it(@"expect struct is not nil", ^{
            expect(testStruct).notTo(beNil());
        });

        it(@"expect all properties to be set correctly", ^{
            expect(testStruct.parkBrakeActive).to(equal(@YES));
            expect(testStruct.ignitionStableStatus).to(equal(SDLIgnitionStableStatusNotStable));
            expect(testStruct.ignitionStatus).to(equal(SDLIgnitionStatusStart));
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            expect(testStruct.driverDoorAjar).to(equal(@NO));
            expect(testStruct.passengerDoorAjar).to(equal(@NO));
            expect(testStruct.rearLeftDoorAjar).to(equal(@NO));
            expect(testStruct.rearRightDoorAjar).to(equal(@YES));
#pragma clang diagnostic pop
            expect(testStruct.doorStatuses).to(equal(doorStatuses));
            expect(testStruct.gateStatuses).to(equal(gateStatuses));
            expect(testStruct.roofStatuses).to(equal(roofStatuses));
        });
    });

    context(@"init", ^{
        beforeEach(^{
            testStruct = [[SDLBodyInformation alloc] init];
        });

        it(@"expect struct is not nil", ^{
            expect(testStruct).notTo(beNil());
        });

        it(@"expect all properties to be nil", ^{
            expect(testStruct.parkBrakeActive).to(beNil());
            expect(testStruct.ignitionStableStatus).to(beNil());
            expect(testStruct.ignitionStatus).to(beNil());
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Wdeprecated-declarations"
            expect(testStruct.driverDoorAjar).to(beNil());
            expect(testStruct.passengerDoorAjar).to(beNil());
            expect(testStruct.rearLeftDoorAjar).to(beNil());
            expect(testStruct.rearRightDoorAjar).to(beNil());
    #pragma clang diagnostic pop
            expect(testStruct.doorStatuses).to(beNil());
            expect(testStruct.gateStatuses).to(beNil());
            expect(testStruct.roofStatuses).to(beNil());
        });
    });

    context(@"initWithParkBrakeActive:ignitionStableStatus:ignitionStatus:", ^{
        beforeEach(^{
            testStruct = [[SDLBodyInformation alloc] initWithParkBrakeActive:YES ignitionStableStatus:ignitionStableStatus ignitionStatus:ignitionStatus];
        });

        it(@"expect struct is not nil", ^{
            expect(testStruct).notTo(beNil());
        });

        it(@"expect all properties to be set correctly", ^{
            expect(testStruct.parkBrakeActive).to(equal(@YES));
            expect(testStruct.ignitionStableStatus).to(equal(ignitionStableStatus));
            expect(testStruct.ignitionStatus).to(equal(ignitionStatus));
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            expect(testStruct.driverDoorAjar).to(beNil());
            expect(testStruct.passengerDoorAjar).to(beNil());
            expect(testStruct.rearLeftDoorAjar).to(beNil());
            expect(testStruct.rearRightDoorAjar).to(beNil());
#pragma clang diagnostic pop
            expect(testStruct.doorStatuses).to(beNil());
            expect(testStruct.gateStatuses).to(beNil());
            expect(testStruct.roofStatuses).to(beNil());
        });
    });

    context(@"initWithParkBrakeActive:ignitionStableStatus:ignitionStatus:", ^{
        beforeEach(^{
            testStruct = [[SDLBodyInformation alloc] initWithParkBrakeActive:YES ignitionStableStatus:ignitionStableStatus ignitionStatus:ignitionStatus doorStatuses:doorStatuses gateStatuses:gateStatuses roofStatuses:roofStatuses];
        });

        it(@"expect struct is not nil", ^{
            expect(testStruct).notTo(beNil());
        });

        it(@"expect all properties to be set correctly", ^{
            expect(testStruct.parkBrakeActive).to(equal(@YES));
            expect(testStruct.ignitionStableStatus).to(equal(ignitionStableStatus));
            expect(testStruct.ignitionStatus).to(equal(ignitionStatus));
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            expect(testStruct.driverDoorAjar).to(beNil());
            expect(testStruct.passengerDoorAjar).to(beNil());
            expect(testStruct.rearLeftDoorAjar).to(beNil());
            expect(testStruct.rearRightDoorAjar).to(beNil());
#pragma clang diagnostic pop
            expect(testStruct.doorStatuses).to(equal(doorStatuses));
            expect(testStruct.gateStatuses).to(equal(gateStatuses));
            expect(testStruct.roofStatuses).to(equal(roofStatuses));
        });
    });
});

QuickSpecEnd
