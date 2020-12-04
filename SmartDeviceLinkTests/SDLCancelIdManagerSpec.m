//
//  SDLCancelIdManagerSpec.m
//  SmartDeviceLinkTests
//
//  Created by Nicole on 12/4/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLCancelIdManager.h"

@interface SDLCancelIdManager()

@property (copy, nonatomic) dispatch_queue_t readWriteQueue;
@property (assign, nonatomic) UInt16 nextCancelId;

@end

QuickSpecBegin(SDLCancelIdManagerSpec)

describe(@"Cancel Id Manager", ^{
    __block SDLCancelIdManager *testManager = nil;

    describe(@"initialization", ^{
        it(@"should setup correctly", ^{
            testManager = [[SDLCancelIdManager alloc] init];

            expect(@(testManager.nextCancelId)).to(equal(@1));
            expect(testManager.readWriteQueue).toNot(beNil());
        });
    });

    describe(@"getting the next cancel id", ^{
        beforeEach(^{
            testManager = [[SDLCancelIdManager alloc] init];
        });

        it(@"should count-up by 1", ^{
            NSUInteger testNextCancelID = [testManager nextCancelId];
            expect(@(testNextCancelID)).to(equal(@1));

            NSUInteger testNextCancelID2 = [testManager nextCancelId];
            expect(@(testNextCancelID2)).to(equal(@2));
        });
    });

    describe(@"stopping the manager", ^{
        beforeEach(^{
            testManager = [[SDLCancelIdManager alloc] init];
            testManager.nextCancelId = 500;
            [testManager stop];
        });

        it(@"should reset the min cancel id and still count-up by 1", ^{
            NSUInteger testNextCancelID = [testManager nextCancelId];
            expect(@(testNextCancelID)).to(equal(@1));

            NSUInteger testNextCancelID2 = [testManager nextCancelId];
            expect(@(testNextCancelID2)).to(equal(@2));
        });
    });
});

QuickSpecEnd



