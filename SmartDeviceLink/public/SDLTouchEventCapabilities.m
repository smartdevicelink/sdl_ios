//  SDLTouchEventCapabilities.m
//


#import "SDLTouchEventCapabilities.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLTouchEventCapabilities

- (void)setPressAvailable:(NSNumber<SDLBool> *)pressAvailable {
    [self.store sdl_setObject:pressAvailable forName:SDLRPCParameterNamePressAvailable];
}

- (NSNumber<SDLBool> *)pressAvailable {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNamePressAvailable ofClass:NSNumber.class error:&error];
}

- (void)setMultiTouchAvailable:(NSNumber<SDLBool> *)multiTouchAvailable {
    [self.store sdl_setObject:multiTouchAvailable forName:SDLRPCParameterNameMultiTouchAvailable];
}

- (NSNumber<SDLBool> *)multiTouchAvailable {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNameMultiTouchAvailable ofClass:NSNumber.class error:&error];
}

- (void)setDoublePressAvailable:(NSNumber<SDLBool> *)doublePressAvailable {
    [self.store sdl_setObject:doublePressAvailable forName:SDLRPCParameterNameDoublePressAvailable];
}

- (NSNumber<SDLBool> *)doublePressAvailable {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNameDoublePressAvailable ofClass:NSNumber.class error:&error];
}

@end

NS_ASSUME_NONNULL_END
