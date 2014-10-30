//  SDLTurn.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLTurn.h>

#import <SmartDeviceLink/SDLNames.h>

@implementation SDLTurn

-(id) init {
    if (self = [super init]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

-(void) setNavigationText:(NSString*) navigationText {
    [store setOrRemoveObject:navigationText forKey:NAMES_navigationText];
}

-(NSString*) navigationText {
    return [store objectForKey:NAMES_navigationText];
}

-(void) setTurnIcon:(SDLImage*) turnIcon {
    [store setOrRemoveObject:turnIcon forKey:NAMES_turnIcon];
}

-(SDLImage*) turnIcon {
    NSObject* obj = [store objectForKey:NAMES_turnIcon];
    if ([obj isKindOfClass:SDLImage.class]) {
        return (SDLImage*)obj;
    } else {
        return [[SDLImage alloc] initWithDictionary:(NSMutableDictionary*)obj];
    }
}

@end
