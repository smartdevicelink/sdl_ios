//
//  NSMapTable+Subscripting.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 10/5/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import "NSMapTable+Subscripting.h"

NS_ASSUME_NONNULL_BEGIN

@implementation NSMapTable (Subscripting)

- (void)setObject:(nullable id)anObject forKeyedSubscript:(id<NSCopying>)key {
    [self setObject:anObject forKey:key];
}

- (nullable id)objectForKeyedSubscript:(id<NSCopying>)key {
    return [self objectForKey:key];
}

@end

NS_ASSUME_NONNULL_END