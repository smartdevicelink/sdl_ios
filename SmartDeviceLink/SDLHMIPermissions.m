//  SDLHMIPermissions.m
//


#import "SDLHMIPermissions.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLHMIPermissions

- (void)setAllowed:(NSArray<SDLHMILevel> *)allowed {
    [store sdl_setObject:allowed forName:SDLRPCParameterNameAllowed];
}

- (NSArray<SDLHMILevel> *)allowed {
    return [store sdl_objectForName:SDLRPCParameterNameAllowed];
}

- (void)setUserDisallowed:(NSArray<SDLHMILevel> *)userDisallowed {
    [store sdl_setObject:userDisallowed forName:SDLRPCParameterNameUserDisallowed];
}

- (NSArray<SDLHMILevel> *)userDisallowed {
    return [store sdl_objectForName:SDLRPCParameterNameUserDisallowed];
}

@end

NS_ASSUME_NONNULL_END
