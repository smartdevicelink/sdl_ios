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
    NSUInteger retVal = 0;
    for (NSUInteger i = 0; i < self.count; i++) {
        retVal ^= NSUIntRotateCell(((NSObject *)self[i]).hash, (NSUIntBitCell / (i + 2)));
    }

    return retVal;
}


@end
