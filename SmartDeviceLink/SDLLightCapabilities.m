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

- (instancetype)initWithName:(SDLLightName)name desityAvailable:(BOOL)desityAvailable sRGBColorSpaceAvailable:(BOOL)sRGBColorSpaceAvailable {
    self = [self init];
    if(!self) {
        return nil;
    }
    self.name = name;
    self.densityAvailable = @(desityAvailable);
    self.sRGBColorSpaceAvailable = @(sRGBColorSpaceAvailable);

    return self;
}

- (void)setName:(SDLLightName)name {
    [store sdl_setObject:name forName:SDLNameName];
}

- (SDLLightName)name {
    return [store sdl_objectForName:SDLNameName];
}

- (void)setDensityAvailable:(nullable NSNumber<SDLBool> *)densityAvailable {
    [store sdl_setObject:densityAvailable forName:SDLNameDensityAvailable];
}

- (nullable NSNumber<SDLBool> *)densityAvailable {
    return [store sdl_objectForName:SDLNameDensityAvailable];
}

- (void)setSRGBColorSpaceAvailable:(nullable NSNumber<SDLBool> *)sRGBColorSpaceAvailable {
    [store sdl_setObject:sRGBColorSpaceAvailable forName:SDLNameSRGBColorSpaceAvailable];
}

- (nullable NSNumber<SDLBool> *)sRGBColorSpaceAvailable {
    return [store sdl_objectForName:SDLNameSRGBColorSpaceAvailable];
}

@end

NS_ASSUME_NONNULL_END
