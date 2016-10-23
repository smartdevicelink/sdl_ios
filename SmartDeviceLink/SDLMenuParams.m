//  SDLMenuParams.m
//


#import "SDLMenuParams.h"

#import "SDLNames.h"

@implementation SDLMenuParams

- (void)setParentID:(NSNumber<SDLInt> *)parentID {
    if (parentID != nil) {
        [store setObject:parentID forKey:SDLNameParentId];
    } else {
        [store removeObjectForKey:SDLNameParentId];
    }
}

- (NSNumber<SDLInt> *)parentID {
    return [store objectForKey:SDLNameParentId];
}

- (void)setPosition:(NSNumber<SDLInt> *)position {
    if (position != nil) {
        [store setObject:position forKey:SDLNamePosition];
    } else {
        [store removeObjectForKey:SDLNamePosition];
    }
}

- (NSNumber<SDLInt> *)position {
    return [store objectForKey:SDLNamePosition];
}

- (void)setMenuName:(NSString *)menuName {
    if (menuName != nil) {
        [store setObject:menuName forKey:SDLNameMenuName];
    } else {
        [store removeObjectForKey:SDLNameMenuName];
    }
}

- (NSString *)menuName {
    return [store objectForKey:SDLNameMenuName];
}

@end
