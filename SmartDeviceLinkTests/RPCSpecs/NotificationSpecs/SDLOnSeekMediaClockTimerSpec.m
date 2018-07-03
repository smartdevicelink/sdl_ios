//
//  SDLOnSeekMediaClockTimer.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLNames.h"
#import "SDLOnSeekMediaClockTimer.h"
#import "SDLStartTime.h"

QuickSpecBegin(SDLOnSeekMediaClockTimerSpec)

describe(@"OnSeekMediaClockTimer Tests", ^{
    __block SDLOnSeekMediaClockTimer *testNotification = nil;
    __block SDLStartTime *testSeekTime = nil;

    beforeEach(^{
        testSeekTime = [[SDLStartTime alloc] initWithHours:1 minutes:0 seconds:0];
    });

    describe(@"initializers", ^{
        it(@"should initialize correctly with init", ^{
            testNotification = [[SDLOnSeekMediaClockTimer alloc] init];

            expect(testNotification).toNot(beNil());
            expect(testNotification.seekTime).to(beNil());
        });

        it(@"should initialize correctly with initWithDictionary", ^{
            NSDictionary *dict = @{SDLNameNotification:
                                       @{SDLNameParameters:
                                             @{SDLNameSeekTime: testSeekTime},
                                         SDLNameOperationName: SDLNameOnSeekMediaClockTimer
                                         }
                                   };

            testNotification = [[SDLOnSeekMediaClockTimer alloc] initWithDictionary:dict];

            expect(testNotification).toNot(beNil());
            expect(testNotification.seekTime).to(equal(testSeekTime));
        });
    });

    describe(@"getters and setters", ^{
        it(@"should set correctly", ^{
            testNotification = [[SDLOnSeekMediaClockTimer alloc] init];
            testNotification.seekTime = testSeekTime;

            expect(testNotification.seekTime).to(equal(testSeekTime));
        });
    });
});

QuickSpecEnd
