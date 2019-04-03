//  SDLUnsubscribeButton.m
//


#import "SDLUnsubscribeButton.h"

#import "NSMutableDictionary+Store.h"
#import "SDLButtonName.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLUnsubscribeButton

- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameUnsubscribeButton]) {
    }
    return self;
}

- (instancetype)initWithButtonName:(SDLButtonName)buttonName {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.buttonName = buttonName;

    return self;
}

- (void)setButtonName:(SDLButtonName)buttonName {
    [parameters sdl_setObject:buttonName forName:SDLRPCParameterNameButtonName];
}

- (SDLButtonName)buttonName {
    NSError *error = nil;
    return [parameters sdl_enumForName:SDLRPCParameterNameButtonName error:&error];
}

@end

NS_ASSUME_NONNULL_END
