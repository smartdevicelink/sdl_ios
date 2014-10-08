//  SDLPermissionItem.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCMessage.h>

#import <SmartDeviceLink/SDLHMIPermissions.h>
#import <SmartDeviceLink/SDLParameterPermissions.h>

@interface SDLPermissionItem : SDLRPCStruct {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) NSString* rpcName;
@property(strong) SDLHMIPermissions* hmiPermissions;
@property(strong) SDLParameterPermissions* parameterPermissions;

@end
