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

- (instancetype)initWithMenuName:(NSString *)menuName {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.menuName = menuName;

    return self;
}

- (void)setParentID:(nullable NSNumber<SDLInt> *)parentID {
    [self.store sdl_setObject:parentID forName:SDLRPCParameterNameParentID];
}

- (nullable NSNumber<SDLInt> *)parentID {
    return [self.store sdl_objectForName:SDLRPCParameterNameParentID ofClass:NSNumber.class error:nil];
}

- (void)setPosition:(nullable NSNumber<SDLInt> *)position {
    [self.store sdl_setObject:position forName:SDLRPCParameterNamePosition];
}

- (nullable NSNumber<SDLInt> *)position {
    return [self.store sdl_objectForName:SDLRPCParameterNamePosition ofClass:NSNumber.class error:nil];
}

- (void)setMenuName:(NSString *)menuName {
    [self.store sdl_setObject:menuName forName:SDLRPCParameterNameMenuName];
}

- (NSString *)menuName {
    return [self.store sdl_objectForName:SDLRPCParameterNameMenuName ofClass:NSString.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
