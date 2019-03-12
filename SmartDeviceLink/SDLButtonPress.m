//
//  SDLButtonPress.m
//

#import "SDLButtonPress.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"
#import "NSMutableDictionary+Store.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLButtonPress

- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameButtonPress]) {
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
    [parameters sdl_setObject:moduleType forName:SDLRPCParameterNameModuleType];
}

- (SDLModuleType)moduleType {
    return [parameters sdl_objectForName:SDLRPCParameterNameModuleType];
}

- (void)setButtonName:(SDLButtonName)buttonName {
    [parameters sdl_setObject:buttonName forName:SDLRPCParameterNameButtonName];
}

- (SDLButtonName)buttonName {
    return [parameters sdl_objectForName:SDLRPCParameterNameButtonName];
}

- (void)setButtonPressMode:(SDLButtonPressMode)buttonPressMode {
    [parameters sdl_setObject:buttonPressMode forName:SDLRPCParameterNameButtonPressMode];
}

- (SDLButtonPressMode)buttonPressMode {
    return [parameters sdl_objectForName:SDLRPCParameterNameButtonPressMode];
}

@end
NS_ASSUME_NONNULL_END
