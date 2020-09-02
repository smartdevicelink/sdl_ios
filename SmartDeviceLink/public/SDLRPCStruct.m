//
//  SDLRPCStruct.m


#import "SDLRPCStruct.h"

#import "SDLEnum.h"
#import "SDLRPCParameterNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLRPCStruct

- (instancetype)initWithDictionary:(NSDictionary<NSString *, id> *)dict {
    self = [super init];
    if (!self) {
        return nil;
    }

    _store = [dict mutableCopy];
    _payloadProtected = NO;

    return self;
}

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }

    _store = [NSMutableDictionary dictionary];
    _payloadProtected = NO;

    return self;
}

- (NSDictionary<NSString *, id> *)serializeAsDictionary:(Byte)version {
    if (version >= 2) {
        NSString *messageType = self.store.keyEnumerator.nextObject;
        NSMutableDictionary<NSString *, id> *function = _store[messageType];
        if ([function isKindOfClass:NSMutableDictionary.class]) {
            NSMutableDictionary<NSString *, id> *parameters = function[SDLRPCParameterNameParameters];
            return [self.class sdl_serializeDictionary:parameters version:version];
        } else {
            return [self.class sdl_serializeDictionary:self.store version:version];
        }
    } else {
        return [self.class sdl_serializeDictionary:self.store version:version];
    }
}

- (NSString *)description {
    return [self.store description];
}

+ (NSDictionary<NSString *, id> *)sdl_serializeDictionary:(NSDictionary *)dict version:(Byte)version {
    NSMutableDictionary<NSString *, id> *ret = [NSMutableDictionary dictionaryWithCapacity:dict.count];
    for (NSString *key in dict.keyEnumerator) {
        NSObject *value = dict[key];
        if ([value isKindOfClass:SDLRPCStruct.class]) {
            ret[key] = [(SDLRPCStruct *)value serializeAsDictionary:version];
        } else if ([value isKindOfClass:NSDictionary.class]) {
            ret[key] = [self sdl_serializeDictionary:(NSDictionary *)value version:version];
        } else if ([value isKindOfClass:NSArray.class]) {
            NSArray<NSObject *> *arrayVal = (NSArray<NSObject *> *)value;
            
            if (arrayVal.count > 0 && ([arrayVal.firstObject isKindOfClass:SDLRPCStruct.class])) {
                NSMutableArray<NSDictionary<NSString *, id> *> *serializedList = [NSMutableArray arrayWithCapacity:arrayVal.count];
                for (SDLRPCStruct *serializeable in arrayVal) {
                    [serializedList addObject:[serializeable serializeAsDictionary:version]];
                }
                ret[key] = serializedList;
            } else {
                ret[key] = value;
            }
        } else {
            ret[key] = value;
        }
    }
    return ret;
}

- (id)copyWithZone:(nullable NSZone *)zone {
    SDLRPCStruct *newStruct = [[[self class] allocWithZone:zone] initWithDictionary:_store];
    newStruct.payloadProtected = self.payloadProtected;

    return newStruct;
}

- (BOOL)isEqualToRPC:(SDLRPCStruct *)rpc {
    return [rpc.store isEqualToDictionary:_store];
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }

    if (![object isMemberOfClass:self.class]) {
        return NO;
    }

    return [self isEqualToRPC:(SDLRPCStruct *)object];
}

@end

NS_ASSUME_NONNULL_END
