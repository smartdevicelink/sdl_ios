//  SDLParameterPermissions.m
//


#import "SDLParameterPermissions.h"

#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLParameterPermissions

- (void)setAllowed:(NSMutableArray<NSString *> *)allowed {
    if (allowed != nil) {
        [store setObject:allowed forKey:SDLNameAllowed];
    } else {
        [store removeObjectForKey:SDLNameAllowed];
    }
}

- (NSMutableArray<NSString *> *)allowed {
    return [store objectForKey:SDLNameAllowed];
}

- (void)setUserDisallowed:(NSMutableArray<NSString *> *)userDisallowed {
    if (userDisallowed != nil) {
        [store setObject:userDisallowed forKey:SDLNameUserDisallowed];
    } else {
        [store removeObjectForKey:SDLNameUserDisallowed];
    }
}

- (NSMutableArray<NSString *> *)userDisallowed {
    return [store objectForKey:SDLNameUserDisallowed];
}

@end

NS_ASSUME_NONNULL_END
