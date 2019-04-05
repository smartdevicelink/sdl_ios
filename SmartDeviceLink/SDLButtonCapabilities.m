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
    NSError *error = nil;
    return [store sdl_enumForName:SDLRPCParameterNameName error:&error];
}

- (void)setShortPressAvailable:(NSNumber<SDLBool> *)shortPressAvailable {
    [store sdl_setObject:shortPressAvailable forName:SDLRPCParameterNameShortPressAvailable];
}

- (NSNumber<SDLBool> *)shortPressAvailable {
    NSError *error = nil;
    return [store sdl_objectForName:SDLRPCParameterNameShortPressAvailable ofClass:NSNumber.class error:&error];
}

- (void)setLongPressAvailable:(NSNumber<SDLBool> *)longPressAvailable {
    [store sdl_setObject:longPressAvailable forName:SDLRPCParameterNameLongPressAvailable];
}

- (NSNumber<SDLBool> *)longPressAvailable {
    NSError *error = nil;
    return [store sdl_objectForName:SDLRPCParameterNameLongPressAvailable ofClass:NSNumber.class error:&error];
}

- (void)setUpDownAvailable:(NSNumber<SDLBool> *)upDownAvailable {
    [store sdl_setObject:upDownAvailable forName:SDLRPCParameterNameUpDownAvailable];
}

- (NSNumber<SDLBool> *)upDownAvailable {
    NSError *error = nil;
    return [store sdl_objectForName:SDLRPCParameterNameUpDownAvailable ofClass:NSNumber.class error:&error];
}

@end

NS_ASSUME_NONNULL_END
