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

- (void)sdl_setObject:(nullable NSObject *)object forName:(SDLRPCParameterName)name {
    if (object != nil) {
        self[name] = object;
    } else {
        [self removeObjectForKey:name];
    }
}

- (nullable id)sdl_objectForName:(SDLRPCParameterName)name {
    return self[name];
}

#pragma mark - enum

- (nullable SDLRPCParameterName)sdl_enumForName:(SDLRPCParameterName)name error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    return [self sdl_objectForName:name ofClass:NSString.class error:error];
}

#pragma mark - enums

- (nullable NSArray<SDLRPCParameterName> *)sdl_enumsForName:(SDLRPCParameterName)name error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    return [self sdl_objectsForName:name ofClass:NSString.class error:error];
}

#pragma mark - object

- (nullable id)sdl_objectForName:(SDLRPCParameterName)name ofClass:(Class)classType error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    id obj = [self sdl_objectForName:name];

    if (obj == nil || [obj isKindOfClass:classType]) {
        return obj;
    // translate dictionaries to objects
    } else if ([obj isKindOfClass:NSDictionary.class] && [classType instancesRespondToSelector:@selector(initWithDictionary:)]) {
        obj = [[classType alloc] initWithDictionary:(NSDictionary *)obj];
        // update store so that the object isn't created multiple times
        [self sdl_setObject:obj forName:name];
        return obj;
    } else {
        // The object in the store is not correct, we'll assert in debug and return an error and nil
        NSError *wrongObjectError = [NSError sdl_rpcStore_invalidObjectErrorWithObject:obj expectedType:classType];

        SDLLogAssert(@"Retrieving object from store error: %@, for object key: \"%@\", in dictionary: %@", wrongObjectError.localizedFailureReason, name, self);

        if (error) {
            *error = wrongObjectError;
        }
        return nil;
    }
}

#pragma mark - objects

- (nullable NSArray *)sdl_objectsForName:(SDLRPCParameterName)name ofClass:(Class)classType error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    NSArray *array = [self sdl_objectForName:name ofClass:NSArray.class error:error];
    if (array == nil || array.count < 1 || [array.firstObject isKindOfClass:classType]) {
        // It's an array of the actual class type, just return
        return array;
    } else if ([classType instancesRespondToSelector:@selector(initWithDictionary:)]) {
        // It's an array of dictionaries, make them into their class type
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:array.count];
        for (NSDictionary<NSString *, id> *dict in array) {
            if ([dict isKindOfClass:NSDictionary.class]) {
                [newList addObject:[[classType alloc] initWithDictionary:dict]];
            }
        }
        array = [newList copy];
        [self sdl_setObject:array forName:name];
        return array;
    } else {
        // The object in the store is not correct, we'll assert in debug and return an error and nil
        NSError *wrongObjectError = nil;

        if ([array isKindOfClass:NSArray.class] && ![array.firstObject isKindOfClass:classType]) {
            wrongObjectError = [NSError sdl_rpcStore_invalidObjectErrorWithObject:array.firstObject expectedType:classType];
        } else {
            wrongObjectError = [NSError sdl_rpcStore_invalidObjectErrorWithObject:array expectedType:NSArray.class];
        }

        SDLLogAssert(@"Retrieving array from store error: %@", wrongObjectError.localizedFailureReason);
        if (error) {
            *error = wrongObjectError;
        }
        return nil;
    }
}

@end

NS_ASSUME_NONNULL_END
