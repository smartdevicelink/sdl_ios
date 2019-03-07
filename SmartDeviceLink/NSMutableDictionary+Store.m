//
//  NSMutableDictionary+Store.m
//  SmartDeviceLink-iOS
//
//  Created by Muller, Alexander (A.) on 11/7/16.
//  Copyright © 2016 smartdevicelink. All rights reserved.
//

#import "NSMutableDictionary+Store.h"
#import "SDLRPCStruct.h"
#import "SDLError.h"

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

#pragma mark - enum

- (nullable SDLEnum)sdl_enumForName:(SDLName)name {
    return [self sdl_objectForName:name ofClass:NSString.class];
}

- (nullable SDLEnum)sdl_enumForName:(SDLName)name error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    return [self sdl_objectForName:name ofClass:NSString.class error:error];
}

#pragma mark - enums

- (nullable NSArray<SDLEnum> *)sdl_enumsForName:(SDLName)name {
    return [self sdl_objectsForName:name ofClass:NSString.class];
}

- (nullable NSArray<SDLEnum> *)sdl_enumsForName:(SDLName)name error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    return [self sdl_objectsForName:name ofClass:NSString.class error:error];
}

#pragma mark - object

- (nullable id)sdl_objectForName:(SDLName)name ofClass:(Class)classType {
    NSError *error;
    id object = [self sdl_objectForName:name ofClass:classType error:&error];
    return error == nil ? object : nil;
}

- (nullable id)sdl_objectForName:(SDLName)name ofClass:(Class)classType error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    id obj = [self sdl_objectForName:name];

    if (obj == nil || [obj isKindOfClass:classType]) {
        return obj;
    }
    // translate dictionaries to objects
    if ([obj isKindOfClass:NSDictionary.class] && [classType instancesRespondToSelector:@selector(initWithDictionary:)]) {
        obj = [[classType alloc] initWithDictionary:(NSDictionary *)obj];
        // update store so that the object isn't created multiple times
        [self sdl_setObject:obj forName:name];
        return obj;
    }
    *error = [NSError sdl_store_wrongObject:obj expectedType:classType];

    NSAssert(NO, [[*error userInfo] objectForKey:NSLocalizedFailureReasonErrorKey]);
    return obj;
}

#pragma mark - objects

- (nullable NSArray *)sdl_objectsForName:(SDLName)name ofClass:(Class)classType {
    NSError *error;
    id objects = [self sdl_objectsForName:name ofClass:classType error:&error];
    return error == nil ? objects : nil;
}

- (nullable NSArray *)sdl_objectsForName:(SDLName)name ofClass:(Class)classType error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    NSArray *array = [self sdl_objectForName:name ofClass:NSArray.class error:error];
    if (!array || array.count < 1 || [array.firstObject isKindOfClass:classType]) {
        // It's an array of the actual class type, just return
        return array;
    }
    if ([classType instancesRespondToSelector:@selector(initWithDictionary:)]) {
        // It's an array of dictionaries, make them into their class type
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:array.count];
        for (NSDictionary<NSString *, id> *dict in array) {
            if ([dict isKindOfClass:NSDictionary.class]) {
                [newList addObject:[[classType alloc] initWithDictionary:dict]];
            }
        }
        return [newList copy];
    }
    if ([array isKindOfClass:NSArray.class] && ![array.firstObject isKindOfClass:classType]) {
        *error = [NSError sdl_store_wrongObject:array.firstObject expectedType:classType];
    } else {
        *error = [NSError sdl_store_wrongObject:array expectedType:NSArray.class];
    }

    NSAssert(NO, [[*error userInfo] objectForKey:NSLocalizedFailureReasonErrorKey]);
    return array;
}

@end

NS_ASSUME_NONNULL_END
