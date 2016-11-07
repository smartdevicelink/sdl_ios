//  SDLRPCRequest.m
//


#import "SDLRPCRequest.h"

#import "SDLNames.h"

@implementation SDLRPCRequest

- (NSNumber<SDLInt> *)correlationID {
    return [self objectForName:SDLNameCorrelationId fromStorage:function];
}

- (void)setCorrelationID:(NSNumber<SDLInt> *)corrID {
    [self setObject:corrID forName:SDLNameCorrelationId inStorage:function];
}

@end
