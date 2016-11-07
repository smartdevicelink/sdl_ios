//  SDLOnButtonPress.m
//

#import "SDLOnButtonPress.h"

#import "SDLNames.h"

@implementation SDLOnButtonPress

- (instancetype)init {
    if (self = [super initWithName:SDLNameOnButtonPress]) {
    }
    return self;
}

- (void)setButtonName:(SDLButtonName)buttonName {
    [self setObject:buttonName forName:SDLNameButtonName];
}

- (SDLButtonName)buttonName {
    NSObject *obj = [parameters objectForKey:SDLNameButtonName];
    return (SDLButtonName)obj;
}

- (void)setButtonPressMode:(SDLButtonPressMode)buttonPressMode {
    [self setObject:buttonPressMode forName:SDLNameButtonPressMode];
}

- (SDLButtonPressMode)buttonPressMode {
    NSObject *obj = [parameters objectForKey:SDLNameButtonPressMode];
    return (SDLButtonPressMode)obj;
}

- (void)setCustomButtonID:(NSNumber<SDLInt> *)customButtonID {
    [self setObject:customButtonID forName:SDLNameCustomButtonId];
}

- (NSNumber<SDLInt> *)customButtonID {
    return [parameters objectForKey:SDLNameCustomButtonId];
}

@end
