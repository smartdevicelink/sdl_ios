//
//  NSMutableDictionary+Store.m
//  SmartDeviceLink-iOS
//
//  Created by Muller, Alexander (A.) on 11/7/16.
//  Copyright © 2016 smartdevicelink. All rights reserved.
//

#import "NSMutableDictionary+Store.h"

@implementation NSMutableDictionary (Store)

- (void)sdl_setObject:(NSObject *)object forName:(SDLName)name {
    if (object != nil) {
        self[name] = object;
    } else {
        [self removeObjectForKey:name];
    }
}

- (id)sdl_objectForName:(SDLName)name {
    return self[name];
}

- (id)sdl_objectForName:(SDLName)name ofClass:(Class)classType {
    NSObject *obj = [self sdl_objectForName:name];
    if (obj == nil || [obj isKindOfClass:classType.class]) {
        return obj;
    } else {
        return [[classType alloc] initWithDictionary:(NSDictionary *)obj];
    }
}

- (NSMutableArray *)sdl_objectsForName:(SDLName)name ofClass:(Class)classType {
    NSMutableArray *array = [self sdl_objectForName:name];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:classType.class]) {
        return array;
    } else {
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSDictionary<NSString *, id> *dict in array) {
            [newList addObject:[[classType alloc] initWithDictionary:dict]];
        }
        return newList;
    }
}


@end
