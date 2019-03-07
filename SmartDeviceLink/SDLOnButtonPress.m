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
    NSError *error;
    return [parameters sdl_enumForName:SDLNameButtonName error:&error];
}

- (void)setButtonPressMode:(SDLButtonPressMode)buttonPressMode {
    [parameters sdl_setObject:buttonPressMode forName:SDLNameButtonPressMode];
}

- (SDLButtonPressMode)buttonPressMode {
    NSError *error;
    return [parameters sdl_enumForName:SDLNameButtonPressMode error:&error];
}

- (void)setCustomButtonID:(nullable NSNumber<SDLInt> *)customButtonID {
    [parameters sdl_setObject:customButtonID forName:SDLNameCustomButtonId];
}

- (nullable NSNumber<SDLInt> *)customButtonID {
    return [parameters sdl_objectForName:SDLNameCustomButtonId ofClass:NSNumber.class];
}

@end

NS_ASSUME_NONNULL_END
