//  SDLOnButtonPress.m
//

#import "SDLOnButtonPress.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLOnButtonPress

- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameOnButtonPress]) {
    }
    return self;
}

- (void)setButtonName:(SDLButtonName)buttonName {
    [parameters sdl_setObject:buttonName forName:SDLRPCParameterNameButtonName];
}

- (SDLButtonName)buttonName {
    NSObject *obj = [parameters sdl_objectForName:SDLRPCParameterNameButtonName];
    return (SDLButtonName)obj;
}

- (void)setButtonPressMode:(SDLButtonPressMode)buttonPressMode {
    [parameters sdl_setObject:buttonPressMode forName:SDLRPCParameterNameButtonPressMode];
}

- (SDLButtonPressMode)buttonPressMode {
    NSObject *obj = [parameters sdl_objectForName:SDLRPCParameterNameButtonPressMode];
    return (SDLButtonPressMode)obj;
}

- (void)setCustomButtonID:(nullable NSNumber<SDLInt> *)customButtonID {
    [parameters sdl_setObject:customButtonID forName:SDLRPCParameterNameCustomButtonId];
}

- (nullable NSNumber<SDLInt> *)customButtonID {
    return [parameters sdl_objectForName:SDLRPCParameterNameCustomButtonId];
}

@end

NS_ASSUME_NONNULL_END
