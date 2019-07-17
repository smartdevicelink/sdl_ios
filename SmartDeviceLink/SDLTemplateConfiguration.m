//
//  SDLTemplateConfiguration.m
//  SmartDeviceLink

#import "SDLTemplateConfiguration.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"

@implementation SDLTemplateConfiguration

- (instancetype)initWithTemplate:(NSString *)templateName {
    self = [self init];
    if (!self) {
        return nil;
    }
    
    self.templateName = templateName;
    return self;
}

- (instancetype)initWithTemplate:(NSString *)templateName dayColorScheme:(nullable SDLTemplateColorScheme *)dayColorScheme nightColorScheme:(nullable SDLTemplateColorScheme *)nightColorScheme {
    self = [self initWithTemplate:templateName];
    if (!self) {
        return nil;
    }
    self.dayColorScheme = dayColorScheme;
    self.nightColorScheme = nightColorScheme;
    return self;
}

- (void)setTemplate:(NSString *)templateName {
    [self.store sdl_setObject:templateName forName:SDLRPCParameterNameTemplate];
}

- (NSString *)templateName {
    return [self.store sdl_objectForName:SDLRPCParameterNameTemplate ofClass:NSString.class error:nil];
}

- (void)setDayColorScheme:(nullable SDLTemplateColorScheme *)dayColorScheme {
    [self.store sdl_setObject:dayColorScheme forName:SDLRPCParameterNameDayColorScheme];
}

- (nullable SDLTemplateColorScheme *)turnIcon {
    return [self.store sdl_objectForName:SDLRPCParameterNameDayColorScheme ofClass:SDLTemplateColorScheme.class error:nil];
}

- (void)setNightColorScheme:(nullable SDLTemplateColorScheme *)nightColorScheme {
    [self.store sdl_setObject:nightColorScheme forName:SDLRPCParameterNameTurnIcon];
}

- (nullable SDLTemplateColorScheme *)nightColorScheme {
    return [self.store sdl_objectForName:SDLRPCParameterNameNightColorScheme ofClass:SDLTemplateColorScheme.class error:nil];
}

@end
