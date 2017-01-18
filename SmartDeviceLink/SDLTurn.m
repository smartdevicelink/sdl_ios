//  SDLTurn.m
//

#import "SDLTurn.h"

#import "NSMutableDictionary+Store.h"
#import "SDLImage.h"
#import "SDLNames.h"


@implementation SDLTurn

- (instancetype)initWithNavigationText:(NSString *)navigationText turnIcon:(SDLImage *)icon {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.navigationText = navigationText;
    self.turnIcon = icon;

    return self;
}

- (void)setNavigationText:(NSString *)navigationText {
    [store sdl_setObject:navigationText forName:SDLNameNavigationText];
}

- (NSString *)navigationText {
    return [store sdl_objectForName:SDLNameNavigationText];
}

- (void)setTurnIcon:(SDLImage *)turnIcon {
    [store sdl_setObject:turnIcon forName:SDLNameTurnIcon];
}

- (SDLImage *)turnIcon {
    return [store sdl_objectForName:SDLNameTurnIcon ofClass:SDLImage.class];
}

@end
