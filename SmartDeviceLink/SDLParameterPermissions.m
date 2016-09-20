//  SDLParameterPermissions.m
//


#import "SDLParameterPermissions.h"

#import "SDLNames.h"

@implementation SDLParameterPermissions

- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary<NSString *, id> *)dict {
    if (self = [super initWithDictionary:dict]) {
    }
    return self;
}

- (void)setAllowed:(NSMutableArray<NSString*> *)allowed {
    if (allowed != nil) {
        [store setObject:allowed forKey:NAMES_allowed];
    } else {
        [store removeObjectForKey:NAMES_allowed];
    }
}

- (NSMutableArray<NSString*> *)allowed {
    return [store objectForKey:NAMES_allowed];
}

- (void)setUserDisallowed:(NSMutableArray<NSString*> *)userDisallowed {
    if (userDisallowed != nil) {
        [store setObject:userDisallowed forKey:NAMES_userDisallowed];
    } else {
        [store removeObjectForKey:NAMES_userDisallowed];
    }
}

- (NSMutableArray<NSString*> *)userDisallowed {
    return [store objectForKey:NAMES_userDisallowed];
}

@end
