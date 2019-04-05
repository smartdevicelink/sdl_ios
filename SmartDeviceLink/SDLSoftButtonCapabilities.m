//  SDLSoftButtonCapabilities.m
//


#import "SDLSoftButtonCapabilities.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLSoftButtonCapabilities

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

- (void)setImageSupported:(NSNumber<SDLBool> *)imageSupported {
    [store sdl_setObject:imageSupported forName:SDLRPCParameterNameImageSupported];
}

- (NSNumber<SDLBool> *)imageSupported {
    NSError *error = nil;
    return [store sdl_objectForName:SDLRPCParameterNameImageSupported ofClass:NSNumber.class error:&error];
}

@end

NS_ASSUME_NONNULL_END
