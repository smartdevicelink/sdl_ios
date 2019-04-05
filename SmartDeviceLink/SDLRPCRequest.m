//  SDLRPCRequest.m
//


#import "SDLRPCRequest.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLRPCRequest

- (NSNumber<SDLInt> *)correlationID {
    NSError *error = nil;
    return [function sdl_objectForName:SDLRPCParameterNameCorrelationId ofClass:NSNumber.class error:&error];
}

- (void)setCorrelationID:(NSNumber<SDLInt> *)corrID {
    [function sdl_setObject:corrID forName:SDLRPCParameterNameCorrelationId];
}

@end

NS_ASSUME_NONNULL_END
