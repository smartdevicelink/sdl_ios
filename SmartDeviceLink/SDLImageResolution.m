//  SDLImageResolution.m
//


#import "SDLImageResolution.h"

#import "SDLNames.h"

@implementation SDLImageResolution

- (void)setResolutionWidth:(NSNumber<SDLInt> *)resolutionWidth {
    if (resolutionWidth != nil) {
        [store setObject:resolutionWidth forKey:SDLNameResolutionWidth];
    } else {
        [store removeObjectForKey:SDLNameResolutionWidth];
    }
}

- (NSNumber<SDLInt> *)resolutionWidth {
    return [store objectForKey:SDLNameResolutionWidth];
}

- (void)setResolutionHeight:(NSNumber<SDLInt> *)resolutionHeight {
    if (resolutionHeight != nil) {
        [store setObject:resolutionHeight forKey:SDLNameResolutionHeight];
    } else {
        [store removeObjectForKey:SDLNameResolutionHeight];
    }
}

- (NSNumber<SDLInt> *)resolutionHeight {
    return [store objectForKey:SDLNameResolutionHeight];
}

@end
