//  SDLTurn.m
//

#import "SDLTurn.h"

#import "SDLImage.h"
#import "SDLNames.h"

@implementation SDLTurn

- (void)setNavigationText:(NSString *)navigationText {
    if (navigationText != nil) {
        [store setObject:navigationText forKey:SDLNameNavigationText];
    } else {
        [store removeObjectForKey:SDLNameNavigationText];
    }
}

- (NSString *)navigationText {
    return [store objectForKey:SDLNameNavigationText];
}

- (void)setTurnIcon:(SDLImage *)turnIcon {
    if (turnIcon != nil) {
        [store setObject:turnIcon forKey:SDLNameTurnIcon];
    } else {
        [store removeObjectForKey:SDLNameTurnIcon];
    }
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
