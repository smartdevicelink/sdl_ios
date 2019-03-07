//  SDLTouchEventCapabilities.m
//


#import "SDLTouchEventCapabilities.h"

#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLTouchEventCapabilities

- (void)setPressAvailable:(NSNumber<SDLBool> *)pressAvailable {
    [store sdl_setObject:pressAvailable forName:SDLNamePressAvailable];
}

- (NSNumber<SDLBool> *)pressAvailable {
    NSError *error;
    return [store sdl_objectForName:SDLNamePressAvailable ofClass:NSNumber.class error:&error];
}

- (void)setMultiTouchAvailable:(NSNumber<SDLBool> *)multiTouchAvailable {
    [store sdl_setObject:multiTouchAvailable forName:SDLNameMultiTouchAvailable];
}

- (NSNumber<SDLBool> *)multiTouchAvailable {
    NSError *error;
    return [store sdl_objectForName:SDLNameMultiTouchAvailable ofClass:NSNumber.class error:&error];
}

- (void)setDoublePressAvailable:(NSNumber<SDLBool> *)doublePressAvailable {
    [store sdl_setObject:doublePressAvailable forName:SDLNameDoublePressAvailable];
}

- (NSNumber<SDLBool> *)doublePressAvailable {
    NSError *error;
    return [store sdl_objectForName:SDLNameDoublePressAvailable ofClass:NSNumber.class error:&error];
}

@end

NS_ASSUME_NONNULL_END
