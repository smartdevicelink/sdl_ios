//
//  SDLRPCStruct.m


#import "SDLRPCStruct.h"

#import "SDLEnum.h"
#import "SDLNames.h"

@implementation SDLRPCStruct

- (id)initWithDictionary:(NSDictionary<NSString *, id> *)dict {
    if (self = [super init]) {
        if (dict != nil) {
            store = [dict mutableCopy];
        } else {
            store = [NSMutableDictionary dictionary];
        }
    }
    return self;
}

- (id)init {
    if (self = [super init]) {
        store = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)setObject:(NSObject *)object forName:(SDLName)name {
    [self setObject:object forName:name inStorage:store];
}

- (void)setObject:(NSObject*)object forName:(SDLName)name inStorage:(NSMutableDictionary*)storage {
    if (object != nil) {
        storage[name] = object;
    } else {
        [storage removeObjectForKey:name];
    }
}

- (id)objectForName:(SDLName)name {
    return [self objectForName:name fromStorage:store];
}

- (id)objectForName:(SDLName)name ofClass:(Class)classType {
    NSObject *obj = [self objectForName:name];
    if (obj == nil || [obj isKindOfClass:classType.class]) {
        return obj;
    } else {
        return [[classType alloc] initWithDictionary:(NSDictionary *)obj];
    }
}

- (id)objectForName:(SDLName)name fromStorage:(NSMutableDictionary *)storage {
    return storage[name];
}

- (NSMutableArray *)objectsForName:(SDLName)name ofClass:(Class)classType {
    NSMutableArray *array = [self objectForName:name];
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

- (NSDictionary<NSString *, id> *)serializeAsDictionary:(Byte)version {
    if (version >= 2) {
        NSString *messageType = [[store keyEnumerator] nextObject];
        NSMutableDictionary<NSString *, id> *function = [store objectForKey:messageType];
        if ([function isKindOfClass:NSMutableDictionary.class]) {
            NSMutableDictionary<NSString *, id> *parameters = [function objectForKey:SDLNameParameters];
            return [self.class sdl_serializeDictionary:parameters version:version];
        } else {
            return [self.class sdl_serializeDictionary:store version:version];
        }
    } else {
        return [self.class sdl_serializeDictionary:store version:version];
    }
}

- (NSString *)description {
    return [store description];
}

+ (NSDictionary<NSString *, id> *)sdl_serializeDictionary:(NSDictionary *)dict version:(Byte)version {
    NSMutableDictionary<NSString *, id> *ret = [NSMutableDictionary dictionaryWithCapacity:dict.count];
    for (NSString *key in [dict keyEnumerator]) {
        NSObject *value = [dict objectForKey:key];
        if ([value isKindOfClass:SDLRPCStruct.class]) {
            [ret setObject:[(SDLRPCStruct *)value serializeAsDictionary:version] forKey:key];
        } else if ([value isKindOfClass:NSDictionary.class]) {
            [ret setObject:[self sdl_serializeDictionary:(NSDictionary *)value version:version] forKey:key];
        } else if ([value isKindOfClass:NSArray.class]) {
            NSArray<NSObject *> *arrayVal = (NSArray<NSObject *> *)value;
            
            if (arrayVal.count > 0 && ([[arrayVal objectAtIndex:0] isKindOfClass:SDLRPCStruct.class])) {
                NSMutableArray<NSDictionary<NSString *, id> *> *serializedList = [NSMutableArray arrayWithCapacity:arrayVal.count];
                for (SDLRPCStruct *serializeable in arrayVal) {
                    [serializedList addObject:[serializeable serializeAsDictionary:version]];
                }
                [ret setObject:serializedList forKey:key];
            } else {
                [ret setObject:value forKey:key];
            }
        } else {
            [ret setObject:value forKey:key];
        }
    }
    return ret;
}

@end
