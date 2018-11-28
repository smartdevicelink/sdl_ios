//
//  SDLStartTimeSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLStartTime.h"
#import "SDLNames.h"

QuickSpecBegin(SDLStartTimeSpec)

describe(@"StartTime Spec", ^ {
    describe(@"when initialized", ^{
        __block UInt8 testHours = 22;
        __block UInt8 testMinutes = 39;
        __block UInt8 testSeconds = 11;

        __block NSTimeInterval testTimeInterval = 81551;

        it(@"should properly initialize with init", ^{
            SDLStartTime *testStruct = [[SDLStartTime alloc] init];

            expect(testStruct.hours).to(beNil());
            expect(testStruct.minutes).to(beNil());
            expect(testStruct.seconds).to(beNil());
        });

        it(@"should properly initialize with initWithDictionary:", ^{
            NSDictionary<NSString *, id> *dict = @{SDLNameHours:@(testHours),
                                                   SDLNameMinutes:@(testMinutes),
                                                   SDLNameSeconds:@(testSeconds)};
            SDLStartTime *testStruct = [[SDLStartTime alloc] initWithDictionary:dict];

            expect(testStruct.hours).to(equal(@(testHours)));
            expect(testStruct.minutes).to(equal(@(testMinutes)));
            expect(testStruct.seconds).to(equal(@(testSeconds)));
        });

        it(@"should properly initialize with initWithTimeInterval:", ^{
            SDLStartTime *testStruct = [[SDLStartTime alloc] initWithTimeInterval:testTimeInterval];

            expect(testStruct.hours).to(equal(@(testHours)));
            expect(testStruct.minutes).to(equal(@(testMinutes)));
            expect(testStruct.seconds).to(equal(@(testSeconds)));
        });

        it(@"should properly initialize with initWithHours:minutes:seconds:", ^{
            SDLStartTime *testStruct = [[SDLStartTime alloc] initWithHours:testHours minutes:testMinutes seconds:testSeconds];

            expect(testStruct.hours).to(equal(@(testHours)));
            expect(testStruct.minutes).to(equal(@(testMinutes)));
            expect(testStruct.seconds).to(equal(@(testSeconds)));
        });
    });

    it(@"Should set and get correctly", ^ {
        SDLStartTime* testStruct = [[SDLStartTime alloc] init];
        
        testStruct.hours = @22;
        testStruct.minutes = @39;
        testStruct.seconds = @11;
        
        expect(testStruct.hours).to(equal(@22));
        expect(testStruct.minutes).to(equal(@39));
        expect(testStruct.seconds).to(equal(@11));
    });
});

QuickSpecEnd
