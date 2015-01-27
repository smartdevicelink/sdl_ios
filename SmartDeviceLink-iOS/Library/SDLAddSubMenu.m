//  SDLAddSubMenu.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import "SDLAddSubMenu.h"

#import "SDLNames.h"

@implementation SDLAddSubMenu

-(id) init {
    if (self = [super initWithName:NAMES_AddSubMenu]) {}
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

-(void) setPosition:(NSNumber*) position {
    if (position != nil) {
        [parameters setObject:position forKey:NAMES_position];
    } else {
        [parameters removeObjectForKey:NAMES_position];
    }
}

-(NSNumber*) position {
    return [parameters objectForKey:NAMES_position];
}

-(void) setMenuName:(NSString*) menuName {
    if (menuName != nil) {
        [parameters setObject:menuName forKey:NAMES_menuName];
    } else {
        [parameters removeObjectForKey:NAMES_menuName];
    }
}

-(NSString*) menuName {
    return [parameters objectForKey:NAMES_menuName];
}

@end
