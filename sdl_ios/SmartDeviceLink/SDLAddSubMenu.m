//  SDLAddSubMenu.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLAddSubMenu.h>

#import <SmartDeviceLink/SDLNames.h>

@implementation SDLAddSubMenu

-(id) init {
    if (self = [super initWithName:NAMES_AddSubMenu]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

- (void)setMenuID:(NSNumber *)menuID {
    [parameters setOrRemoveObject:menuID forKey:NAMES_menuID];
}

-(NSNumber*) menuID {
    return [parameters objectForKey:NAMES_menuID];
}

- (void)setPosition:(NSNumber *)position {
    [parameters setOrRemoveObject:position forKey:NAMES_position];
}

-(NSNumber*) position {
    return [parameters objectForKey:NAMES_position];
}

- (void)setMenuName:(NSString *)menuName {
    [parameters setOrRemoveObject:menuName forKey:NAMES_menuName];
}

-(NSString*) menuName {
    return [parameters objectForKey:NAMES_menuName];
}

@end
