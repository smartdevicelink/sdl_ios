//  SDLPermissionItem.h
//  SyncProxy
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <AppLink/SDLRPCMessage.h>

#import <AppLink/SDLHMIPermissions.h>
#import <AppLink/SDLParameterPermissions.h>

@interface SDLPermissionItem : SDLRPCStruct {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) NSString* rpcName;
@property(strong) SDLHMIPermissions* hmiPermissions;
@property(strong) SDLParameterPermissions* parameterPermissions;

@end
