//
//  NSMutableDictionary+setOrRemove.m
//  SmartDeviceLink
//
//  Created by Justin Dickow on 10/29/14.
//  Copyright (c) 2014 FMC. All rights reserved.
//

#import "NSMutableDictionary+SetOrRemove.h"

@implementation NSMutableDictionary (SetOrRemove)
- (void)setOrRemoveObject:(id)object forKey:(id<NSCopying>)key {
    if (object != nil) {
        [self setObject:object forKey:key];
    } else {
        [self removeObjectForKey:key];
    }
}
@end
