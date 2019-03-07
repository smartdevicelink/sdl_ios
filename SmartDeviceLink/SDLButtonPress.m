//
//  SDLButtonPress.m
//

#import "SDLButtonPress.h"
#import "SDLNames.h"
#import "NSMutableDictionary+Store.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLButtonPress

- (instancetype)init {
    if (self = [super initWithName:SDLNameButtonPress]) {
    }
    return self;
}

- (instancetype)initWithButtonName:(SDLButtonName) buttonName moduleType:(SDLModuleType) moduleType {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.buttonName = buttonName;
    self.moduleType = moduleType;

    return self;
}

- (void)setModuleType:(SDLModuleType)moduleType {
    [parameters sdl_setObject:moduleType forName:SDLNameModuleType];
}

- (SDLModuleType)moduleType {
    NSError *error;
    return [parameters sdl_enumForName:SDLNameModuleType error:&error];
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

@end
NS_ASSUME_NONNULL_END
