//
//  NSMutableDictionary+Store.m
//  SmartDeviceLink-iOS
//
//  Created by Muller, Alexander (A.) on 11/7/16.
//  Copyright © 2016 smartdevicelink. All rights reserved.
//

#import "NSMutableDictionary+Store.h"

NS_ASSUME_NONNULL_BEGIN

@implementation NSMutableDictionary (Store)

- (void)sdl_setObject:(NSObject *)object forName:(SDLName)name {
    if (object != nil) {
        self[name] = object;
    } else {
        [self removeObjectForKey:name];
    }
}

- (nullable id)sdl_objectForName:(SDLName)name {
    return self[name];
}

- (nullable id)sdl_objectForName:(SDLName)name ofClass:(Class)classType {
    NSObject *obj = [self sdl_objectForName:name];
    if (obj == nil || [obj isKindOfClass:classType]) {
        return obj;
    } else {
        return [[classType alloc] initWithDictionary:(NSDictionary *)obj];
    }
}

- (NSArray *)sdl_objectsForName:(SDLName)name ofClass:(Class)classType {
    NSArray *array = [self sdl_objectForName:name];
    if ([array isEqual:[NSNull null]]) {
        return [NSMutableArray array];
    } else if (array.count < 1 || [array.firstObject isMemberOfClass:classType]) {
        // It's an array of the actual class type, just return
        return array;
    } else {
        // It's an array of dictionaries, make them into their class type
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:array.count];
        for (NSDictionary<NSString *, id> *dict in array) {
            [newList addObject:[[classType alloc] initWithDictionary:dict]];
        }
        return [newList copy];
    }
}


@end

NS_ASSUME_NONNULL_END
