//  SDLOnButtonPress.m
//

#import "SDLOnButtonPress.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLOnButtonPress

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameOnButtonPress]) {
    }
    return self;
}
#pragma clang diagnostic pop

- (instancetype)initWithButtonName:(SDLButtonName)buttonName buttonPressMode:(SDLButtonPressMode)buttonPressMode {
    self = [self init];
    if (!self) {
        return nil;
    }
    self.buttonName = buttonName;
    self.buttonPressMode = buttonPressMode;
    return self;
}

- (instancetype)initWithButtonName:(SDLButtonName)buttonName buttonPressMode:(SDLButtonPressMode)buttonPressMode customButtonID:(nullable NSNumber<SDLUInt> *)customButtonID {
    self = [self initWithButtonName:buttonName buttonPressMode:buttonPressMode];
    if (!self) {
        return nil;
    }
    self.customButtonID = customButtonID;
    return self;
}

- (void)setButtonName:(SDLButtonName)buttonName {
    [self.parameters sdl_setObject:buttonName forName:SDLRPCParameterNameButtonName];
}

- (SDLButtonName)buttonName {
    NSError *error = nil;
    return [self.parameters sdl_enumForName:SDLRPCParameterNameButtonName error:&error];
}

- (void)setButtonPressMode:(SDLButtonPressMode)buttonPressMode {
    [self.parameters sdl_setObject:buttonPressMode forName:SDLRPCParameterNameButtonPressMode];
}

- (SDLButtonPressMode)buttonPressMode {
    NSError *error = nil;
    return [self.parameters sdl_enumForName:SDLRPCParameterNameButtonPressMode error:&error];
}

- (void)setCustomButtonID:(nullable NSNumber<SDLInt> *)customButtonID {
    [self.parameters sdl_setObject:customButtonID forName:SDLRPCParameterNameCustomButtonId];
}

- (nullable NSNumber<SDLInt> *)customButtonID {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameCustomButtonId ofClass:NSNumber.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
