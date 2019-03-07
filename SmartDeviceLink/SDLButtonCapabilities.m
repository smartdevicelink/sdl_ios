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
    NSError *error;
    return [store sdl_enumForName:SDLNameName error:&error];
}

- (void)setShortPressAvailable:(NSNumber<SDLBool> *)shortPressAvailable {
    [store sdl_setObject:shortPressAvailable forName:SDLNameShortPressAvailable];
}

- (NSNumber<SDLBool> *)shortPressAvailable {
    NSError *error;
    return [store sdl_objectForName:SDLNameShortPressAvailable ofClass:NSNumber.class error:&error];
}

- (void)setLongPressAvailable:(NSNumber<SDLBool> *)longPressAvailable {
    [store sdl_setObject:longPressAvailable forName:SDLNameLongPressAvailable];
}

- (NSNumber<SDLBool> *)longPressAvailable {
    NSError *error;
    return [store sdl_objectForName:SDLNameLongPressAvailable ofClass:NSNumber.class error:&error];
}

- (void)setUpDownAvailable:(NSNumber<SDLBool> *)upDownAvailable {
    [store sdl_setObject:upDownAvailable forName:SDLNameUpDownAvailable];
}

- (NSNumber<SDLBool> *)upDownAvailable {
    NSError *error;
    return [store sdl_objectForName:SDLNameUpDownAvailable ofClass:NSNumber.class error:&error];
}

@end

NS_ASSUME_NONNULL_END
