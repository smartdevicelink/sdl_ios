//  SDLAddSubMenu.m

#import "SDLAddSubMenu.h"

#import "SDLNames.h"

@implementation SDLAddSubMenu

- (instancetype)init {
    if (self = [super initWithName:SDLNameAddSubMenu]) {
    }
    return self;
}

- (void)setMenuID:(NSNumber<SDLInt> *)menuID {
    if (menuID != nil) {
        [parameters setObject:menuID forKey:SDLNameMenuId];
    } else {
        [parameters removeObjectForKey:SDLNameMenuId];
    }
}

- (NSNumber<SDLInt> *)menuID {
    return [parameters objectForKey:SDLNameMenuId];
}

- (void)setPosition:(NSNumber<SDLInt> *)position {
    if (position != nil) {
        [parameters setObject:position forKey:SDLNamePosition];
    } else {
        [parameters removeObjectForKey:SDLNamePosition];
    }
}

- (NSNumber<SDLInt> *)position {
    return [parameters objectForKey:SDLNamePosition];
}

- (void)setMenuName:(NSString *)menuName {
    if (menuName != nil) {
        [parameters setObject:menuName forKey:SDLNameMenuName];
    } else {
        [parameters removeObjectForKey:SDLNameMenuName];
    }
}

- (NSString *)menuName {
    return [parameters objectForKey:SDLNameMenuName];
}

@end
