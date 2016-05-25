//  SDLOnButtonPress.m
//

#import "SDLOnButtonPress.h"

#import "SDLButtonName.h"
#import "SDLButtonPressMode.h"
#import "SDLNames.h"


@implementation SDLOnButtonPress

- (instancetype)init {
    if (self = [super initWithName:NAMES_OnButtonPress]) {
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

- (void)setButtonPressMode:(SDLButtonPressMode *)buttonPressMode {
    if (buttonPressMode != nil) {
        [parameters setObject:buttonPressMode forKey:NAMES_buttonPressMode];
    } else {
        [parameters removeObjectForKey:NAMES_buttonPressMode];
    }
}

- (SDLButtonPressMode *)buttonPressMode {
    NSObject *obj = [parameters objectForKey:NAMES_buttonPressMode];
    if (obj == nil || [obj isKindOfClass:SDLButtonPressMode.class]) {
        return (SDLButtonPressMode *)obj;
    } else {
        return [SDLButtonPressMode valueOf:(NSString *)obj];
    }
}

- (void)setCustomButtonID:(NSNumber *)customButtonID {
    if (customButtonID != nil) {
        [parameters setObject:customButtonID forKey:NAMES_customButtonID];
    } else {
        [parameters removeObjectForKey:NAMES_customButtonID];
    }
}

- (NSNumber *)customButtonID {
    return [parameters objectForKey:NAMES_customButtonID];
}

@end
