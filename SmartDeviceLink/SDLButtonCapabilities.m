//  SDLButtonCapabilities.m
//

#import "SDLButtonCapabilities.h"

#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLButtonCapabilities

- (void)setName:(SDLButtonName)name {
    [store sdl_setObject:name forName:SDLNameName];
}

- (SDLButtonName)name {
    return [store sdl_objectForName:SDLNameName];
}

- (void)setShortPressAvailable:(NSNumber<SDLBool> *)shortPressAvailable {
    [store sdl_setObject:shortPressAvailable forName:SDLNameShortPressAvailable];
}

- (NSNumber<SDLBool> *)shortPressAvailable {
    return [store sdl_objectForName:SDLNameShortPressAvailable];
}

- (void)setLongPressAvailable:(NSNumber<SDLBool> *)longPressAvailable {
    [store sdl_setObject:longPressAvailable forName:SDLNameLongPressAvailable];
}

- (NSNumber<SDLBool> *)longPressAvailable {
    return [store sdl_objectForName:SDLNameLongPressAvailable];
}

- (void)setUpDownAvailable:(NSNumber<SDLBool> *)upDownAvailable {
    [store sdl_setObject:upDownAvailable forName:SDLNameUpDownAvailable];
}

- (NSNumber<SDLBool> *)upDownAvailable {
    return [store sdl_objectForName:SDLNameUpDownAvailable];
}

@end

NS_ASSUME_NONNULL_END
