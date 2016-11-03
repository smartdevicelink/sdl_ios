//  SDLRPCRequest.m
//


#import "SDLRPCRequest.h"

#import "SDLNames.h"

@implementation SDLRPCRequest

- (NSNumber<SDLInt> *)correlationID {
    return [function objectForKey:SDLNameCorrelationId];
}

- (void)setCorrelationID:(NSNumber<SDLInt> *)corrID {
    if (corrID != nil) {
        [function setObject:corrID forKey:SDLNameCorrelationId];
    } else {
        [function removeObjectForKey:SDLNameCorrelationId];
    }
}

@end
