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
        SDLSeatOccupancy* testStruct = [[SDLSeatOccupancy alloc] init];
        testStruct.seatsBelted = seatStatusArr;
        testStruct.seatsOccupied = seatStatusArr;

        it(@"expect all properties to be set properly", ^{
            expect(testStruct.seatsBelted).to(equal(seatStatusArr));
            expect(testStruct.seatsOccupied).to(equal(seatStatusArr));
        });
    });
    
    context(@"initWithDictionary:", ^{
        NSDictionary *dict = @{
            SDLRPCParameterNameSeatsBelted:seatStatusArr,
            SDLRPCParameterNameSeatsOccupied:seatStatusArr,
        };

        SDLSeatOccupancy* testStruct = [[SDLSeatOccupancy alloc] initWithDictionary:dict];

        it(@"expect all properties to be set properly", ^{
            expect(testStruct.seatsBelted).to(equal(seatStatusArr));
            expect(testStruct.seatsOccupied).to(equal(seatStatusArr));
        });
    });
    
    context(@"init", ^{
        SDLSeatOccupancy* testStruct = [[SDLSeatOccupancy alloc] init];

        it(@"expect all properties to be nil", ^{
            expect(testStruct.seatsBelted).to(beNil());
            expect(testStruct.seatsOccupied).to(beNil());
        });
    });

    context(@"initWithSeatsOccupied:seatsBelted:", ^{
        SDLSeatOccupancy* testStruct = [[SDLSeatOccupancy alloc] initWithSeatsOccupied:seatStatusArr seatsBelted:seatStatusArr];

        it(@"expect all properties to be set properly", ^{
            expect(testStruct.seatsBelted).to(equal(seatStatusArr));
            expect(testStruct.seatsOccupied).to(equal(seatStatusArr));
        });
    });
});

QuickSpecEnd
