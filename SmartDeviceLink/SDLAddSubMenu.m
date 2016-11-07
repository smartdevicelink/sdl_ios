//  SDLAddSubMenu.m

#import "SDLAddSubMenu.h"

#import "SDLNames.h"

@implementation SDLAddSubMenu

- (instancetype)init {
    if (self = [super initWithName:SDLNameAddSubMenu]) {
    }
    return self;
}


- (instancetype)initWithId:(UInt8)menuId menuName:(NSString *)menuName position:(UInt8)position {
    self = [self initWithId:menuId menuName:menuName];
    if (!self) {
        return nil;
    }

    self.position = @(position);

    return self;
}

- (instancetype)initWithId:(UInt8)menuId menuName:(NSString *)menuName {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.menuID = @(menuId);
    self.menuName = menuName;

    return self;
}

- (void)setMenuID:(NSNumber<SDLInt> *)menuID {
    [self setObject:menuID forName:SDLNameMenuId];
}

- (NSNumber<SDLInt> *)menuID {
    return [parameters objectForKey:SDLNameMenuId];
}

- (void)setPosition:(NSNumber<SDLInt> *)position {
    [self setObject:position forName:SDLNamePosition];
}

- (NSNumber<SDLInt> *)position {
    return [parameters objectForKey:SDLNamePosition];
}

- (void)setMenuName:(NSString *)menuName {
    [self setObject:menuName forName:SDLNameMenuName];
}

- (NSString *)menuName {
    return [parameters objectForKey:SDLNameMenuName];
}

@end
