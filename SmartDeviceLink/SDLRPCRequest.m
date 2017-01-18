//  SDLRPCRequest.m
//


#import "SDLRPCRequest.h"

#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLRPCRequest

- (NSNumber<SDLInt> *)correlationID {
    return [function sdl_objectForName:SDLNameCorrelationId];
}

- (void)setCorrelationID:(NSNumber<SDLInt> *)corrID {
    [function sdl_setObject:corrID forName:SDLNameCorrelationId];
}

@end

NS_ASSUME_NONNULL_END
