//  SDLPermissionItem.h
//
//  

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
