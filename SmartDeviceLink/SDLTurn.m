//  SDLTurn.m
//

#import "SDLTurn.h"

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
    if (navigationText != nil) {
        [store setObject:navigationText forKey:SDLNameNavigationText];
    } else {
        [store removeObjectForKey:SDLNameNavigationText];
    }
}

- (nullable NSString *)navigationText {
    return [store objectForKey:SDLNameNavigationText];
}

- (void)setTurnIcon:(nullable SDLImage *)turnIcon {
    if (turnIcon != nil) {
        [store setObject:turnIcon forKey:SDLNameTurnIcon];
    } else {
        [store removeObjectForKey:SDLNameTurnIcon];
    }
}

- (nullable SDLImage *)turnIcon {
    NSObject *obj = [store objectForKey:SDLNameTurnIcon];
    if ([obj isKindOfClass:NSDictionary.class]) {
        return [[SDLImage alloc] initWithDictionary:(NSDictionary *)obj];
    }
    
    return (SDLImage*)obj;
}

@end

NS_ASSUME_NONNULL_END
