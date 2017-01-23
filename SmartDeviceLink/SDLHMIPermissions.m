//  SDLHMIPermissions.m
//


#import "SDLHMIPermissions.h"

#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLHMIPermissions

- (void)setAllowed:(NSArray<SDLHMILevel> *)allowed {
    [store sdl_setObject:allowed forName:SDLNameAllowed];
}

- (NSArray<SDLHMILevel> *)allowed {
    return [store sdl_objectForName:SDLNameAllowed];
}

- (void)setUserDisallowed:(NSArray<SDLHMILevel> *)userDisallowed {
    [store sdl_setObject:userDisallowed forName:SDLNameUserDisallowed];
}

- (NSArray<SDLHMILevel> *)userDisallowed {
    return [store sdl_objectForName:SDLNameUserDisallowed];
}

@end

NS_ASSUME_NONNULL_END
