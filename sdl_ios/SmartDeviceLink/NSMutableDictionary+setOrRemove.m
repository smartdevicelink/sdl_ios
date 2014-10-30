//
//  NSMutableDictionary+setOrRemove.m
//  SmartDeviceLink
//
//  Created by Justin Dickow on 10/29/14.
//  Copyright (c) 2014 FMC. All rights reserved.
//

#import "NSMutableDictionary+setOrRemove.h"

@implementation NSMutableDictionary (setOrRemove)
- (void)setOrRemoveObject:(id)object forKey:(id <NSCopying>)key {
    if (nil != object) {
        [self setObject:object forKey:key];
    } else {
        [self removeObjectForKey:key];
    }
}
@end
