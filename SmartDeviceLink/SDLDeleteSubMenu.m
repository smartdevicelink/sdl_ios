//  SDLDeleteSubMenu.m
//


#import "SDLDeleteSubMenu.h"



@implementation SDLDeleteSubMenu

- (instancetype)init {
    if (self = [super initWithName:SDLNameDeleteSubMenu]) {
    }
    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
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
