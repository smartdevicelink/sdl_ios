//  SDLRPCRequest.m
//


#import "SDLRPCRequest.h"

#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLRPCRequest

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

@end

NS_ASSUME_NONNULL_END
