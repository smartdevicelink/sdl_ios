//
//  SDLDoorStatusSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLDoorStatus.h"
#import "SDLDoorStatusType.h"
#import "SDLGrid.h"
#import "SDLRPCParameterNames.h"

QuickSpecBegin(SDLDoorStatusSpec)

SDLGrid *location = [[SDLGrid alloc] init];
SDLDoorStatusType status = SDLDoorStatusTypeAjar;
__block SDLDoorStatus* testStruct = nil;

describe(@"getter/setter tests", ^{
    afterEach(^{
        testStruct = nil;
    });

    context(@"init and assign", ^{
        beforeEach(^{
            testStruct = [[SDLDoorStatus alloc] init];
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
            NSDictionary* dict = @{
                SDLRPCParameterNameLocation:location,
                SDLRPCParameterNameStatus:status,
            };
            testStruct = [[SDLDoorStatus alloc] initWithDictionary:dict];
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
            testStruct = [[SDLDoorStatus alloc] init];
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
            testStruct = [[SDLDoorStatus alloc] initWithLocation:location status:status];
        });

        it(@"expect struct is not nil", ^{
            expect(testStruct).notTo(beNil());
        });

        testStruct.location = location;
        testStruct.status = status;

        it(@"expect all properties to be set correctly", ^{
            expect(testStruct.location).to(equal(location));
            expect(testStruct.status).to(equal(status));
        });
    });
});

QuickSpecEnd
