//
//  NSMapTable+Subscripting.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 10/5/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import "NSMapTable+Subscripting.h"

@implementation NSMapTable (Subscripting)

- (void)setObject:(id)anObject forKeyedSubscript:(id<NSCopying>)key {
    [self setObject:anObject forKey:key];
}

- (id)objectForKeyedSubscript:(id<NSCopying>)key {
    return [self objectForKey:key];
}

@end
