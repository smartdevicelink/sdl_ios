//  SDLHMIPermissions.m
//


#import "SDLHMIPermissions.h"

#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLHMIPermissions

- (void)setAllowed:(NSMutableArray<SDLHMILevel> *)allowed {
    [store sdl_setObject:allowed forName:SDLNameAllowed];
}

- (NSMutableArray<SDLHMILevel> *)allowed {
    return [store sdl_enumsForName:SDLNameAllowed];
}

- (void)setUserDisallowed:(NSMutableArray<SDLHMILevel> *)userDisallowed {
    [store sdl_setObject:userDisallowed forName:SDLNameUserDisallowed];
}

- (NSMutableArray<SDLHMILevel> *)userDisallowed {
    return [store sdl_enumsForName:SDLNameUserDisallowed];
}

@end

NS_ASSUME_NONNULL_END
