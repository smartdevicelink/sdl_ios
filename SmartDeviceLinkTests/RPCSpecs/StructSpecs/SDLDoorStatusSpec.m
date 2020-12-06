//
//  SDLBodyInformationSpec.m
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

describe(@"getter/setter tests", ^{
    context(@"init and assign", ^{
        SDLDoorStatus* testStruct = [[SDLDoorStatus alloc] init];
        testStruct.location = location;
        testStruct.status = status;

        it(@"expect all properties to be set correctly", ^{
            expect(testStruct.location).to(equal(location));
            expect(testStruct.status).to(equal(status));
        });
    });

    context(@"initWithDictionary:", ^{
        NSDictionary* dict = @{
            SDLRPCParameterNameLocation:location,
            SDLRPCParameterNameStatus:status,
        };
        SDLDoorStatus *testStruct = [[SDLDoorStatus alloc] initWithDictionary:dict];

        it(@"expect all properties to be set correctly", ^{
            expect(testStruct.location).to(equal(location));
            expect(testStruct.status).to(equal(status));
        });
    });

    context(@"init", ^{
        SDLDoorStatus *testStruct = [[SDLDoorStatus alloc] init];

        it(@"expect all properties to be nil", ^{
            expect(testStruct.location).to(beNil());
            expect(testStruct.status).to(beNil());
        });
    });

    context(@"initWithLocation:status:", ^{
        SDLDoorStatus *testStruct = [[SDLDoorStatus alloc] initWithLocation:location status:status];
        testStruct.location = location;
        testStruct.status = status;

        it(@"expect all properties to be set correctly", ^{
            expect(testStruct.location).to(equal(location));
            expect(testStruct.status).to(equal(status));
        });
    });
});

QuickSpecEnd
