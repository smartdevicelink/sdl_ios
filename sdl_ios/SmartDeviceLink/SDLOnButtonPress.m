//  SDLOnButtonPress.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLOnButtonPress.h>

#import <SmartDeviceLink/SDLNames.h>

@implementation SDLOnButtonPress

-(id) init {
    if (self = [super initWithName:NAMES_OnButtonPress]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

- (void)setButtonName:(SDLButtonName *)buttonName {
    [parameters setOrRemoveObject:buttonName forKey:NAMES_buttonName];
}

-(SDLButtonName*) buttonName {
    NSObject* obj = [parameters objectForKey:NAMES_buttonName];
    if ([obj isKindOfClass:SDLButtonName.class]) {
        return (SDLButtonName*)obj;
    } else {
        return [SDLButtonName valueOf:(NSString*)obj];
    }
}

- (void)setButtonPressMode:(SDLButtonPressMode *)buttonPressMode {
    [parameters setOrRemoveObject:buttonPressMode forKey:NAMES_buttonPressMode];
}

-(SDLButtonPressMode*) buttonPressMode {
    NSObject* obj = [parameters objectForKey:NAMES_buttonPressMode];
    if ([obj isKindOfClass:SDLButtonPressMode.class]) {
        return (SDLButtonPressMode*)obj;
    } else {
        return [SDLButtonPressMode valueOf:(NSString*)obj];
    }
}

- (void)setCustomButtonID:(NSNumber *)customButtonID {
    [parameters setOrRemoveObject:customButtonID forKey:NAMES_customButtonID];
}

-(NSNumber*) customButtonID {
    return [parameters objectForKey:NAMES_customButtonID];
}

@end
