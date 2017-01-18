//  SDLTurn.m
//

#import "SDLTurn.h"

#import "NSMutableDictionary+Store.h"
#import "SDLImage.h"
#import "SDLNames.h"

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
    [store sdl_setObject:navigationText forName:SDLNameNavigationText];
}

- (nullable NSString *)navigationText {
    return [store sdl_objectForName:SDLNameNavigationText];
}

- (void)setTurnIcon:(nullable SDLImage *)turnIcon {
    [store sdl_setObject:turnIcon forName:SDLNameTurnIcon];
}

- (nullable SDLImage *)turnIcon {
    return [store sdl_objectForName:SDLNameTurnIcon ofClass:SDLImage.class];
}

@end

NS_ASSUME_NONNULL_END
