//  SDLUnsubscribeButton.m
//


#import "SDLUnsubscribeButton.h"

#import "SDLButtonName.h"
#import "SDLNames.h"


@implementation SDLUnsubscribeButton

- (instancetype)init {
    if (self = [super initWithName:NAMES_UnsubscribeButton]) {
    }
    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
    }
    return self;
}

- (instancetype)initWithButtonName:(SDLButtonName *)buttonName {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.buttonName = buttonName;

    return self;
}

- (void)setButtonName:(SDLButtonName *)buttonName {
    if (buttonName != nil) {
        [parameters setObject:buttonName forKey:NAMES_buttonName];
    } else {
        [parameters removeObjectForKey:NAMES_buttonName];
    }
}

- (SDLButtonName *)buttonName {
    NSObject *obj = [parameters objectForKey:NAMES_buttonName];
    if (obj == nil || [obj isKindOfClass:SDLButtonName.class]) {
        return (SDLButtonName *)obj;
    } else {
        return [SDLButtonName valueOf:(NSString *)obj];
    }
}

@end
