//
//  NSDictionary+SafeRemove.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 7/21/16.
//  Copyright © 2016 smartdevicelink. All rights reserved.
//

#import "NSMutableDictionary+SafeRemove.h"

@implementation NSMutableDictionary (SafeRemove)

- (BOOL)safeRemoveObjectForKey:(id)aKey {
    if ([self objectForKey:aKey] != nil) {
        [self removeObjectForKey:aKey];

        return YES;
    }

    return NO;
}

@end

@implementation NSMapTable (SafeRemove)

- (BOOL)safeRemoveObjectForKey:(id)aKey {
    if ([self objectForKey:aKey] != nil) {
        [self removeObjectForKey:aKey];

        return YES;
    }

    return NO;
}

@end
