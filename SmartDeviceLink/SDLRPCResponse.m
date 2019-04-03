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
    NSError *error = nil;
    return [function sdl_objectForName:SDLRPCParameterNameCorrelationId ofClass:NSNumber.class error:&error];
}

- (void)setCorrelationID:(NSNumber<SDLInt> *)corrID {
    [function sdl_setObject:corrID forName:SDLRPCParameterNameCorrelationId];
}

- (void)setSuccess:(NSNumber<SDLBool> *)success {
    [parameters sdl_setObject:success forName:SDLRPCParameterNameSuccess];
}

- (NSNumber<SDLBool> *)success {
    NSError *error = nil;
    return [parameters sdl_objectForName:SDLRPCParameterNameSuccess ofClass:NSNumber.class error:&error];
}

- (void)setResultCode:(SDLResult)resultCode {
    [parameters sdl_setObject:resultCode forName:SDLRPCParameterNameResultCode];
}

- (SDLResult)resultCode {
    NSError *error = nil;
    return [parameters sdl_enumForName:SDLRPCParameterNameResultCode error:&error];
}

- (void)setInfo:(nullable NSString *)info {
    [parameters sdl_setObject:info forName:SDLRPCParameterNameInfo];
}

- (nullable NSString *)info {
    return [parameters sdl_objectForName:SDLRPCParameterNameInfo ofClass:NSString.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
