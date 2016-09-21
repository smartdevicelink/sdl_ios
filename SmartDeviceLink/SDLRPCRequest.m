//  SDLRPCRequest.m
//


#import "SDLRPCRequest.h"



@implementation SDLRPCRequest

- (NSNumber *)correlationID {
    return [function objectForKey:SDLNameCorrelationId];
}

- (void)setCorrelationID:(NSNumber *)corrID {
    if (corrID != nil) {
        [function setObject:corrID forKey:SDLNameCorrelationId];
    } else {
        [function removeObjectForKey:SDLNameCorrelationId];
    }
}

@end
