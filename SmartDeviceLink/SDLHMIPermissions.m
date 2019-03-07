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
    NSError *error;
    return [store sdl_enumsForName:SDLNameAllowed error:&error];
}

- (void)setUserDisallowed:(NSArray<SDLHMILevel> *)userDisallowed {
    [store sdl_setObject:userDisallowed forName:SDLNameUserDisallowed];
}

- (NSArray<SDLHMILevel> *)userDisallowed {
    NSError *error;
    return [store sdl_enumsForName:SDLNameUserDisallowed error:&error];
}

@end

NS_ASSUME_NONNULL_END
