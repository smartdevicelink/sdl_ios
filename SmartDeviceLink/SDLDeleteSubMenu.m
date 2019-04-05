//  SDLDeleteSubMenu.m
//


#import "SDLDeleteSubMenu.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLDeleteSubMenu

- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameDeleteSubMenu]) {
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
    [parameters sdl_setObject:menuID forName:SDLRPCParameterNameMenuId];
}

- (NSNumber<SDLInt> *)menuID {
    NSError *error = nil;
    return [parameters sdl_objectForName:SDLRPCParameterNameMenuId ofClass:NSNumber.class error:&error];
}

@end

NS_ASSUME_NONNULL_END
