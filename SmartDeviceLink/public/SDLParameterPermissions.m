//  SDLParameterPermissions.m
//


#import "SDLParameterPermissions.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLParameterPermissions

- (instancetype)initWithAllowed:(NSArray<NSString *> *)allowed userDisallowed:(NSArray<NSString *> *)userDisallowed {
    self = [self init];
    if (!self) {
        return nil;
    }
    self.allowed = allowed;
    self.userDisallowed = userDisallowed;
    return self;
}

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
