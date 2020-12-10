//  SDLMenuParams.m
//


#import "SDLMenuParams.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLMenuParams

- (instancetype)initWithMenuName:(NSString *)menuName parentId:(UInt32)parentId position:(UInt16)position {
    self = [self initWithMenuName:menuName];
    if (!self) {
        return nil;
    }

    self.parentID = @(parentId);
    self.position = @(position);
    return self;
}

- (instancetype)initWithMenuName:(NSString *)menuName parentID:(nullable NSNumber<SDLUInt> *)parentID position:(nullable NSNumber<SDLUInt> *)position secondaryText:(nullable NSString *)secondaryText tertiaryText:(nullable NSString *)tertiaryText {
    self = [self initWithMenuName:menuName];
    if (!self) {
        return nil;
    }
    self.parentID = parentID;
    self.position = position;
    self.secondaryText = secondaryText;
    self.tertiaryText = tertiaryText;
    return self;
}

- (instancetype)initWithMenuName:(NSString *)menuName {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.menuName = menuName;

    return self;
}

- (void)setParentID:(nullable NSNumber<SDLUInt> *)parentID {
    [self.store sdl_setObject:parentID forName:SDLRPCParameterNameParentID];
}

- (nullable NSNumber<SDLUInt> *)parentID {
    return [self.store sdl_objectForName:SDLRPCParameterNameParentID ofClass:NSNumber.class error:nil];
}

- (void)setPosition:(nullable NSNumber<SDLUInt> *)position {
    [self.store sdl_setObject:position forName:SDLRPCParameterNamePosition];
}

- (nullable NSNumber<SDLUInt> *)position {
    return [self.store sdl_objectForName:SDLRPCParameterNamePosition ofClass:NSNumber.class error:nil];
}

- (void)setMenuName:(NSString *)menuName {
    [self.store sdl_setObject:menuName forName:SDLRPCParameterNameMenuName];
}

- (NSString *)menuName {
    return [self.store sdl_objectForName:SDLRPCParameterNameMenuName ofClass:NSString.class error:nil];
}

- (void)setSecondaryText:(nullable NSString *)secondaryText {
    [self.store sdl_setObject:secondaryText forName:SDLRPCParameterNameSecondaryText];
}

- (nullable NSString *)secondaryText {
    return [self.store sdl_objectForName:SDLRPCParameterNameSecondaryText ofClass:NSString.class error:nil];
}

- (void)setTertiaryText:(nullable NSString *)tertiaryText {
    [self.store sdl_setObject:tertiaryText forName:SDLRPCParameterNameTertiaryText];
}

- (nullable NSString *)tertiaryText {
    return [self.store sdl_objectForName:SDLRPCParameterNameTertiaryText ofClass:NSString.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
