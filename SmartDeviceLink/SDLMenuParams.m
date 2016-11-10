//  SDLMenuParams.m
//


#import "SDLMenuParams.h"

#import "SDLNames.h"

@implementation SDLMenuParams

- (instancetype)initWithMenuName:(NSString *)menuName parentId:(UInt32)parentId position:(UInt16)position {
    self = [self initWithMenuName:menuName];
    if (!self) {
        return nil;
    }

    self.parentID = @(parentId);
    self.position = @(parentId);

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

- (void)setParentID:(NSNumber<SDLInt> *)parentID {
    [store sdl_setObject:parentID forName:SDLNameParentId];
}

- (NSNumber<SDLInt> *)parentID {
    return [store sdl_objectForName:SDLNameParentId];
}

- (void)setPosition:(NSNumber<SDLInt> *)position {
    [store sdl_setObject:position forName:SDLNamePosition];
}

- (NSNumber<SDLInt> *)position {
    return [store sdl_objectForName:SDLNamePosition];
}

- (void)setMenuName:(NSString *)menuName {
    [store sdl_setObject:menuName forName:SDLNameMenuName];
}

- (NSString *)menuName {
    return [store sdl_objectForName:SDLNameMenuName];
}

@end
