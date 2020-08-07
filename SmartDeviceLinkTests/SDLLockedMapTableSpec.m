//
//  SDLLockedMapTableSpec.m
//  SmartDeviceLinkTests
//
//  Created by Joel Fischer on 8/7/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLLockedMapTable.h"

QuickSpecBegin(SDLLockedMapTableSpec)

describe(@"a locked map table", ^{
    __block dispatch_queue_t testQueue = NULL;
    __block SDLLockedMapTable *testMapTable = nil;

    __block NSString *objectString = @"testObj";
    __block NSString *keyString = @"testKey";

    beforeEach(^{
        testQueue = dispatch_queue_create("com.testqueue", DISPATCH_QUEUE_SERIAL);
        testMapTable = [[SDLLockedMapTable alloc] initWithKeyOptions:NSMapTableStrongMemory valueOptions:NSMapTableStrongMemory queue:testQueue];
    });

    context(@"on a different queue", ^{
        context(@"not using subscripting", ^{
            it(@"should set, get, and remove a key-value pair repeatedly", ^{
                for(int i = 0; i < 5000; i++) {
                    [testMapTable setObject:objectString forKey:keyString];
                    [testMapTable objectForKey:keyString];
                    [testMapTable removeObjectForKey:keyString];

                    expect(testMapTable.count).to(equal(0));
                }
            });
        });
        context(@"using subscripting", ^{
            it(@"should set, get, and remove a key-value pair repeatedly", ^{
                for(int i = 0; i < 5000; i++) {
                    testMapTable[keyString] = objectString;
                    (void)testMapTable[keyString];
                    testMapTable[keyString] = nil;

                    expect(testMapTable.count).to(equal(0));
                }
            });
        });

        it(@"should remove all objects properly", ^{
            for(int i = 0; i < 5000; i++) {
                [testMapTable setObject:@(i) forKey:@(i)];
            }

            expect(testMapTable.count).to(equal(5000));
            [testMapTable removeAllObjects];
            expect(testMapTable.count).to(equal(0));
        });

        it(@"should create a dictionary representation properly", ^{
            [testMapTable setObject:@1 forKey:@1];

            NSDictionary *mapDict = testMapTable.dictionaryRepresentation;
            expect(mapDict).toNot(beNil());
            expect(mapDict).to(haveCount(1));
        });
    });

    context(@"on the same queue", ^{
        context(@"not using subscripting", ^{
            it(@"should set, get, and remove a key-value pair repeatedly", ^{
                dispatch_sync(testQueue, ^{
                    for(int i = 0; i < 5000; i++) {
                        [testMapTable setObject:objectString forKey:keyString];
                        [testMapTable objectForKey:keyString];
                        [testMapTable removeObjectForKey:keyString];

                        expect(testMapTable.count).to(equal(0));
                    }
                });
            });
        });
        context(@"using subscripting", ^{
            it(@"should set, get, and remove a key-value pair repeatedly", ^{
                dispatch_sync(testQueue, ^{
                    for(int i = 0; i < 5000; i++) {
                        testMapTable[keyString] = objectString;
                        (void)testMapTable[keyString];
                        testMapTable[keyString] = nil;

                        expect(testMapTable.count).to(equal(0));
                    }
                });
            });
        });
    });
});

QuickSpecEnd
