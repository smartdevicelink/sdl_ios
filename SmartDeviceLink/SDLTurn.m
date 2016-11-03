//  SDLTurn.m
//

#import "SDLTurn.h"

#import "SDLImage.h"
#import "SDLNames.h"


@implementation SDLTurn

- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
    }
    return self;
}

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
    if (navigationText != nil) {
        [store setObject:navigationText forKey:NAMES_navigationText];
    } else {
        [store removeObjectForKey:NAMES_navigationText];
    }
}

- (NSString *)navigationText {
    return [store objectForKey:NAMES_navigationText];
}

- (void)setTurnIcon:(SDLImage *)turnIcon {
    if (turnIcon != nil) {
        [store setObject:turnIcon forKey:NAMES_turnIcon];
    } else {
        [store removeObjectForKey:NAMES_turnIcon];
    }
}

- (SDLImage *)turnIcon {
    NSObject *obj = [store objectForKey:NAMES_turnIcon];
    if (obj == nil || [obj isKindOfClass:SDLImage.class]) {
        return (SDLImage *)obj;
    } else {
        return [[SDLImage alloc] initWithDictionary:(NSMutableDictionary *)obj];
    }
}

@end
