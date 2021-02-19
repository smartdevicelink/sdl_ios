//
//  NSArray+Extensions.m
//  SmartDeviceLink
//
//  Created by Frank Elias on 2/18/21.
//  Copyright © 2021 smartdevicelink. All rights reserved.
//

#import "NSArray+Extensions.h"

@implementation NSArray (Extensions)

/// A dynamic version of the NSArray `hash` method. The default `hash` method returns the number of objects in the array as its hash and this leads to clashes between arrays with the same number of objects.
/// Instead, this method calls hash on each of it's sub-objects, XOR and rotates them, then returns this as the hash. This is much slower than the default hash method, but sometimes necessary to properly compare arrays.
/// @returns A hash based on the hashes of all of the contained objects
- (NSUInteger)dynamicHash {
    NSUInteger returnValue = 0;
    NSUInteger index = 0;
//    [self enumerateObjectsUsingBlock:^(NSObject *object, NSUInteger index, BOOL *stop) {
//        returnValue ^= NSUIntRotateCell(object.hash, NSUIntBitCell/(index+2));
//    }];

    for (NSObject *object in self) {
        returnValue ^= NSUIntRotateCell(object.hash, NSUIntBitCell/(index+2));
        index += 1;
    }

    return returnValue;
}


@end
