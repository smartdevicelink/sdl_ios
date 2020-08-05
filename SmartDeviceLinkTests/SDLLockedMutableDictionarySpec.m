//
//  SDLLockedMutableDictionarySpec.m
//  SmartDeviceLinkTests
//
//  Created by Joel Fischer on 8/5/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLLockedMutableDictionary.h"

QuickSpecBegin(SDLLockedMutableDictionarySpec)

describe(@"a locked dictionary", ^{
    __block dispatch_queue_t testQueue = NULL;
    __block SDLLockedMutableDictionary *testDict = nil;

    __block NSString *objectString = @"testObj";
    __block NSString *keyString = @"testKey";

    beforeEach(^{
        testQueue = dispatch_queue_create("com.testqueue", DISPATCH_QUEUE_SERIAL);
        testDict = [[SDLLockedMutableDictionary alloc] initWithQueue:testQueue];
    });

    context(@"on a different queue", ^{
        context(@"not using subscripting", ^{
            it(@"should set, get, and remove a key-value pair repeatedly", ^{
                for(int i = 0; i < 5000; i++) {
                    [testDict setObject:objectString forKey:keyString];
                    [testDict objectForKey:keyString];
                    [testDict removeObjectForKey:keyString];

                    expect(testDict.count).to(equal(0));
                }
            });
        });
        context(@"using subscripting", ^{
            it(@"should set, get, and remove a key-value pair repeatedly", ^{
                for(int i = 0; i < 5000; i++) {
                    testDict[keyString] = objectString;
                    (void)testDict[keyString];
                    testDict[keyString] = nil;

                    expect(testDict.count).to(equal(0));
                }
            });
        });

        it(@"should remove all objects properly", ^{
            for(int i = 0; i < 5000; i++) {
                [testDict setObject:@(i) forKey:@(i)];
            }

            expect(testDict.count).to(equal(5000));
            [testDict removeAllObjects];
            expect(testDict.count).to(equal(0));
        });
    });

    context(@"on the same queue", ^{
        context(@"not using subscripting", ^{
            it(@"should set, get, and remove a key-value pair repeatedly", ^{
                dispatch_sync(testQueue, ^{
                    for(int i = 0; i < 5000; i++) {
                        [testDict setObject:objectString forKey:keyString];
                        [testDict objectForKey:keyString];
                        [testDict removeObjectForKey:keyString];

                        expect(testDict.count).to(equal(0));
                    }
                });
            });
        });
        context(@"using subscripting", ^{
            it(@"should set, get, and remove a key-value pair repeatedly", ^{
                dispatch_sync(testQueue, ^{
                    for(int i = 0; i < 5000; i++) {
                        testDict[keyString] = objectString;
                        (void)testDict[keyString];
                        testDict[keyString] = nil;

                        expect(testDict.count).to(equal(0));
                    }
                });
            });
        });
    });
});

QuickSpecEnd
