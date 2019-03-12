//  SDLTouchEventCapabilities.m
//


#import "SDLTouchEventCapabilities.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLTouchEventCapabilities

- (void)setPressAvailable:(NSNumber<SDLBool> *)pressAvailable {
    [store sdl_setObject:pressAvailable forName:SDLRPCParameterNamePressAvailable];
}

- (NSNumber<SDLBool> *)pressAvailable {
    return [store sdl_objectForName:SDLRPCParameterNamePressAvailable];
}

- (void)setMultiTouchAvailable:(NSNumber<SDLBool> *)multiTouchAvailable {
    [store sdl_setObject:multiTouchAvailable forName:SDLRPCParameterNameMultiTouchAvailable];
}

- (NSNumber<SDLBool> *)multiTouchAvailable {
    return [store sdl_objectForName:SDLRPCParameterNameMultiTouchAvailable];
}

- (void)setDoublePressAvailable:(NSNumber<SDLBool> *)doublePressAvailable {
    [store sdl_setObject:doublePressAvailable forName:SDLRPCParameterNameDoublePressAvailable];
}

- (NSNumber<SDLBool> *)doublePressAvailable {
    return [store sdl_objectForName:SDLRPCParameterNameDoublePressAvailable];
}

@end

NS_ASSUME_NONNULL_END
