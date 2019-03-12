//  SDLOnButtonEvent.m
//

#import "SDLOnButtonEvent.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLOnButtonEvent

- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameOnButtonEvent]) {
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

- (void)setButtonEventMode:(SDLButtonEventMode)buttonEventMode {
    [parameters sdl_setObject:buttonEventMode forName:SDLRPCParameterNameButtonEventMode];
}

- (SDLButtonEventMode)buttonEventMode {
    NSObject *obj = [parameters sdl_objectForName:SDLRPCParameterNameButtonEventMode];
    return (SDLButtonEventMode)obj;
}

- (void)setCustomButtonID:(nullable NSNumber<SDLInt> *)customButtonID {
    [parameters sdl_setObject:customButtonID forName:SDLRPCParameterNameCustomButtonId];
}

- (nullable NSNumber<SDLInt> *)customButtonID {
    return [parameters sdl_objectForName:SDLRPCParameterNameCustomButtonId];
}

@end

NS_ASSUME_NONNULL_END
