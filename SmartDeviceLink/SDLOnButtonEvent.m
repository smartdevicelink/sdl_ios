//  SDLOnButtonEvent.m
//

#import "SDLOnButtonEvent.h"

#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLOnButtonEvent

- (instancetype)init {
    if (self = [super initWithName:SDLNameOnButtonEvent]) {
    }
    return self;
}

- (void)setButtonName:(SDLButtonName)buttonName {
    [parameters sdl_setObject:buttonName forName:SDLNameButtonName];
}

- (SDLButtonName)buttonName {
    NSObject *obj = [parameters sdl_objectForName:SDLNameButtonName];
    return (SDLButtonName)obj;
}

- (void)setButtonEventMode:(SDLButtonEventMode)buttonEventMode {
    [parameters sdl_setObject:buttonEventMode forName:SDLNameButtonEventMode];
}

- (SDLButtonEventMode)buttonEventMode {
    NSObject *obj = [parameters sdl_objectForName:SDLNameButtonEventMode];
    return (SDLButtonEventMode)obj;
}

- (void)setCustomButtonID:(nullable NSNumber<SDLInt> *)customButtonID {
    [parameters sdl_setObject:customButtonID forName:SDLNameCustomButtonId];
}

- (nullable NSNumber<SDLInt> *)customButtonID {
    return [parameters sdl_objectForName:SDLNameCustomButtonId];
}

@end

NS_ASSUME_NONNULL_END
