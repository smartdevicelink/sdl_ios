//  SDLOnTouchEvent.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLOnTouchEvent.h>

#import <SmartDeviceLink/SDLNames.h>
#import <SmartDeviceLink/SDLTouchEvent.h>

@implementation SDLOnTouchEvent

-(id) init {
    if (self = [super initWithName:NAMES_OnTouchEvent]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

- (void)setType:(SDLTouchType *)type {
    [parameters setOrRemoveObject:type forKey:NAMES_type];
}

-(SDLTouchType*) type {
    NSObject* obj = [parameters objectForKey:NAMES_type];
    if ([obj isKindOfClass:SDLTouchType.class]) {
        return (SDLTouchType*)obj;
    } else {
        return [SDLTouchType valueOf:(NSString*)obj];
    }
}

- (void)setEvent:(NSMutableArray *)event {
    [parameters setOrRemoveObject:event forKey:NAMES_event];
}

-(NSMutableArray*) event {
    NSMutableArray* array = [parameters objectForKey:NAMES_event];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLTouchEvent.class]) {
        return array;
    } else {
        NSMutableArray* newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSDictionary* dict in array) {
            [newList addObject:[[SDLTouchEvent alloc] initWithDictionary:(NSMutableDictionary*)dict]];
        }
        return newList;
    }
}

@end
