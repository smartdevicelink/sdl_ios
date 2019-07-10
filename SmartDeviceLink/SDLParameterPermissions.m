//  SDLParameterPermissions.m
//


#import "SDLParameterPermissions.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLParameterPermissions

- (void)setAllowed:(NSArray<NSString *> *)allowed {
    [self.store sdl_setObject:allowed forName:SDLRPCParameterNameAllowed];
}

- (NSArray<NSString *> *)allowed {
    NSError *error = nil;
    return [self.store sdl_objectsForName:SDLRPCParameterNameAllowed ofClass:NSString.class error:&error];
}

- (void)setUserDisallowed:(NSArray<NSString *> *)userDisallowed {
    [self.store sdl_setObject:userDisallowed forName:SDLRPCParameterNameUserDisallowed];
}

- (NSArray<NSString *> *)userDisallowed {
    NSError *error = nil;
    return [self.store sdl_objectsForName:SDLRPCParameterNameUserDisallowed ofClass:NSString.class error:&error];
}

@end

NS_ASSUME_NONNULL_END
