//
//  SDLGateStatusSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

@import Quick;
@import Nimble;

#import "SDLDoorStatusType.h"
#import "SDLGateStatus.h"
#import "SDLGrid.h"
#import "SDLIgnitionStableStatus.h"
#import "SDLRPCParameterNames.h"

QuickSpecBegin(SDLGateStatusSpec)

SDLGrid *location = [[SDLGrid alloc] init];
SDLDoorStatusType status = SDLDoorStatusTypeAjar;
__block SDLGateStatus *testStruct = nil;

describe(@"getter/setter tests", ^{
    context(@"init and assign", ^{
        beforeEach(^{
            testStruct = [[SDLGateStatus alloc] init];
            testStruct.location = location;
            testStruct.status = status;
        });

        it(@"expect struct is not nil", ^{
            expect(testStruct).notTo(beNil());
        });

        it(@"expect all properties to be set correctly", ^{
            expect(testStruct.location).to(equal(location));
            expect(testStruct.status).to(equal(status));
        });
    });

    context(@"initWithDictionary:", ^{
        beforeEach(^{
            NSDictionary *dict = @{
                SDLRPCParameterNameLocation:location,
                SDLRPCParameterNameStatus:status,
            };
            testStruct = [[SDLGateStatus alloc] initWithDictionary:dict];
        });

        it(@"expect struct is not nil", ^{
            expect(testStruct).notTo(beNil());
        });

        it(@"expect all properties to be set correctly", ^{
            expect(testStruct.location).to(equal(location));
            expect(testStruct.status).to(equal(status));
        });
    });

    context(@"init", ^{
        beforeEach(^{
            testStruct = [[SDLGateStatus alloc] init];
        });

        it(@"expect struct is not nil", ^{
            expect(testStruct).notTo(beNil());
        });

        it(@"expect all properties to be nil", ^{
            expect(testStruct.location).to(beNil());
            expect(testStruct.status).to(beNil());
        });
    });

    context(@"initWithLocation:status:", ^{
        beforeEach(^{
            testStruct = [[SDLGateStatus alloc] initWithLocation:location status:status];
            testStruct.location = location;
            testStruct.status = status;
        });

        it(@"expect struct is not nil", ^{
            expect(testStruct).notTo(beNil());
        });

        it(@"expect all properties to be set correctly", ^{
            expect(testStruct.location).to(equal(location));
            expect(testStruct.status).to(equal(status));
        });
    });
});

QuickSpecEnd
