//
//  DispatchTimerSpec.m
//  SmartDeviceLink-iOS
//
//  Created by Muller, Alexander (A.) on 7/1/16.
//  Copyright © 2016 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <OCMock/OCMock.h>

#import "dispatch_timer.h"

QuickSpecBegin(DispatchTimerSpec)

describe(@"dispatch_timer Tests", ^{
    context(@"Creating", ^{
        it(@"should be successful within specified time", ^{
            waitUntilTimeout(4, ^(void (^done)(void)) {
                __block double currentTime = [[NSDate date] timeIntervalSince1970];
                dispatch_create_timer(2.5, false, ^{
                    double difference = [[NSDate date] timeIntervalSince1970] - currentTime;
                    expect(@(difference)).to(beCloseTo(@2.5).within(0.1));
                    done();
                });
            });
        });
        
        it(@"should be cancellable and not fire", ^{
            __block dispatch_source_t timer;
            waitUntilTimeout(2, ^(void (^done)(void)) {
                timer = dispatch_create_timer(2.5, false, ^{
                    fail();
                });
                [NSThread sleepForTimeInterval:0.5];
                dispatch_stop_timer(timer);
                done();
            });
            expect(@(dispatch_source_testcancel(timer))).to(beGreaterThan(@0));
        });
    });
});

QuickSpecEnd