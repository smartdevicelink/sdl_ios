//
//  SDLTemplateConfiguration.m
//  SmartDeviceLink

#import "SDLTemplateConfiguration.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"

@implementation SDLTemplateConfiguration


- (instancetype)initWithPredefinedLayout:(SDLPredefinedLayout)predefinedLayout {
    return [self initWithTemplate:predefinedLayout];
}

- (instancetype)initWithTemplate:(NSString *)template {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.template = template;
    return self;
}

- (instancetype)initWithTemplate:(NSString *)template dayColorScheme:(nullable SDLTemplateColorScheme *)dayColorScheme nightColorScheme:(nullable SDLTemplateColorScheme *)nightColorScheme {
    self = [self initWithTemplate:template];
    if (!self) {
        return nil;
    }
    self.dayColorScheme = dayColorScheme;
    self.nightColorScheme = nightColorScheme;
    return self;
}

- (void)setTemplate:(NSString *)template {
    [self.store sdl_setObject:template forName:SDLRPCParameterNameTemplate];
}

- (NSString *)template {
    return [self.store sdl_objectForName:SDLRPCParameterNameTemplate ofClass:NSString.class error:nil];
}

- (void)setDayColorScheme:(nullable SDLTemplateColorScheme *)dayColorScheme {
    [self.store sdl_setObject:dayColorScheme forName:SDLRPCParameterNameDayColorScheme];
}

- (nullable SDLTemplateColorScheme *)dayColorScheme {
    return [self.store sdl_objectForName:SDLRPCParameterNameDayColorScheme ofClass:SDLTemplateColorScheme.class error:nil];
}

- (void)setNightColorScheme:(nullable SDLTemplateColorScheme *)nightColorScheme {
    [self.store sdl_setObject:nightColorScheme forName:SDLRPCParameterNameNightColorScheme];
}

- (nullable SDLTemplateColorScheme *)nightColorScheme {
    return [self.store sdl_objectForName:SDLRPCParameterNameNightColorScheme ofClass:SDLTemplateColorScheme.class error:nil];
}

@end
