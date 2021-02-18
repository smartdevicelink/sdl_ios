//
//  NSArray+NSObject.m
//  SmartDeviceLink
//
//  Created by Frank Elias on 2/18/21.
//  Copyright © 2021 smartdevicelink. All rights reserved.
//

#import "NSArray+NSObject.h"

@implementation NSArray (NSObject)

NSUInteger const NSUIntBitCellDynamicHash = (CHAR_BIT * sizeof(NSUInteger));
NSUInteger NSUIntRotateCellDynamicHash(NSUInteger val, NSUInteger howMuch) {
    return ((((NSUInteger)val) << howMuch) | (((NSUInteger)val) >> (NSUIntBitCellDynamicHash - howMuch)));
}

- (NSUInteger)dynamicHash {
    NSUInteger returnValue = 0;
    for (NSObject *object in self) {
        returnValue += NSUIntRotateCellDynamicHash(object.hash, NSUIntBitCellDynamicHash/2);
    }
    return returnValue;
}


@end
