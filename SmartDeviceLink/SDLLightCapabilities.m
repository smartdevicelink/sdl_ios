//  SDLLightCapabilities.m
//

#import "SDLLightCapabilities.h"
#import "SDLNames.h"
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
    [store sdl_setObject:name forName:SDLNameName];
}

- (SDLLightName)name {
    NSError *error;
    return [store sdl_enumForName:SDLNameName error:&error];
}

- (void)setDensityAvailable:(nullable NSNumber<SDLBool> *)densityAvailable {
    [store sdl_setObject:densityAvailable forName:SDLNameDensityAvailable];
}

- (nullable NSNumber<SDLBool> *)densityAvailable {
    return [store sdl_objectForName:SDLNameDensityAvailable ofClass:NSNumber.class];
}

- (void)setColorAvailable:(nullable NSNumber<SDLBool> *)colorAvailable {
    [store sdl_setObject:colorAvailable forName:SDLNameRGBColorSpaceAvailable];
}

- (nullable NSNumber<SDLBool> *)colorAvailable {
    return [store sdl_objectForName:SDLNameRGBColorSpaceAvailable ofClass:NSNumber.class];
}

- (void)setStatusAvailable:(nullable NSNumber<SDLBool> *)statusAvailable {
    [store sdl_setObject:statusAvailable forName:SDLNameStatusAvailable];
}

- (nullable NSNumber<SDLBool> *)statusAvailable {
    return [store sdl_objectForName:SDLNameStatusAvailable ofClass:NSNumber.class];
}

@end

NS_ASSUME_NONNULL_END
