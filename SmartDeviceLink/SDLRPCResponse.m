//  SDLRPCResponse.m
//


#import "SDLRPCResponse.h"

#import "SDLNames.h"
#import "SDLResult.h"

@implementation SDLRPCResponse

- (instancetype)initWithName:(NSString *)name {
    self = [super initWithName:name];
    if (!self) {
        return nil;
    }

    messageType = SDLNameResponse;
    [self setObject:function forName:messageType inStorage:store];

    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary<NSString *, id> *)dict {
    self = [super initWithDictionary:dict];
    if (!self) {
        return nil;
    }

    messageType = SDLNameResponse;
    [self setObject:function forName:messageType inStorage:store];
    
    return self;
}

- (NSNumber<SDLInt> *)correlationID {
    return [self objectForName:SDLNameCorrelationId fromStorage:function];
}

- (void)setCorrelationID:(NSNumber<SDLInt> *)corrID {
    [self setObject:corrID forName:SDLNameCorrelationId inStorage:function];
}

- (void)setSuccess:(NSNumber<SDLBool> *)success {
    [self setObject:success forName:SDLNameSuccess];
}

- (NSNumber<SDLBool> *)success {
    return [self objectForName:SDLNameSuccess];
}

- (void)setResultCode:(SDLResult)resultCode {
    [self setObject:resultCode forName:SDLNameResultCode];
}

- (SDLResult)resultCode {
    return [self objectForName:SDLNameResultCode];
}

- (void)setInfo:(NSString *)info {
    [self setObject:info forName:SDLNameInfo];
}

- (NSString *)info {
    return [self objectForName:SDLNameInfo];
}

@end
