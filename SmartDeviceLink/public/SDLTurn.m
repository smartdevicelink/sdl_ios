//  SDLTurn.m
//

#import "SDLTurn.h"

#import "NSMutableDictionary+Store.h"
#import "SDLImage.h"
#import "SDLRPCParameterNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLTurn

- (instancetype)initWithNavigationText:(nullable NSString *)navigationText turnIcon:(nullable SDLImage *)icon {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.navigationText = navigationText;
    self.turnIcon = icon;

    return self;
}

- (void)setNavigationText:(nullable NSString *)navigationText {
    [self.store sdl_setObject:navigationText forName:SDLRPCParameterNameNavigationText];
}

- (nullable NSString *)navigationText {
    return [self.store sdl_objectForName:SDLRPCParameterNameNavigationText ofClass:NSString.class error:nil];
}

- (void)setTurnIcon:(nullable SDLImage *)turnIcon {
    [self.store sdl_setObject:turnIcon forName:SDLRPCParameterNameTurnIcon];
}

- (nullable SDLImage *)turnIcon {
    return [self.store sdl_objectForName:SDLRPCParameterNameTurnIcon ofClass:SDLImage.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
