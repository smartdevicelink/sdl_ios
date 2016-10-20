//  SDLHMIPermissions.m
//


#import "SDLHMIPermissions.h"

#import "SDLNames.h"

@implementation SDLHMIPermissions

- (void)setAllowed:(NSMutableArray<SDLHMILevel> *)allowed {
    if (allowed != nil) {
        [store setObject:allowed forKey:SDLNameAllowed];
    } else {
        [store removeObjectForKey:SDLNameAllowed];
    }
}

- (NSMutableArray<SDLHMILevel> *)allowed {
    NSMutableArray<SDLHMILevel> *array = [store objectForKey:SDLNameAllowed];
    if ([array count] < 1) {
        return array;
    } else {
        NSMutableArray<SDLHMILevel> *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSString *enumString in array) {
            [newList addObject:(SDLHMILevel)enumString];
        }
        return newList;
    }
}

- (void)setUserDisallowed:(NSMutableArray<SDLHMILevel> *)userDisallowed {
    if (userDisallowed != nil) {
        [store setObject:userDisallowed forKey:SDLNameUserDisallowed];
    } else {
        [store removeObjectForKey:SDLNameUserDisallowed];
    }
}

- (NSMutableArray<SDLHMILevel> *)userDisallowed {
    NSMutableArray<SDLHMILevel> *array = [store objectForKey:SDLNameUserDisallowed];
    if ([array count] < 1) {
        return array;
    } else {
        NSMutableArray<SDLHMILevel> *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSString *enumString in array) {
            [newList addObject:(SDLHMILevel)enumString];
        }
        return newList;
    }

}

@end
