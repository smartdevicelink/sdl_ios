//  SDLParameterPermissions.m
//


#import "SDLParameterPermissions.h"

#import "SDLNames.h"

@implementation SDLParameterPermissions

- (void)setAllowed:(NSMutableArray<NSString *> *)allowed {
    [self setObject:allowed forName:SDLNameAllowed];
}

- (NSMutableArray<NSString *> *)allowed {
    return [self objectForName:SDLNameAllowed];
}

- (void)setUserDisallowed:(NSMutableArray<NSString *> *)userDisallowed {
    [self setObject:userDisallowed forName:SDLNameUserDisallowed];
}

- (NSMutableArray<NSString *> *)userDisallowed {
    return [self objectForName:SDLNameUserDisallowed];
}

@end
