//  SDLOnKeyboardInput.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLOnKeyboardInput.h>

#import <SmartDeviceLink/SDLNames.h>

@implementation SDLOnKeyboardInput

-(id) init {
    if (self = [super initWithName:NAMES_OnKeyboardInput]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

- (void)setEvent:(SDLKeyboardEvent *)event {
    [parameters setOrRemoveObject:event forKey:NAMES_event];
}

-(SDLKeyboardEvent*) event {
    NSObject* obj = [parameters objectForKey:NAMES_event];
    if ([obj isKindOfClass:SDLKeyboardEvent.class]) {
        return (SDLKeyboardEvent*)obj;
    } else {
        return [SDLKeyboardEvent valueOf:(NSString*)obj];
    }
}

- (void)setData:(NSString *)data {
    [parameters setOrRemoveObject:data forKey:NAMES_data];
}

-(NSString*) data {
    return [parameters objectForKey:NAMES_data];
}

@end
