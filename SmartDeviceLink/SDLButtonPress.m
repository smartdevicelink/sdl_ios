//
//  SDLButtonPress.m
//

#import "SDLButtonPress.h"
#import "SDLNames.h"
#import "SDLButtonName.h"
#import "NSMutableDictionary+Store.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLButtonPress

- (instancetype)init {
    if (self = [super initWithName:SDLNameButtonPress]) {
    }
    return self;
}


- (void)setModuleType:(SDLModuleType )moduleType {
    [parameters sdl_setObject:moduleType forName:SDLNameModuleType];
}

- (SDLModuleType )moduleType {
    return [parameters sdl_objectForName:SDLNameModuleType];
}

- (void)setButtonName:(SDLButtonName)buttonName {
    [parameters sdl_setObject:buttonName forName:SDLNameButtonName];
}

- (SDLButtonName)buttonName {
    return [parameters sdl_objectForName:SDLNameButtonName];
}

- (void)setButtonPressMode:(SDLButtonPressMode)buttonPressMode {
    [parameters sdl_setObject:buttonPressMode forName:SDLNameButtonPressMode];
}

- (SDLButtonPressMode)buttonPressMode {
    return [parameters sdl_objectForName:SDLNameButtonPressMode];
}

@end
NS_ASSUME_NONNULL_END
