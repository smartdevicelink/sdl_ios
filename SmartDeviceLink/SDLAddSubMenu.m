//  SDLAddSubMenu.m

#import "SDLAddSubMenu.h"

#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLAddSubMenu

- (instancetype)init {
    if (self = [super initWithName:SDLNameAddSubMenu]) {
    }
    return self;
}


- (instancetype)initWithId:(UInt32)menuId menuName:(NSString *)menuName position:(UInt8)position {
    self = [self initWithId:menuId menuName:menuName];
    if (!self) {
        return nil;
    }

    self.position = @(position);

    return self;
}

- (instancetype)initWithId:(UInt32)menuId menuName:(NSString *)menuName {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.menuID = @(menuId);
    self.menuName = menuName;

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

- (void)setPosition:(nullable NSNumber<SDLInt> *)position {
    if (position != nil) {
        [parameters setObject:position forKey:SDLNamePosition];
    } else {
        [parameters removeObjectForKey:SDLNamePosition];
    }
}

- (nullable NSNumber<SDLInt> *)position {
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

NS_ASSUME_NONNULL_END
