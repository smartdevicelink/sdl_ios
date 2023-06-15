//
//  NSArray+ExtensionsSpec.m
//  SmartDeviceLinkTests
//
//  Created by Joel Fischer on 2/22/21.
//  Copyright © 2021 smartdevicelink. All rights reserved.
//

#import "NSArray+Extensions.h"

@import Quick;
@import Nimble;

QuickSpecBegin(NSArray_ExtensionsSpec)

describe(@"checking the dynamic hash of an array", ^{
    __block NSArray *testArray = nil;

    beforeEach(^{
        testArray = nil;
    });

    context(@"when the array has no objects", ^{
        beforeEach(^{
            testArray = @[];
        });

        it(@"should return a dynamic hash of 0", ^{
            expect(testArray.dynamicHash).to(equal(0));
        });
    });

    context(@"when the array contains one string", ^{
        beforeEach(^{
            testArray = @[@"test string"];
        });

        it(@"should return a consistent dynamic hash", ^{
            expect(testArray.dynamicHash).to(equal(testArray.dynamicHash));
        });

        it(@"should return a different hash than the normal hash function", ^{
            expect(testArray.dynamicHash).toNot(equal(testArray.hash));
        });
    });

    context(@"when the array contains multiple strings", ^{
        it(@"should return different numbers depending on where the strings are in the array", ^{
            testArray = @[@"test string", @"test string 2"];
            NSUInteger hash1 = testArray.dynamicHash;

            testArray = @[@"test string 2", @"test string"];
            NSUInteger hash2 = testArray.dynamicHash;

            expect(hash1).toNot(equal(hash2));
        });
    });
});

QuickSpecEnd
