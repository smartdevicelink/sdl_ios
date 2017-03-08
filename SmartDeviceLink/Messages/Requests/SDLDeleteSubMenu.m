//  SDLDeleteSubMenu.m
//


#import "SDLDeleteSubMenu.h"

#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

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
    [parameters sdl_setObject:menuID forName:SDLNameMenuId];
}

- (NSNumber<SDLInt> *)menuID {
    return [parameters sdl_objectForName:SDLNameMenuId];
}

@end

NS_ASSUME_NONNULL_END
