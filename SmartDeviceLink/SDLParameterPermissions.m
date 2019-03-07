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
    NSError *error;
    return [store sdl_objectsForName:SDLNameAllowed ofClass:NSString.class error:&error];
}

- (void)setUserDisallowed:(NSArray<NSString *> *)userDisallowed {
    [store sdl_setObject:userDisallowed forName:SDLNameUserDisallowed];
}

- (NSArray<NSString *> *)userDisallowed {
    NSError *error;
    return [store sdl_objectsForName:SDLNameUserDisallowed ofClass:NSString.class error:&error];
}

@end

NS_ASSUME_NONNULL_END
