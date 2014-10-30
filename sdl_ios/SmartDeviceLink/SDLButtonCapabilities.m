//  SDLButtonCapabilities.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLButtonCapabilities.h>

#import <SmartDeviceLink/SDLNames.h>

@implementation SDLButtonCapabilities

-(id) init {
    if (self = [super init]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

-(void) setName:(SDLButtonName*) name {
    [store setOrRemoveObject:name forKey:NAMES_name];
}

-(SDLButtonName*) name {
    NSObject* obj = [store objectForKey:NAMES_name];
    if ([obj isKindOfClass:SDLButtonName.class]) {
        return (SDLButtonName*)obj;
    } else {
        return [SDLButtonName valueOf:(NSString*)obj];
    }
}

-(void) setShortPressAvailable:(NSNumber*) shortPressAvailable {
    [store setOrRemoveObject:shortPressAvailable forKey:NAMES_shortPressAvailable];
}

-(NSNumber*) shortPressAvailable {
    return [store objectForKey:NAMES_shortPressAvailable];
}

-(void) setLongPressAvailable:(NSNumber*) longPressAvailable {
    [store setOrRemoveObject:longPressAvailable forKey:NAMES_longPressAvailable];
}

-(NSNumber*) longPressAvailable {
    return [store objectForKey:NAMES_longPressAvailable];
}

-(void) setUpDownAvailable:(NSNumber*) upDownAvailable {
    [store setOrRemoveObject:upDownAvailable forKey:NAMES_upDownAvailable];
}

-(NSNumber*) upDownAvailable {
    return [store objectForKey:NAMES_upDownAvailable];
}

@end
