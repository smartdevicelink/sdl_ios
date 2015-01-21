//  SDLSubscribeButton.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLSubscribeButton.h>

#import <SmartDeviceLink/SDLNames.h>

@implementation SDLSubscribeButton

-(id) init {
    if (self = [super initWithName:NAMES_SubscribeButton]) {}
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

@end
