//  SDLResetGlobalProperties.m
//


#import "SDLResetGlobalProperties.h"

#import "NSMutableDictionary+Store.h"
#import "SDLGlobalProperty.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLResetGlobalProperties

- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameResetGlobalProperties]) {
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
    [parameters sdl_setObject:properties forName:SDLRPCParameterNameProperties];
}

- (NSArray<SDLGlobalProperty> *)properties {
    NSError *error = nil;
    return [parameters sdl_enumsForName:SDLRPCParameterNameProperties error:&error];
}

@end

NS_ASSUME_NONNULL_END
