//  SDLOnButtonEvent.m
//

#import "SDLOnButtonEvent.h"

#import "SDLButtonEventMode.h"
#import "SDLButtonName.h"
#import "SDLNames.h"

@implementation SDLOnButtonEvent

- (instancetype)init {
    if (self = [super initWithName:SDLNameOnButtonEvent]) {
    }
    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary *)dict {
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

- (void)setButtonEventMode:(SDLButtonEventMode *)buttonEventMode {
    if (buttonEventMode != nil) {
        [parameters setObject:buttonEventMode forKey:SDLNameButtonEventMode];
    } else {
        [parameters removeObjectForKey:SDLNameButtonEventMode];
    }
}

- (SDLButtonEventMode *)buttonEventMode {
    NSObject *obj = [parameters objectForKey:SDLNameButtonEventMode];
    if (obj == nil || [obj isKindOfClass:SDLButtonEventMode.class]) {
        return (SDLButtonEventMode *)obj;
    } else {
        return [SDLButtonEventMode valueOf:(NSString *)obj];
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
