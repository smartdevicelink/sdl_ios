//  SDLTurn.m
//

#import "SDLTurn.h"

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
    NSObject *obj = [store objectForKey:SDLNameTurnIcon];
    if (obj == nil || [obj isKindOfClass:SDLImage.class]) {
        return (SDLImage *)obj;
    } else {
        return [[SDLImage alloc] initWithDictionary:(NSDictionary *)obj];
    }
}

@end
