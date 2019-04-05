//  SDLSetDisplayLayout.m
//


#import "SDLSetDisplayLayout.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"
#import "SDLTemplateColorScheme.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLSetDisplayLayout

- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameSetDisplayLayout]) {
    }
    return self;
}

- (instancetype)initWithPredefinedLayout:(SDLPredefinedLayout)predefinedLayout {
    return [self initWithLayout:predefinedLayout];
}

- (instancetype)initWithLayout:(NSString *)displayLayout {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.displayLayout = displayLayout;

    return self;
}

- (instancetype)initWithPredefinedLayout:(SDLPredefinedLayout)predefinedLayout dayColorScheme:(SDLTemplateColorScheme *)dayColorScheme nightColorScheme:(SDLTemplateColorScheme *)nightColorScheme {
    self = [self initWithPredefinedLayout:predefinedLayout];
    if (!self) { return nil; }

    self.dayColorScheme = dayColorScheme;
    self.nightColorScheme = nightColorScheme;

    return self;
}

- (void)setDisplayLayout:(NSString *)displayLayout {
    [parameters sdl_setObject:displayLayout forName:SDLRPCParameterNameDisplayLayout];
}

- (NSString *)displayLayout {
    NSError *error = nil;
    return [parameters sdl_objectForName:SDLRPCParameterNameDisplayLayout ofClass:NSString.class error:&error];
}

- (void)setDayColorScheme:(nullable SDLTemplateColorScheme *)dayColorScheme {
    [parameters sdl_setObject:dayColorScheme forName:SDLRPCParameterNameDayColorScheme];
}

- (nullable SDLTemplateColorScheme *)dayColorScheme {
    return [parameters sdl_objectForName:SDLRPCParameterNameDayColorScheme ofClass:SDLTemplateColorScheme.class error:nil];
}

- (void)setNightColorScheme:(nullable SDLTemplateColorScheme *)nightColorScheme {
    [parameters sdl_setObject:nightColorScheme forName:SDLRPCParameterNameNightColorScheme];
}

- (nullable SDLTemplateColorScheme *)nightColorScheme {
    return [parameters sdl_objectForName:SDLRPCParameterNameNightColorScheme ofClass:SDLTemplateColorScheme.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
