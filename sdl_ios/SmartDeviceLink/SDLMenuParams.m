//  SDLMenuParams.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLMenuParams.h>

#import <SmartDeviceLink/SDLNames.h>

@implementation SDLMenuParams

-(id) init {
    if (self = [super init]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

-(void) setParentID:(NSNumber*) parentID {
    if (parentID != nil) {
        [store setObject:parentID forKey:NAMES_parentID];
    } else {
        [store removeObjectForKey:NAMES_parentID];
    }
}

-(NSNumber*) parentID {
    return [store objectForKey:NAMES_parentID];
}

-(void) setPosition:(NSNumber*) position {
    if (position != nil) {
        [store setObject:position forKey:NAMES_position];
    } else {
        [store removeObjectForKey:NAMES_position];
    }
}

-(NSNumber*) position {
    return [store objectForKey:NAMES_position];
}

-(void) setMenuName:(NSString*) menuName {
    if (menuName != nil) {
        [store setObject:menuName forKey:NAMES_menuName];
    } else {
        [store removeObjectForKey:NAMES_menuName];
    }
}

-(NSString*) menuName {
    return [store objectForKey:NAMES_menuName];
}

@end
