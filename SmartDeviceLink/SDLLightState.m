//  SDLLightState.m
//

#import "SDLLightState.h"
#import "SDLNames.h"
#import "NSMutableDictionary+Store.h"
#import "SDLRGBColor.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLLightState

- (instancetype)initWithId:(SDLLightName)id status:(SDLLightStatus)status{
    self = [self init];
    if(!self) {
        return nil;
    }
    self.id = id;
    self.status = status;

    return self;
}

- (instancetype)initWithId:(SDLLightName)id status:(SDLLightStatus)status density:(double)density color:(SDLRGBColor *)color {
    self = [self init];
    if(!self) {
        return nil;
    }
    self.id = id;
    self.status = status;
    self.density = @(density);
    self.color = color;

    return self;
}

- (instancetype)initWithId:(SDLLightName)id lightStatus:(SDLLightStatus)lightStatus lightDensity:(double)lightDensity lightColor:(UIColor *)lightColor {
    self = [self init];
    if(!self) {
        return nil;
    }
    self.id = id;
    self.status = lightStatus;
    self.density = @(lightDensity);
    self.color = [[SDLRGBColor alloc] initWithColor:lightColor];

    return self;
}

- (void)setId:(SDLLightName)id {
    [store sdl_setObject:id forName:SDLNameId];
}

- (SDLLightName)id {
    NSError *error;
    return [store sdl_enumForName:SDLNameId error:&error];
}

- (void)setStatus:(SDLLightStatus)status {
    [store sdl_setObject:status forName:SDLNameStatus];
}

- (SDLLightStatus)status {
    NSError *error;
    return [store sdl_enumForName:SDLNameStatus error:&error];
}

- (void)setDensity:(nullable NSNumber<SDLFloat> *)density {
    [store sdl_setObject:density forName:SDLNameDensity];
}

- (nullable NSNumber<SDLFloat> *)density {
    return [store sdl_objectForName:SDLNameDensity ofClass:NSNumber.class];
}

- (void)setColor:(nullable SDLRGBColor *)color {
    [store sdl_setObject:color forName:SDLNameColor];
}

- (nullable SDLRGBColor *)color {
    return [store sdl_objectForName:SDLNameColor ofClass:[SDLRGBColor class]];
}

@end

NS_ASSUME_NONNULL_END
