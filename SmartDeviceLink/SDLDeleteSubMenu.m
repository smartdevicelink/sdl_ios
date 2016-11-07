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

- (instancetype)initWithId:(UInt32)menuId {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.menuID = @(menuId);

    return self;
}

- (void)setMenuID:(NSNumber<SDLInt> *)menuID {
    [self setObject:menuID forName:SDLNameMenuId];
}

- (NSNumber<SDLInt> *)menuID {
    return [parameters objectForKey:SDLNameMenuId];
}

@end
