//
//  SDLUnsubscribeVehicleDataResponseSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLSeatStatus.h"
#import "SDLSeatLocation.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

QuickSpecBegin(SDLSeatStatusSpec)

SDLSeatLocation *seatLocation = [[SDLSeatLocation alloc] init];
NSNumber<SDLBool> *conditionActive = @YES;

describe(@"getter/setter tests", ^{
    context(@"init", ^{
        SDLSeatStatus* testStruct = [[SDLSeatStatus alloc] init];
        testStruct.conditionActive = conditionActive;
        testStruct.seatLocation = seatLocation;

        it(@"expect all properties to be set properly", ^{
            expect(testStruct.conditionActive).to(equal(conditionActive));
            expect(testStruct.seatLocation).to(equal(seatLocation));
        });
    });

    context(@"initWithDictionary:", ^{
        NSDictionary *dict = @{
            SDLRPCParameterNameConditionActive:conditionActive,
            SDLRPCParameterNameSeatLocation:seatLocation,
        };

        SDLSeatStatus* testStruct = [[SDLSeatStatus alloc] initWithDictionary:dict];

        it(@"expect all properties to be set properly", ^{
            expect(testStruct.conditionActive).to(equal(conditionActive));
            expect(testStruct.seatLocation).to(equal(seatLocation));
        });
    });

    context(@"init", ^{
        SDLSeatStatus* testStruct = [[SDLSeatStatus alloc] init];

        it(@"expect all properties to be nil", ^{
            expect(testStruct.conditionActive).to(beNil());
            expect(testStruct.seatLocation).to(beNil());
        });
    });

    context(@"initWithSeatsOccupied:seatsBelted:", ^{
        SDLSeatStatus* testStruct = [[SDLSeatStatus alloc] initWithSeatLocation:seatLocation conditionActive:conditionActive];

        it(@"expect all properties to be set properly", ^{
            expect(testStruct.conditionActive).to(equal(conditionActive));
            expect(testStruct.seatLocation).to(equal(seatLocation));
        });
    });
});

QuickSpecEnd
