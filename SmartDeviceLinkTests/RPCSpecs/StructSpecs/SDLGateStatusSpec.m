//
//  SDLBodyInformationSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLDoorStatusType.h"
#import "SDLGateStatus.h"
#import "SDLGrid.h"
#import "SDLIgnitionStableStatus.h"
#import "SDLRPCParameterNames.h"

QuickSpecBegin(SDLGateStatusSpec)

SDLGrid *location = [[SDLGrid alloc] init];
SDLDoorStatusType status = SDLDoorStatusTypeAjar;

describe(@"getter/setter tests", ^{
    context(@"init and assign", ^{
        SDLGateStatus *testStruct = [[SDLGateStatus alloc] init];
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
        SDLGateStatus *testStruct = [[SDLGateStatus alloc] initWithDictionary:dict];

        it(@"expect all properties to be set correctly", ^{
            expect(testStruct.location).to(equal(location));
            expect(testStruct.status).to(equal(status));
        });
    });

    context(@"init", ^{
        SDLGateStatus *testStruct = [[SDLGateStatus alloc] init];

        it(@"expect all properties to be nil", ^{
            expect(testStruct.location).to(beNil());
            expect(testStruct.status).to(beNil());
        });
    });

    context(@"initWithLocation:status:", ^{
        SDLGateStatus *testStruct = [[SDLGateStatus alloc] initWithLocation:location status:status];
        testStruct.location = location;
        testStruct.status = status;

        it(@"expect all properties to be set correctly", ^{
            expect(testStruct.location).to(equal(location));
            expect(testStruct.status).to(equal(status));
        });
    });
});

QuickSpecEnd
