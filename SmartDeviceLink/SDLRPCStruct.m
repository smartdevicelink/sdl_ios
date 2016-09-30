//
//  SDLRPCStruct.m


#import "SDLRPCStruct.h"

#import "SDLEnum.h"
#import "SDLNames.h"

@implementation SDLRPCStruct

- (id)initWithDictionary:(NSDictionary *)dict {
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

- (NSDictionary *)serializeAsDictionary:(Byte)version {
    if (version >= 2) {
        NSString *messageType = [[store keyEnumerator] nextObject];
        NSMutableDictionary *function = [store objectForKey:messageType];
        if ([function isKindOfClass:NSMutableDictionary.class]) {
            NSMutableDictionary *parameters = [function objectForKey:SDLNameParameters];
            return [self sdl_serializeDictionary:parameters version:version];
        } else {
            return [self sdl_serializeDictionary:store version:version];
        }
    } else {
        return [self sdl_serializeDictionary:store version:version];
    }
}

- (NSString *)description {
    return [store description];
}

- (NSDictionary *)sdl_serializeDictionary:(NSDictionary *)dict version:(Byte)version {
    NSMutableDictionary *ret = [NSMutableDictionary dictionaryWithCapacity:dict.count];
    for (NSString *key in [dict keyEnumerator]) {
        NSObject *value = [dict objectForKey:key];
        if ([value isKindOfClass:SDLRPCStruct.class]) {
            [ret setObject:[(SDLRPCStruct *)value serializeAsDictionary:version] forKey:key];
        } else if ([value isKindOfClass:NSDictionary.class]) {
            [ret setObject:[self sdl_serializeDictionary:(NSDictionary *)value version:version] forKey:key];
        } else if ([value isKindOfClass:NSArray.class]) {
            NSArray *arrayVal = (NSArray *)value;
            
            if (arrayVal.count > 0 && ([[arrayVal objectAtIndex:0] isKindOfClass:SDLRPCStruct.class])) {
                NSMutableArray *serializedList = [NSMutableArray arrayWithCapacity:arrayVal.count];
                for (SDLRPCStruct *serializeable in arrayVal) {
                    [serializedList addObject:[serializeable serializeAsDictionary:version]];
                }
                [ret setObject:serializedList forKey:key];
            } else if (arrayVal.count > 0 && ([[arrayVal objectAtIndex:0] isKindOfClass:SDLEnum.class])) {
                NSMutableArray *serializedList = [NSMutableArray arrayWithCapacity:arrayVal.count];
                for (SDLEnum *anEnum in arrayVal) {
                    [serializedList addObject:anEnum.value];
                }
                [ret setObject:serializedList forKey:key];
            } else {
                [ret setObject:value forKey:key];
            }
        } else if ([value isKindOfClass:SDLEnum.class]) {
            [ret setObject:((SDLEnum *)value).value forKey:key];
        } else {
            [ret setObject:value forKey:key];
        }
    }
    return ret;
}

@end
