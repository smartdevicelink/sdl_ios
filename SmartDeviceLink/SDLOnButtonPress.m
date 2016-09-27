//  SDLOnButtonPress.m
//

#import "SDLOnButtonPress.h"

#import "SDLButtonName.h"
#import "SDLButtonPressMode.h"
#import "SDLNames.h"

@implementation SDLOnButtonPress

- (instancetype)init {
    if (self = [super initWithName:SDLNameOnButtonPress]) {
    }
    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary<NSString *, id> *)dict {
    if (self = [super initWithDictionary:dict]) {
    }
    return self;
}

- (void)setButtonName:(SDLButtonName *)buttonName {
    if (buttonName != nil) {
        [parameters setObject:buttonName forKey:SDLNameButtonName];
    } else {
        [parameters removeObjectForKey:SDLNameButtonName];
    }
}

- (SDLButtonName *)buttonName {
    NSObject *obj = [parameters objectForKey:SDLNameButtonName];
    if (obj == nil || [obj isKindOfClass:SDLButtonName.class]) {
        return (SDLButtonName *)obj;
    } else {
        return [SDLButtonName valueOf:(NSString *)obj];
    }
}

- (void)setButtonPressMode:(SDLButtonPressMode *)buttonPressMode {
    if (buttonPressMode != nil) {
        [parameters setObject:buttonPressMode forKey:SDLNameButtonPressMode];
    } else {
        [parameters removeObjectForKey:SDLNameButtonPressMode];
    }
}

- (SDLButtonPressMode *)buttonPressMode {
    NSObject *obj = [parameters objectForKey:SDLNameButtonPressMode];
    if (obj == nil || [obj isKindOfClass:SDLButtonPressMode.class]) {
        return (SDLButtonPressMode *)obj;
    } else {
        return [SDLButtonPressMode valueOf:(NSString *)obj];
    }
}

- (void)setCustomButtonID:(NSNumber *)customButtonID {
    if (customButtonID != nil) {
        [parameters setObject:customButtonID forKey:SDLNameCustomButtonId];
    } else {
        [parameters removeObjectForKey:SDLNameCustomButtonId];
    }
}

- (NSNumber *)customButtonID {
    return [parameters objectForKey:SDLNameCustomButtonId];
}

@end
