//
//  SDLLockedMutableSetSpec.m
//  SmartDeviceLinkTests
//
//  Created by Joel Fischer on 8/7/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLLockedMutableSet.h"

QuickSpecBegin(SDLLockedMutableSetSpec)

describe(@"a locked set", ^{
    __block dispatch_queue_t testQueue = NULL;
    __block SDLLockedMutableSet *testSet = nil;

    __block NSString *objectString = @"testObj";

    beforeEach(^{
        testQueue = dispatch_queue_create("com.testqueue", DISPATCH_QUEUE_SERIAL);
        testSet = [[SDLLockedMutableSet alloc] initWithQueue:testQueue];
    });

    context(@"on a different queue", ^{
        it(@"should add, retrieve, and remove an object repeatedly", ^{
            for(int i = 0; i < 5000; i++) {
                [testSet addObject:objectString];
                [testSet removeAllObjects];
                expect(testSet.count).to(equal(0));
            }
        });

        it(@"should remove all objects properly", ^{
            for(int i = 0; i < 5000; i++) {
                [testSet addObject:[NSString stringWithFormat:@"%@", @(i)]];
            }

            expect(testSet.count).to(equal(5000));
            [testSet removeAllObjects];
            expect(testSet.count).to(equal(0));
        });
    });

    context(@"on the same queue", ^{
        it(@"should add, retrieve, and remove an object repeatedly", ^{
            dispatch_sync(testQueue, ^{
                for(int i = 0; i < 5000; i++) {
                    [testSet addObject:objectString];
                    [testSet removeAllObjects];
                    expect(testSet.count).to(equal(0));
                }
            });
        });
    });
});


QuickSpecEnd
