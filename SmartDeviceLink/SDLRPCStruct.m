//
//  SDLRPCStruct.m


#import "SDLRPCStruct.h"

#import "SDLEnum.h"
#import "SDLNames.h"

@implementation SDLRPCStruct

- (id)initWithDictionary:(NSMutableDictionary *)dict {
    if (self = [super init]) {
        if (dict != nil) {
            store = dict;
        } else {
            store = [[NSMutableDictionary alloc] init];
        }
    }
    return self;
}

- (id)init {
    if (self = [super init]) {
        store = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (NSMutableDictionary *)serializeDictionary:(NSDictionary *)dict version:(Byte)version {
    NSMutableDictionary *ret = [NSMutableDictionary dictionaryWithCapacity:dict.count];
    for (NSString *key in [dict keyEnumerator]) {
        NSObject *value = [dict objectForKey:key];
        if ([value isKindOfClass:SDLRPCStruct.class]) {
            [ret setObject:[(SDLRPCStruct *)value serializeAsDictionary:version] forKey:key];
        } else if ([value isKindOfClass:NSDictionary.class]) {
            [ret setObject:[self serializeDictionary:(NSDictionary *)value version:version] forKey:key];
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

- (NSMutableDictionary *)serializeAsDictionary:(Byte)version {
    if (version >= 2) {
        NSString *messageType = [[store keyEnumerator] nextObject];
        NSMutableDictionary *function = [store objectForKey:messageType];
        if ([function isKindOfClass:NSMutableDictionary.class]) {
            NSMutableDictionary *parameters = [function objectForKey:NAMES_parameters];
            return [self serializeDictionary:parameters version:version];
        } else {
            return [self serializeDictionary:store version:version];
        }
    } else {
        return [self serializeDictionary:store version:version];
    }
}

- (NSString *)description {
    return [store description];
}

- (void)dealloc {
    store = nil;
}

@end
