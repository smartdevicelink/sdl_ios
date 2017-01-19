//  SDLImageResolution.m
//


#import "SDLImageResolution.h"

#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

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

NS_ASSUME_NONNULL_END
