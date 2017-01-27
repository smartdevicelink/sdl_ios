//  SDLResetGlobalProperties.m
//


#import "SDLResetGlobalProperties.h"

#import "NSMutableDictionary+Store.h"
#import "SDLGlobalProperty.h"
#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLResetGlobalProperties

- (instancetype)init {
    if (self = [super initWithName:SDLNameResetGlobalProperties]) {
    }
    return self;
}

- (instancetype)initWithProperties:(NSArray<SDLGlobalProperty> *)properties {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.properties = [properties mutableCopy];

    return self;
}

- (void)setProperties:(NSArray<SDLGlobalProperty> *)properties {
    [parameters sdl_setObject:properties forName:SDLNameProperties];
}

- (NSArray<SDLGlobalProperty> *)properties {
    return [parameters sdl_objectForName:SDLNameProperties];
}

@end

NS_ASSUME_NONNULL_END
