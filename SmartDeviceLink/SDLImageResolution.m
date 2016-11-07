//  SDLImageResolution.m
//


#import "SDLImageResolution.h"

#import "SDLNames.h"

@implementation SDLImageResolution

- (void)setResolutionWidth:(NSNumber<SDLInt> *)resolutionWidth {
    [self setObject:resolutionWidth forName:SDLNameResolutionWidth];
}

- (NSNumber<SDLInt> *)resolutionWidth {
    return [self objectForName:SDLNameResolutionWidth];
}

- (void)setResolutionHeight:(NSNumber<SDLInt> *)resolutionHeight {
    [self setObject:resolutionHeight forName:SDLNameResolutionHeight];
}

- (NSNumber<SDLInt> *)resolutionHeight {
    return [self objectForName:SDLNameResolutionHeight];
}

@end
