//  SDLUnsubscribeButton.m
//


#import "SDLUnsubscribeButton.h"

#import "NSMutableDictionary+Store.h"
#import "SDLButtonName.h"
#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLUnsubscribeButton

- (instancetype)init {
    if (self = [super initWithName:SDLNameUnsubscribeButton]) {
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
    [parameters sdl_setObject:buttonName forName:SDLNameButtonName];
}

- (SDLButtonName)buttonName {
    return [parameters sdl_objectForName:SDLNameButtonName];
}

@end

NS_ASSUME_NONNULL_END
