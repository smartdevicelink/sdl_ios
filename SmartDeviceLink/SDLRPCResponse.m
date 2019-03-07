//  SDLRPCResponse.m
//


#import "SDLRPCResponse.h"

#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"
#import "SDLResult.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLRPCResponse

- (instancetype)initWithName:(NSString *)name {
    self = [super initWithName:name];
    if (!self) {
        return nil;
    }

    messageType = SDLNameResponse;
    [store sdl_setObject:function forName:messageType];

    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary<NSString *, id> *)dict {
    self = [super initWithDictionary:dict];
    if (!self) {
        return nil;
    }

    messageType = SDLNameResponse;
    [store sdl_setObject:function forName:messageType];
    
    return self;
}

- (NSNumber<SDLInt> *)correlationID {
    NSError *error;
    return [function sdl_objectForName:SDLNameCorrelationId ofClass:NSNumber.class error:&error];
}

- (void)setCorrelationID:(NSNumber<SDLInt> *)corrID {
    [function sdl_setObject:corrID forName:SDLNameCorrelationId];
}

- (void)setSuccess:(NSNumber<SDLBool> *)success {
    [parameters sdl_setObject:success forName:SDLNameSuccess];
}

- (NSNumber<SDLBool> *)success {
    NSError *error;
    return [parameters sdl_objectForName:SDLNameSuccess ofClass:NSNumber.class error:&error];
}

- (void)setResultCode:(SDLResult)resultCode {
    [parameters sdl_setObject:resultCode forName:SDLNameResultCode];
}

- (SDLResult)resultCode {
    NSError *error;
    return [parameters sdl_enumForName:SDLNameResultCode error:&error];
}

- (void)setInfo:(nullable NSString *)info {
    [parameters sdl_setObject:info forName:SDLNameInfo];
}

- (nullable NSString *)info {
    return [parameters sdl_objectForName:SDLNameInfo ofClass:NSString.class];
}

@end

NS_ASSUME_NONNULL_END
