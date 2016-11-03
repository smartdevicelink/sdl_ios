//  SDLUnsubscribeButton.m
//


#import "SDLUnsubscribeButton.h"

#import "SDLButtonName.h"
#import "SDLNames.h"

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
