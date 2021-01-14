//
//  SDLRoofStatusSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLDoorStatusType.h"
#import "SDLGrid.h"
#import "SDLRoofStatus.h"
#import "SDLRPCParameterNames.h"
#import "SDLWindowState.h"

QuickSpecBegin(SDLRoofStatusSpec)

SDLGrid *location = [[SDLGrid alloc] init];
SDLDoorStatusType status = SDLDoorStatusTypeAjar;
SDLWindowState *state = [[SDLWindowState alloc] init];
__block SDLRoofStatus* testStruct = nil;

describe(@"getter/setter tests", ^{
    afterEach(^{
        testStruct = nil;
    });

    context(@"init and assign", ^{
        beforeEach(^{
            testStruct = [[SDLRoofStatus alloc] init];
            testStruct.location = location;
            testStruct.status = status;
            testStruct.state = state;
        });

        it(@"expect struct is not nil", ^{
            expect(testStruct).notTo(beNil());
        });

        it(@"expect all properties to be set correctly", ^{
            expect(testStruct.location).to(equal(location));
            expect(testStruct.status).to(equal(status));
            expect(testStruct.state).to(equal(state));
        });
    });

    context(@"initWithDictionary:", ^{
        beforeEach(^{
            NSDictionary* dict = @{
                SDLRPCParameterNameLocation:location,
                SDLRPCParameterNameStatus:status,
                SDLRPCParameterNameState:state,
            };
            testStruct = [[SDLRoofStatus alloc] initWithDictionary:dict];
        });

        it(@"expect struct is not nil", ^{
            expect(testStruct).notTo(beNil());
        });

        it(@"expect all properties to be set correctly", ^{
            expect(testStruct.location).to(equal(location));
            expect(testStruct.status).to(equal(status));
            expect(testStruct.state).to(equal(state));
        });
    });

    context(@"init", ^{
        beforeEach(^{
            testStruct = [[SDLRoofStatus alloc] init];
        });

        it(@"expect struct is not nil", ^{
            expect(testStruct).notTo(beNil());
        });

        it(@"expect all properties to be nil", ^{
            expect(testStruct.location).to(beNil());
            expect(testStruct.status).to(beNil());
            expect(testStruct.state).to(beNil());
        });
    });

    context(@"initWithLocation:status:", ^{
        beforeEach(^{
            testStruct = [[SDLRoofStatus alloc] initWithLocation:location status:status];
        });

        it(@"expect struct is not nil", ^{
            expect(testStruct).notTo(beNil());
        });

        it(@"expect all properties to be set correctly", ^{
            expect(testStruct.location).to(equal(location));
            expect(testStruct.status).to(equal(status));
            expect(testStruct.state).to(beNil());
        });
    });

    context(@"initWithLocation:status:state:", ^{
        beforeEach(^{
            testStruct = [[SDLRoofStatus alloc] initWithLocation:location status:status state:state];
        });

        it(@"expect struct is not nil", ^{
            expect(testStruct).notTo(beNil());
        });

        it(@"expect all properties to be set correctly", ^{
            expect(testStruct.location).to(equal(location));
            expect(testStruct.status).to(equal(status));
            expect(testStruct.state).to(equal(state));
        });
    });
});

QuickSpecEnd
