//  SDLOnButtonPress.m
//

#import "SDLOnButtonPress.h"

#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLOnButtonPress

- (instancetype)init {
    if (self = [super initWithName:SDLNameOnButtonPress]) {
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

- (void)setButtonPressMode:(SDLButtonPressMode)buttonPressMode {
    [parameters sdl_setObject:buttonPressMode forName:SDLNameButtonPressMode];
}

- (SDLButtonPressMode)buttonPressMode {
    NSObject *obj = [parameters sdl_objectForName:SDLNameButtonPressMode];
    return (SDLButtonPressMode)obj;
}

- (void)setCustomButtonID:(nullable NSNumber<SDLInt> *)customButtonID {
    [parameters sdl_setObject:customButtonID forName:SDLNameCustomButtonId];
}

- (nullable NSNumber<SDLInt> *)customButtonID {
    return [parameters sdl_objectForName:SDLNameCustomButtonId];
}

@end

NS_ASSUME_NONNULL_END
