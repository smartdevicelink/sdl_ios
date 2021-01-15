//
//  SDLUnsubscribeVehicleDataResponseSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLSeatOccupancy.h"
#import "SDLSeatStatus.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

QuickSpecBegin(SDLSeatOccupancySpec)

SDLSeatStatus *seatStatus = [[SDLSeatStatus alloc] init];
NSArray *seatStatusArr = @[seatStatus];

describe(@"getter/setter tests", ^{
    context(@"init", ^{
        it(@"expect all properties to be set properly", ^{
            SDLSeatOccupancy* testStruct = [[SDLSeatOccupancy alloc] init];
            testStruct.seatsBelted = seatStatusArr;
            testStruct.seatsOccupied = seatStatusArr;

            expect(testStruct.seatsBelted).to(equal(seatStatusArr));
            expect(testStruct.seatsOccupied).to(equal(seatStatusArr));
        });
    });
    
    context(@"initWithDictionary:", ^{
        it(@"expect all properties to be set properly", ^{
            NSDictionary *dict = @{
                SDLRPCParameterNameSeatsBelted:seatStatusArr,
                SDLRPCParameterNameSeatsOccupied:seatStatusArr,
            };

            SDLSeatOccupancy* testStruct = [[SDLSeatOccupancy alloc] initWithDictionary:dict];

            expect(testStruct.seatsBelted).to(equal(seatStatusArr));
            expect(testStruct.seatsOccupied).to(equal(seatStatusArr));
        });
    });
    
    context(@"init", ^{
        it(@"expect all properties to be nil", ^{
            SDLSeatOccupancy* testStruct = [[SDLSeatOccupancy alloc] init];
            expect(testStruct.seatsBelted).to(beNil());
            expect(testStruct.seatsOccupied).to(beNil());
        });
    });

    context(@"initWithSeatsOccupied:seatsBelted:", ^{
        it(@"expect all properties to be set properly", ^{
            SDLSeatOccupancy* testStruct = [[SDLSeatOccupancy alloc] initWithSeatsOccupied:seatStatusArr seatsBelted:seatStatusArr];
            expect(testStruct.seatsBelted).to(equal(seatStatusArr));
            expect(testStruct.seatsOccupied).to(equal(seatStatusArr));
        });
    });
});

QuickSpecEnd
