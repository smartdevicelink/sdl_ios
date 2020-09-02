//  SDLDeleteSubMenu.m
//


#import "SDLDeleteSubMenu.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLDeleteSubMenu

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameDeleteSubMenu]) {
    }
    return self;
}
#pragma clang diagnostic pop

- (instancetype)initWithId:(UInt32)menuId {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.menuID = @(menuId);

    return self;
}

- (void)setMenuID:(NSNumber<SDLInt> *)menuID {
    [self.parameters sdl_setObject:menuID forName:SDLRPCParameterNameMenuID];
}

- (NSNumber<SDLInt> *)menuID {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameMenuID ofClass:NSNumber.class error:&error];
}

@end

NS_ASSUME_NONNULL_END
