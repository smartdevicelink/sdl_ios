//  SDLRPCResponse.m
//


#import "SDLRPCResponse.h"

#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"
#import "SDLResult.h"

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
    return [function sdl_objectForName:SDLNameCorrelationId];
}

- (void)setCorrelationID:(NSNumber<SDLInt> *)corrID {
    [function sdl_setObject:corrID forName:SDLNameCorrelationId];
}

- (void)setSuccess:(NSNumber<SDLBool> *)success {
    [store sdl_setObject:success forName:SDLNameSuccess];
}

- (NSNumber<SDLBool> *)success {
    return [store sdl_objectForName:SDLNameSuccess];
}

- (void)setResultCode:(SDLResult)resultCode {
    [store sdl_setObject:resultCode forName:SDLNameResultCode];
}

- (SDLResult)resultCode {
    return [store sdl_objectForName:SDLNameResultCode];
}

- (void)setInfo:(NSString *)info {
    [store sdl_setObject:info forName:SDLNameInfo];
}

- (NSString *)info {
    return [store sdl_objectForName:SDLNameInfo];
}

@end
