//  SDLUnsubscribeButton.m
//


#import "SDLUnsubscribeButton.h"

#import "NSMutableDictionary+Store.h"
#import "SDLButtonName.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLUnsubscribeButton

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameUnsubscribeButton]) {
    }
    return self;
}
#pragma clang diagnostic pop

- (instancetype)initWithButtonName:(SDLButtonName)buttonName {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.buttonName = buttonName;

    return self;
}

- (void)setButtonName:(SDLButtonName)buttonName {
    [self.parameters sdl_setObject:buttonName forName:SDLRPCParameterNameButtonName];
}

- (SDLButtonName)buttonName {
    NSError *error = nil;
    return [self.parameters sdl_enumForName:SDLRPCParameterNameButtonName error:&error];
}

@end

NS_ASSUME_NONNULL_END
