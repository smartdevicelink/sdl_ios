//  SDLOnPermissionsChange.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLOnPermissionsChange.h>

#import <SmartDeviceLink/SDLNames.h>
#import <SmartDeviceLink/SDLPermissionItem.h>

@implementation SDLOnPermissionsChange

-(id) init {
    if (self = [super initWithName:NAMES_OnPermissionsChange]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

-(void) setPermissionItem:(NSMutableArray*) permissionItem {
    if (permissionItem != nil) {
        [parameters setObject:permissionItem forKey:NAMES_permissionItem];
    } else {
        [parameters removeObjectForKey:NAMES_permissionItem];
    }
}

-(NSMutableArray*) permissionItem {
    NSMutableArray* array = [parameters objectForKey:NAMES_permissionItem];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLPermissionItem.class]) {
        return array;
    } else {
        NSMutableArray* newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSDictionary* dict in array) {
            [newList addObject:[[SDLPermissionItem alloc] initWithDictionary:(NSMutableDictionary*)dict]];
        }
        return newList;
    }
}

@end
