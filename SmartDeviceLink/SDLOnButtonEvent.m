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
    NSError *error;
    return [parameters sdl_enumForName:SDLNameButtonName error:&error];
}

- (void)setButtonEventMode:(SDLButtonEventMode)buttonEventMode {
    [parameters sdl_setObject:buttonEventMode forName:SDLNameButtonEventMode];
}

- (SDLButtonEventMode)buttonEventMode {
    NSError *error;
    return [parameters sdl_enumForName:SDLNameButtonEventMode error:&error];
}

- (void)setCustomButtonID:(nullable NSNumber<SDLInt> *)customButtonID {
    [parameters sdl_setObject:customButtonID forName:SDLNameCustomButtonId];
}

- (nullable NSNumber<SDLInt> *)customButtonID {
    return [parameters sdl_objectForName:SDLNameCustomButtonId ofClass:NSNumber.class];
}

@end

NS_ASSUME_NONNULL_END
