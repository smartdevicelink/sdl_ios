//  SDLPermissionItem.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLPermissionItem.h>

#import <SmartDeviceLink/SDLNames.h>

@implementation SDLPermissionItem

-(id) init {
    if (self = [super init]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

-(void) setRpcName:(NSString*) rpcName {
    [store setOrRemoveObject:rpcName forKey:NAMES_rpcName];
}

-(NSString*) rpcName {
    return [store objectForKey:NAMES_rpcName];
}

-(void) setHmiPermissions:(SDLHMIPermissions*) hmiPermissions {
    [store setOrRemoveObject:hmiPermissions forKey:NAMES_hmiPermissions];
}

-(SDLHMIPermissions*) hmiPermissions {
    NSObject* obj = [store objectForKey:NAMES_hmiPermissions];
    if ([obj isKindOfClass:SDLHMIPermissions.class]) {
        return (SDLHMIPermissions*)obj;
    } else {
        return [[SDLHMIPermissions alloc] initWithDictionary:(NSMutableDictionary*)obj];
    }
}

-(void) setParameterPermissions:(SDLParameterPermissions*) parameterPermissions {
    [store setOrRemoveObject:parameterPermissions forKey:NAMES_parameterPermissions];
}

-(SDLParameterPermissions*) parameterPermissions {
    NSObject* obj = [store objectForKey:NAMES_parameterPermissions];
    if ([obj isKindOfClass:SDLParameterPermissions.class]) {
        return (SDLParameterPermissions*)obj;
    } else {
        return [[SDLParameterPermissions alloc] initWithDictionary:(NSMutableDictionary*)obj];
    }
}

@end
