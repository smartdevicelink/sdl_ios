//  SDLPermissionItem.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.


#import "SDLRPCMessage.h"

#import "SDLHMIPermissions.h"
#import "SDLParameterPermissions.h"

@interface SDLPermissionItem : SDLRPCStruct {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) NSString* rpcName;
@property(strong) SDLHMIPermissions* hmiPermissions;
@property(strong) SDLParameterPermissions* parameterPermissions;

@end
