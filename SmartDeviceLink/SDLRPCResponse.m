//  SDLRPCResponse.m
//


#import "SDLRPCResponse.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLResult.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLRPCResponse

- (instancetype)initWithName:(NSString *)name {
    self = [super initWithName:name];
    if (!self) {
        return nil;
    }

    messageType = SDLRPCParameterNameResponse;
    [store sdl_setObject:function forName:messageType];

    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary<NSString *, id> *)dict {
    self = [super initWithDictionary:dict];
    if (!self) {
        return nil;
    }

    messageType = SDLRPCParameterNameResponse;
    [store sdl_setObject:function forName:messageType];
    
    return self;
}

- (NSNumber<SDLInt> *)correlationID {
    return [function sdl_objectForName:SDLRPCParameterNameCorrelationId];
}

- (void)setCorrelationID:(NSNumber<SDLInt> *)corrID {
    [function sdl_setObject:corrID forName:SDLRPCParameterNameCorrelationId];
}

- (void)setSuccess:(NSNumber<SDLBool> *)success {
    [parameters sdl_setObject:success forName:SDLRPCParameterNameSuccess];
}

- (NSNumber<SDLBool> *)success {
    return [parameters sdl_objectForName:SDLRPCParameterNameSuccess];
}

- (void)setResultCode:(SDLResult)resultCode {
    [parameters sdl_setObject:resultCode forName:SDLRPCParameterNameResultCode];
}

- (SDLResult)resultCode {
    return [parameters sdl_objectForName:SDLRPCParameterNameResultCode];
}

- (void)setInfo:(nullable NSString *)info {
    [parameters sdl_setObject:info forName:SDLRPCParameterNameInfo];
}

- (nullable NSString *)info {
    return [parameters sdl_objectForName:SDLRPCParameterNameInfo];
}

@end

NS_ASSUME_NONNULL_END
