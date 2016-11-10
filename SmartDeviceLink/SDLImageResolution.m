//  SDLImageResolution.m
//


#import "SDLImageResolution.h"

#import "SDLNames.h"

@implementation SDLImageResolution

- (void)setResolutionWidth:(NSNumber<SDLInt> *)resolutionWidth {
    [store sdl_setObject:resolutionWidth forName:SDLNameResolutionWidth];
}

- (NSNumber<SDLInt> *)resolutionWidth {
    return [store sdl_objectForName:SDLNameResolutionWidth];
}

- (void)setResolutionHeight:(NSNumber<SDLInt> *)resolutionHeight {
    [store sdl_setObject:resolutionHeight forName:SDLNameResolutionHeight];
}

- (NSNumber<SDLInt> *)resolutionHeight {
    return [store sdl_objectForName:SDLNameResolutionHeight];
}

@end
