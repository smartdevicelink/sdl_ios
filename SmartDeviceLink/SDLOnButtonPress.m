//  SDLOnButtonPress.m
//

#import "SDLOnButtonPress.h"

#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLOnButtonPress

- (instancetype)init {
    if (self = [super initWithName:SDLNameOnButtonPress]) {
    }
    return self;
}

- (void)setButtonName:(SDLButtonName)buttonName {
    if (buttonName != nil) {
        [parameters setObject:buttonName forKey:SDLNameButtonName];
    } else {
        [parameters removeObjectForKey:SDLNameButtonName];
    }
}

- (SDLButtonName)buttonName {
    NSObject *obj = [parameters objectForKey:SDLNameButtonName];
    return (SDLButtonName)obj;
}

- (void)setButtonPressMode:(SDLButtonPressMode)buttonPressMode {
    if (buttonPressMode != nil) {
        [parameters setObject:buttonPressMode forKey:SDLNameButtonPressMode];
    } else {
        [parameters removeObjectForKey:SDLNameButtonPressMode];
    }
}

- (SDLButtonPressMode)buttonPressMode {
    NSObject *obj = [parameters objectForKey:SDLNameButtonPressMode];
    return (SDLButtonPressMode)obj;
}

- (void)setCustomButtonID:(nullable NSNumber<SDLInt> *)customButtonID {
    if (customButtonID != nil) {
        [parameters setObject:customButtonID forKey:SDLNameCustomButtonId];
    } else {
        [parameters removeObjectForKey:SDLNameCustomButtonId];
    }
}

- (nullable NSNumber<SDLInt> *)customButtonID {
    return [parameters objectForKey:SDLNameCustomButtonId];
}

@end

NS_ASSUME_NONNULL_END
