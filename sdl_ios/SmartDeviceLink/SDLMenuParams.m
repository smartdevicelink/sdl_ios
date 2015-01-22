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
    [store setOrRemoveObject:parentID forKey:NAMES_parentID];
}

-(NSNumber*) parentID {
    return [store objectForKey:NAMES_parentID];
}

-(void) setPosition:(NSNumber*) position {
    [store setOrRemoveObject:position forKey:NAMES_position];
}

-(NSNumber*) position {
    return [store objectForKey:NAMES_position];
}

-(void) setMenuName:(NSString*) menuName {
    [store setOrRemoveObject:menuName forKey:NAMES_menuName];
}

-(NSString*) menuName {
    return [store objectForKey:NAMES_menuName];
}

@end
