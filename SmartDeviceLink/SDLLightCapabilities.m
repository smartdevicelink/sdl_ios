//  SDLLightCapabilities.m
//

#import "SDLLightCapabilities.h"
#import "SDLRPCParameterNames.h"
#import "NSMutableDictionary+Store.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLLightCapabilities

- (instancetype)initWithName:(SDLLightName)name {
    self = [self init];
    if(!self) {
        return nil;
    }
    self.name = name;

    return self;
}

- (instancetype)initWithName:(SDLLightName)name densityAvailable:(BOOL)densityAvailable colorAvailable:(BOOL)colorAvailable statusAvailable:(BOOL)statusAvailable {
    self = [self init];
    if(!self) {
        return nil;
    }
    self.name = name;
    self.densityAvailable = @(densityAvailable);
    self.colorAvailable = @(colorAvailable);
    self.statusAvailable = @(statusAvailable);

    return self;
}

- (void)setName:(SDLLightName)name {
    [self.store sdl_setObject:name forName:SDLRPCParameterNameName];
}

- (SDLLightName)name {
    NSError *error = nil;
    return [self.store sdl_enumForName:SDLRPCParameterNameName error:&error];
}

- (void)setDensityAvailable:(nullable NSNumber<SDLBool> *)densityAvailable {
    [self.store sdl_setObject:densityAvailable forName:SDLRPCParameterNameDensityAvailable];
}

- (nullable NSNumber<SDLBool> *)densityAvailable {
    return [self.store sdl_objectForName:SDLRPCParameterNameDensityAvailable ofClass:NSNumber.class error:nil];
}

- (void)setColorAvailable:(nullable NSNumber<SDLBool> *)colorAvailable {
    [self.store sdl_setObject:colorAvailable forName:SDLRPCParameterNameRGBColorSpaceAvailable];
}

- (nullable NSNumber<SDLBool> *)colorAvailable {
    return [self.store sdl_objectForName:SDLRPCParameterNameRGBColorSpaceAvailable ofClass:NSNumber.class error:nil];
}

- (void)setStatusAvailable:(nullable NSNumber<SDLBool> *)statusAvailable {
    [self.store sdl_setObject:statusAvailable forName:SDLRPCParameterNameStatusAvailable];
}

- (nullable NSNumber<SDLBool> *)statusAvailable {
    return [self.store sdl_objectForName:SDLRPCParameterNameStatusAvailable ofClass:NSNumber.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
