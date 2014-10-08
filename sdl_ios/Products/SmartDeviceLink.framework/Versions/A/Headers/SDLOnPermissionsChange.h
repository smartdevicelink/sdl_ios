//  SDLOnPermissionsChange.h
//  SyncProxy
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCNotification.h>

@interface SDLOnPermissionsChange : SDLRPCNotification {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) NSMutableArray* permissionItem;

@end
