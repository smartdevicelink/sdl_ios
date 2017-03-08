//  SDLParameterPermissions.m
//


#import "SDLParameterPermissions.h"

#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLParameterPermissions

- (void)setAllowed:(NSArray<NSString *> *)allowed {
    [store sdl_setObject:allowed forName:SDLNameAllowed];
}

- (NSArray<NSString *> *)allowed {
    return [store sdl_objectForName:SDLNameAllowed];
}

- (void)setUserDisallowed:(NSArray<NSString *> *)userDisallowed {
    [store sdl_setObject:userDisallowed forName:SDLNameUserDisallowed];
}

- (NSArray<NSString *> *)userDisallowed {
    return [store sdl_objectForName:SDLNameUserDisallowed];
}

@end

NS_ASSUME_NONNULL_END
