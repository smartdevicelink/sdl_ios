//  SDLRPCResponse.m
//


#import "SDLRPCResponse.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLResult.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLRPCMessage ()

@property (strong, nonatomic, readwrite) NSString *messageType;
@property (strong, nonatomic) NSMutableDictionary<NSString *, id> *function;

@end

@implementation SDLRPCResponse

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-implementations"
- (instancetype)initWithName:(NSString *)name {
    self = [super initWithName:name];
    if (!self) {
        return nil;
    }

    self.messageType = SDLRPCParameterNameResponse;
    [self.store sdl_setObject:self.function forName:self.messageType];

    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary<NSString *, id> *)dict {
    self = [super initWithDictionary:dict];
    if (!self) {
        return nil;
    }

    self.messageType = SDLRPCParameterNameResponse;
    [self.store sdl_setObject:self.function forName:self.messageType];
    
    return self;
}

#pragma clang diagnostic pop

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ (%@), id: %@\n%@", self.name, self.messageType, self.correlationID, self.parameters];
}

- (NSNumber<SDLInt> *)correlationID {
    NSError *error = nil;
    return [self.function sdl_objectForName:SDLRPCParameterNameCorrelationId ofClass:NSNumber.class error:&error];
}

- (void)setCorrelationID:(NSNumber<SDLInt> *)corrID {
    [self.function sdl_setObject:corrID forName:SDLRPCParameterNameCorrelationId];
}

- (void)setSuccess:(NSNumber<SDLBool> *)success {
    [self.parameters sdl_setObject:success forName:SDLRPCParameterNameSuccess];
}

- (NSNumber<SDLBool> *)success {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameSuccess ofClass:NSNumber.class error:&error];
}

- (void)setResultCode:(SDLResult)resultCode {
    [self.parameters sdl_setObject:resultCode forName:SDLRPCParameterNameResultCode];
}

- (SDLResult)resultCode {
    NSError *error = nil;
    return [self.parameters sdl_enumForName:SDLRPCParameterNameResultCode error:&error];
}

- (void)setInfo:(nullable NSString *)info {
    [self.parameters sdl_setObject:info forName:SDLRPCParameterNameInfo];
}

- (nullable NSString *)info {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameInfo ofClass:NSString.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
