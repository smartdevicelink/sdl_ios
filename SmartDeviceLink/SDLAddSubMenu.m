//  SDLAddSubMenu.m

#import "SDLAddSubMenu.h"

#import "NSMutableDictionary+Store.h"
#import "SDLImage.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLAddSubMenu

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameAddSubMenu]) {
    }
    return self;
}
#pragma clang diagnostic pop

- (instancetype)initWithId:(UInt32)menuId menuName:(NSString *)menuName {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.menuID = @(menuId);
    self.menuName = menuName;

    return self;
}

- (instancetype)initWithId:(UInt32)menuId menuName:(NSString *)menuName position:(UInt8)position {
    return [self initWithId:menuId menuName:menuName menuLayout:nil menuIcon:nil position:position];
}

- (instancetype)initWithId:(UInt32)menuId menuName:(NSString *)menuName menuIcon:(nullable SDLImage *)icon position:(UInt8)position {
    return [self initWithId:menuId menuName:menuName menuLayout:nil menuIcon:icon position:position];
}

- (instancetype)initWithId:(UInt32)menuId menuName:(NSString *)menuName menuLayout:(nullable SDLMenuLayout)menuLayout menuIcon:(nullable SDLImage *)icon position:(UInt8)position {
    self = [self initWithId:menuId menuName:menuName];
    if (!self) { return nil; }

    self.position = @(position);
    self.menuIcon = icon;
    self.menuLayout = menuLayout;

    return self;
}

- (void)setMenuID:(NSNumber<SDLInt> *)menuID {
    [self.parameters sdl_setObject:menuID forName:SDLRPCParameterNameMenuId];
}

- (NSNumber<SDLInt> *)menuID {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameMenuId ofClass:NSNumber.class error:&error];
}

- (void)setPosition:(nullable NSNumber<SDLInt> *)position {
    [self.parameters sdl_setObject:position forName:SDLRPCParameterNamePosition];
}

- (nullable NSNumber<SDLInt> *)position {
    return [self.parameters sdl_objectForName:SDLRPCParameterNamePosition ofClass:NSNumber.class error:nil];
}

- (void)setMenuName:(NSString *)menuName {
    [self.parameters sdl_setObject:menuName forName:SDLRPCParameterNameMenuName];
}

- (NSString *)menuName {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameMenuName ofClass:NSString.class error:&error];
}

- (void)setMenuIcon:(nullable SDLImage *)menuIcon {
    [self.parameters sdl_setObject:menuIcon forName:SDLRPCParameterNameMenuIcon];
}

- (nullable SDLImage *)menuIcon {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameMenuIcon ofClass:[SDLImage class] error:nil];
}

- (void)setMenuLayout:(nullable SDLMenuLayout)menuLayout {
    [self.parameters sdl_setObject:menuLayout forName:SDLRPCParameterNameMenuLayout];
}

- (nullable SDLMenuLayout)menuLayout {
    return [self.parameters sdl_enumForName:SDLRPCParameterNameMenuLayout error:nil];
}

@end

NS_ASSUME_NONNULL_END
