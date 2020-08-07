//
//  SDLLockedMutableArraySpec.m
//  SmartDeviceLinkTests
//
//  Created by Joel Fischer on 8/5/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLLockedMutableArray.h"

QuickSpecBegin(SDLLockedMutableArraySpec)

describe(@"a locked dictionary", ^{
    __block dispatch_queue_t testQueue = NULL;
    __block SDLLockedMutableArray *testArray = nil;

    __block NSString *objectString = @"testObj";

    beforeEach(^{
        testQueue = dispatch_queue_create("com.testqueue", DISPATCH_QUEUE_SERIAL);
        testArray = [[SDLLockedMutableArray alloc] initWithQueue:testQueue];
    });

    context(@"on a different queue", ^{
        it(@"should add, retrieve, and remove an object repeatedly", ^{
            for(int i = 0; i < 5000; i++) {
                [testArray addObject:objectString];
                (void)testArray[0];
                [testArray removeObjectAtIndex:0];
                expect(testArray.count).to(equal(0));
            }
        });

        it(@"should remove all objects properly", ^{
            for(int i = 0; i < 5000; i++) {
                [testArray addObject:objectString];
            }

            expect(testArray.count).to(equal(5000));
            [testArray removeAllObjects];
            expect(testArray.count).to(equal(0));
        });

        it(@"should insert objects at the front properly", ^{
            for(int i = 0; i < 5000; i++) {
                [testArray insertObject:@(i) atIndex:0];
            }

            expect(testArray.count).to(equal(5000));
            expect(testArray[4999]).to(equal(@0));
            expect(testArray[0]).to(equal(@4999));
        });
    });

    context(@"on the same queue", ^{
        it(@"should add, retrieve, and remove an object repeatedly", ^{
            dispatch_sync(testQueue, ^{
                for(int i = 0; i < 5000; i++) {
                    [testArray addObject:objectString];
                    (void)testArray[0];
                    [testArray removeObjectAtIndex:0];
                    expect(testArray.count).to(equal(0));
                }
            });
        });
    });
});

QuickSpecEnd

