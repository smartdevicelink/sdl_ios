//  SDLParameterPermissions.m
//


#import "SDLParameterPermissions.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLParameterPermissions

- (void)setAllowed:(NSArray<NSString *> *)allowed {
    [store sdl_setObject:allowed forName:SDLRPCParameterNameAllowed];
}

- (NSArray<NSString *> *)allowed {
    return [store sdl_objectForName:SDLRPCParameterNameAllowed];
}

- (void)setUserDisallowed:(NSArray<NSString *> *)userDisallowed {
    [store sdl_setObject:userDisallowed forName:SDLRPCParameterNameUserDisallowed];
}

- (NSArray<NSString *> *)userDisallowed {
    return [store sdl_objectForName:SDLRPCParameterNameUserDisallowed];
}

@end

NS_ASSUME_NONNULL_END
