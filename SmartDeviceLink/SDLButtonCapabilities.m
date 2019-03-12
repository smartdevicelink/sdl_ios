//  SDLButtonCapabilities.m
//

#import "SDLButtonCapabilities.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLButtonCapabilities

- (void)setName:(SDLButtonName)name {
    [store sdl_setObject:name forName:SDLRPCParameterNameName];
}

- (SDLButtonName)name {
    return [store sdl_objectForName:SDLRPCParameterNameName];
}

- (void)setShortPressAvailable:(NSNumber<SDLBool> *)shortPressAvailable {
    [store sdl_setObject:shortPressAvailable forName:SDLRPCParameterNameShortPressAvailable];
}

- (NSNumber<SDLBool> *)shortPressAvailable {
    return [store sdl_objectForName:SDLRPCParameterNameShortPressAvailable];
}

- (void)setLongPressAvailable:(NSNumber<SDLBool> *)longPressAvailable {
    [store sdl_setObject:longPressAvailable forName:SDLRPCParameterNameLongPressAvailable];
}

- (NSNumber<SDLBool> *)longPressAvailable {
    return [store sdl_objectForName:SDLRPCParameterNameLongPressAvailable];
}

- (void)setUpDownAvailable:(NSNumber<SDLBool> *)upDownAvailable {
    [store sdl_setObject:upDownAvailable forName:SDLRPCParameterNameUpDownAvailable];
}

- (NSNumber<SDLBool> *)upDownAvailable {
    return [store sdl_objectForName:SDLRPCParameterNameUpDownAvailable];
}

@end

NS_ASSUME_NONNULL_END
