//  SDLHMIPermissions.m
//


#import "SDLHMIPermissions.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLHMIPermissions

- (void)setAllowed:(NSArray<SDLHMILevel> *)allowed {
    [self.store sdl_setObject:allowed forName:SDLRPCParameterNameAllowed];
}

- (NSArray<SDLHMILevel> *)allowed {
    NSError *error = nil;
    return [self.store sdl_enumsForName:SDLRPCParameterNameAllowed error:&error];
}

- (void)setUserDisallowed:(NSArray<SDLHMILevel> *)userDisallowed {
    [self.store sdl_setObject:userDisallowed forName:SDLRPCParameterNameUserDisallowed];
}

- (NSArray<SDLHMILevel> *)userDisallowed {
    NSError *error = nil;
    return [self.store sdl_enumsForName:SDLRPCParameterNameUserDisallowed error:&error];
}

@end

NS_ASSUME_NONNULL_END
