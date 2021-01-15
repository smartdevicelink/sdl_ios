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
        it(@"expect all properties to be set properly", ^{
            SDLSeatStatus* testStruct = [[SDLSeatStatus alloc] init];
            testStruct.conditionActive = conditionActive;
            testStruct.seatLocation = seatLocation;

            expect(testStruct.conditionActive).to(equal(conditionActive));
            expect(testStruct.seatLocation).to(equal(seatLocation));
        });
    });

    context(@"initWithDictionary:", ^{
        it(@"expect all properties to be set properly", ^{
            NSDictionary *dict = @{
                SDLRPCParameterNameConditionActive:conditionActive,
                SDLRPCParameterNameSeatLocation:seatLocation,
            };

            SDLSeatStatus* testStruct = [[SDLSeatStatus alloc] initWithDictionary:dict];

            expect(testStruct.conditionActive).to(equal(conditionActive));
            expect(testStruct.seatLocation).to(equal(seatLocation));
        });
    });

    context(@"init", ^{
        it(@"expect all properties to be nil", ^{
            SDLSeatStatus* testStruct = [[SDLSeatStatus alloc] init];

            expect(testStruct.conditionActive).to(beNil());
            expect(testStruct.seatLocation).to(beNil());
        });
    });

    context(@"initWithSeatsOccupied:seatsBelted:", ^{
        it(@"expect all properties to be set properly", ^{
                SDLSeatStatus* testStruct = [[SDLSeatStatus alloc] initWithSeatLocation:seatLocation conditionActive:conditionActive];

            expect(testStruct.conditionActive).to(equal(conditionActive));
            expect(testStruct.seatLocation).to(equal(seatLocation));
        });
    });
});

QuickSpecEnd
