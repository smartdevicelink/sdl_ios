//  SDLRPCResponse.m
//


#import "SDLRPCResponse.h"

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
    [store setObject:function forKey:messageType];

    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary<NSString *, id> *)dict {
    self = [super initWithDictionary:dict];
    if (!self) {
        return nil;
    }

    messageType = SDLNameResponse;
    [store setObject:function forKey:messageType];

    return self;
}

- (nullable NSNumber<SDLInt> *)correlationID {
    return [function objectForKey:SDLNameCorrelationId];
}

- (void)setCorrelationID:(nullable NSNumber<SDLInt> *)corrID {
    if (corrID != nil) {
        [function setObject:corrID forKey:SDLNameCorrelationId];
    } else {
        [function removeObjectForKey:SDLNameCorrelationId];
    }
}

- (void)setSuccess:(nullable NSNumber<SDLBool> *)success {
    if (success != nil) {
        [parameters setObject:success forKey:SDLNameSuccess];
    } else {
        [parameters removeObjectForKey:SDLNameSuccess];
    }
}

- (nullable NSNumber<SDLBool> *)success {
    return [parameters objectForKey:SDLNameSuccess];
}

- (void)setResultCode:(nullable SDLResult)resultCode {
    if (resultCode != nil) {
        [parameters setObject:resultCode forKey:SDLNameResultCode];
    } else {
        [parameters removeObjectForKey:SDLNameResultCode];
    }
}

- (nullable SDLResult)resultCode {
    NSObject *obj = [parameters objectForKey:SDLNameResultCode];
    return (SDLResult)obj;
}

- (void)setInfo:(nullable NSString *)info {
    if (info != nil) {
        [parameters setObject:info forKey:SDLNameInfo];
    } else {
        [parameters removeObjectForKey:SDLNameInfo];
    }
}

- (nullable NSString *)info {
    return [parameters objectForKey:SDLNameInfo];
}

@end

NS_ASSUME_NONNULL_END
