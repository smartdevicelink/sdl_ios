//  SDLAddSubMenu.m

#import "SDLAddSubMenu.h"

#import "NSMutableDictionary+Store.h"
#import "SDLImage.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLAddSubMenu

- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameAddSubMenu]) {
    }
    return self;
}

- (instancetype)initWithId:(UInt32)menuId menuName:(NSString *)menuName menuIcon:(nullable SDLImage *)icon position:(UInt8)position {
    self = [self initWithId:menuId menuName:menuName];
    if (!self) { return nil; }

    self.position = @(position);
    self.menuIcon = icon;

    return self;
}

- (instancetype)initWithId:(UInt32)menuId menuName:(NSString *)menuName position:(UInt8)position {
    return [self initWithId:menuId menuName:menuName menuIcon:nil position:position];
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
    [parameters sdl_setObject:menuID forName:SDLRPCParameterNameMenuId];
}

- (NSNumber<SDLInt> *)menuID {
    return [parameters sdl_objectForName:SDLRPCParameterNameMenuId];
}

- (void)setPosition:(nullable NSNumber<SDLInt> *)position {
    [parameters sdl_setObject:position forName:SDLRPCParameterNamePosition];
}

- (nullable NSNumber<SDLInt> *)position {
    return [parameters sdl_objectForName:SDLRPCParameterNamePosition];
}

- (void)setMenuName:(NSString *)menuName {
    [parameters sdl_setObject:menuName forName:SDLRPCParameterNameMenuName];
}

- (NSString *)menuName {
    return [parameters sdl_objectForName:SDLRPCParameterNameMenuName];
}

- (void)setMenuIcon:(nullable SDLImage *)menuIcon {
    [parameters sdl_setObject:menuIcon forName:SDLRPCParameterNameMenuIcon];
}

- (nullable SDLImage *)menuIcon {
    return [parameters sdl_objectForName:SDLRPCParameterNameMenuIcon ofClass:[SDLImage class]];
}

@end

NS_ASSUME_NONNULL_END
