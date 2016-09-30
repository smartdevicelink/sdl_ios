//  SDLDeleteSubMenu.m
//


#import "SDLDeleteSubMenu.h"

#import "SDLNames.h"

@implementation SDLDeleteSubMenu

- (instancetype)init {
    if (self = [super initWithName:SDLNameDeleteSubMenu]) {
    }
    return self;
}

- (void)setMenuID:(NSNumber *)menuID {
    if (menuID != nil) {
        [parameters setObject:menuID forKey:SDLNameMenuId];
    } else {
        [parameters removeObjectForKey:SDLNameMenuId];
    }
}

- (NSNumber *)menuID {
    return [parameters objectForKey:SDLNameMenuId];
}

@end
