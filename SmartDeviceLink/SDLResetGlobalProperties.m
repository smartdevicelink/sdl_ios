//  SDLResetGlobalProperties.m
//


#import "SDLResetGlobalProperties.h"

#import "NSMutableDictionary+Store.h"
#import "SDLGlobalProperty.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLResetGlobalProperties

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameResetGlobalProperties]) {
    }
    return self;
}
#pragma clang diagnostic pop

- (instancetype)initWithProperties:(NSArray<SDLGlobalProperty> *)properties {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.properties = [properties mutableCopy];

    return self;
}

- (void)setProperties:(NSArray<SDLGlobalProperty> *)properties {
    [self.parameters sdl_setObject:properties forName:SDLRPCParameterNameProperties];
}

- (NSArray<SDLGlobalProperty> *)properties {
    NSError *error = nil;
    return [self.parameters sdl_enumsForName:SDLRPCParameterNameProperties error:&error];
}

@end

NS_ASSUME_NONNULL_END
