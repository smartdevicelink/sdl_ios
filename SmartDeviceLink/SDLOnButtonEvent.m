//  SDLOnButtonEvent.m
//

#import "SDLOnButtonEvent.h"

#import "SDLNames.h"

@implementation SDLOnButtonEvent

- (instancetype)init {
    if (self = [super initWithName:SDLNameOnButtonEvent]) {
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

- (void)setButtonEventMode:(SDLButtonEventMode)buttonEventMode {
    [self setObject:buttonEventMode forName:SDLNameButtonEventMode];
}

- (SDLButtonEventMode)buttonEventMode {
    NSObject *obj = [parameters objectForKey:SDLNameButtonEventMode];
    return (SDLButtonEventMode)obj;
}

- (void)setCustomButtonID:(NSNumber<SDLInt> *)customButtonID {
    [self setObject:customButtonID forName:SDLNameCustomButtonId];
}

- (NSNumber<SDLInt> *)customButtonID {
    return [parameters objectForKey:SDLNameCustomButtonId];
}

@end
