//  SDLDeleteSubMenu.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLDeleteSubMenu.h>

#import <SmartDeviceLink/SDLNames.h>

@implementation SDLDeleteSubMenu

-(id) init {
    if (self = [super initWithName:NAMES_DeleteSubMenu]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

-(void) setMenuID:(NSNumber*) menuID {
    if (menuID != nil) {
        [parameters setObject:menuID forKey:NAMES_menuID];
    } else {
        [parameters removeObjectForKey:NAMES_menuID];
    }
}

-(NSNumber*) menuID {
    return [parameters objectForKey:NAMES_menuID];
}

@end
