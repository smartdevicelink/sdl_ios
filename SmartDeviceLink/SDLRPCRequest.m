//  SDLRPCRequest.m
//


#import "SDLRPCRequest.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLRPCMessage ()

@property (strong, nonatomic) NSMutableDictionary<NSString *, id> *function;

@end

@implementation SDLRPCRequest

- (NSNumber<SDLInt> *)correlationID {
    NSError *error = nil;
    return [self.function sdl_objectForName:SDLRPCParameterNameCorrelationId ofClass:NSNumber.class error:&error];
}

- (void)setCorrelationID:(NSNumber<SDLInt> *)corrID {
    [self.function sdl_setObject:corrID forName:SDLRPCParameterNameCorrelationId];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ (%@), id: %@\n%@", self.name, self.messageType, self.correlationID, self.parameters];
}

@end

NS_ASSUME_NONNULL_END
