//  SDLSubscribeButton.m
//


#import "SDLSubscribeButton.h"

#import "SDLButtonName.h"
#import "SDLNames.h"

@implementation SDLSubscribeButton

- (instancetype)init {
    if (self = [super initWithName:SDLNameSubscribeButton]) {
    }
    return self;
}

- (instancetype)initWithHandler:(SDLRPCNotificationHandler)handler {
    self = [self init];
    if (!self) {
        return nil;
    }

    _handler = handler;

    return self;
}

- (void)setButtonName:(SDLButtonName)buttonName {
    if (buttonName != nil) {
        [parameters setObject:buttonName forKey:SDLNameButtonName];
    } else {
        [parameters removeObjectForKey:SDLNameButtonName];
    }
}

- (SDLButtonName)buttonName {
    NSObject *obj = [parameters objectForKey:SDLNameButtonName];
    return (SDLButtonName)obj;
}

@end
