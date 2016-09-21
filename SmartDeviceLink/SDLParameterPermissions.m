//  SDLParameterPermissions.m
//


#import "SDLParameterPermissions.h"



@implementation SDLParameterPermissions

- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
    }
    return self;
}

- (void)setAllowed:(NSMutableArray *)allowed {
    if (allowed != nil) {
        [store setObject:allowed forKey:SDLNameAllowed];
    } else {
        [store removeObjectForKey:SDLNameAllowed];
    }
}

- (NSMutableArray *)allowed {
    return [store objectForKey:SDLNameAllowed];
}

- (void)setUserDisallowed:(NSMutableArray *)userDisallowed {
    if (userDisallowed != nil) {
        [store setObject:userDisallowed forKey:SDLNameUserDisallowed];
    } else {
        [store removeObjectForKey:SDLNameUserDisallowed];
    }
}

- (NSMutableArray *)userDisallowed {
    return [store objectForKey:SDLNameUserDisallowed];
}

@end
