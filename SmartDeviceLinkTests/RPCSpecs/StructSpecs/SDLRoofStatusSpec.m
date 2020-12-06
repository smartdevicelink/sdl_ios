//
//  SDLBodyInformationSpec.m
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

describe(@"getter/setter tests", ^{
    context(@"init and assign", ^{
        SDLRoofStatus* testStruct = [[SDLRoofStatus alloc] init];
        testStruct.location = location;
        testStruct.status = status;
        testStruct.state = state;

        it(@"expect all properties to be set correctly", ^{
            expect(testStruct.location).to(equal(location));
            expect(testStruct.status).to(equal(status));
            expect(testStruct.state).to(equal(state));
        });
    });

    context(@"initWithDictionary:", ^{
        NSDictionary* dict = @{
            SDLRPCParameterNameLocation:location,
            SDLRPCParameterNameStatus:status,
            SDLRPCParameterNameState:state,
        };
        SDLRoofStatus* testStruct = [[SDLRoofStatus alloc] initWithDictionary:dict];

        it(@"expect all properties to be set correctly", ^{
            expect(testStruct.location).to(equal(location));
            expect(testStruct.status).to(equal(status));
            expect(testStruct.state).to(equal(state));
        });
    });

    context(@"init", ^{
        SDLRoofStatus* testStruct = [[SDLRoofStatus alloc] init];

        it(@"expect all properties to be nil", ^{
            expect(testStruct.location).to(beNil());
            expect(testStruct.status).to(beNil());
            expect(testStruct.state).to(beNil());
        });
    });

    context(@"initWithLocation:status:", ^{
        SDLRoofStatus* testStruct = [[SDLRoofStatus alloc] initWithLocation:location status:status];

        it(@"expect all properties to be set correctly", ^{
            expect(testStruct.location).to(equal(location));
            expect(testStruct.status).to(equal(status));
            expect(testStruct.state).to(beNil());
        });
    });

    context(@"initWithLocation:status:state:", ^{
        SDLRoofStatus* testStruct = [[SDLRoofStatus alloc] initWithLocation:location status:status state:state];

        it(@"expect all properties to be set correctly", ^{
            expect(testStruct.location).to(equal(location));
            expect(testStruct.status).to(equal(status));
            expect(testStruct.state).to(equal(state));
        });
    });
});

QuickSpecEnd
