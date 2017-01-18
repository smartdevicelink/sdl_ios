//  SDLTouchCoord.m
//


#import "SDLTouchCoord.h"

#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLTouchCoord

- (void)setX:(NSNumber<SDLFloat> *)x {
    [store sdl_setObject:x forName:SDLNameX];
}

- (NSNumber<SDLFloat> *)x {
    return [store sdl_objectForName:SDLNameX];
}

- (void)setY:(NSNumber<SDLFloat> *)y {
    [store sdl_setObject:y forName:SDLNameY];
}

- (NSNumber<SDLFloat> *)y {
    return [store sdl_objectForName:SDLNameY];
}

@end

NS_ASSUME_NONNULL_END
