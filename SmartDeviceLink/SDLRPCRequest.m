//  SDLRPCRequest.m
//


#import "SDLRPCRequest.h"

#import "SDLNames.h"

@implementation SDLRPCRequest

- (NSNumber<SDLInt> *)correlationID {
    return [function sdl_objectForName:SDLNameCorrelationId];
}

- (void)setCorrelationID:(NSNumber<SDLInt> *)corrID {
    [function sdl_setObject:corrID forName:SDLNameCorrelationId];
}

@end
