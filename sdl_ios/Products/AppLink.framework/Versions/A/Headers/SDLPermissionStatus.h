//  SDLPermissionStatus.h
//  SyncProxy
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <AppLink/SDLEnum.h>

@interface SDLPermissionStatus : SDLEnum {}

+(SDLPermissionStatus*) valueOf:(NSString*) value;
+(NSMutableArray*) values;

+(SDLPermissionStatus*) ALLOWED;
+(SDLPermissionStatus*) DISALLOWED;
+(SDLPermissionStatus*) USER_DISALLOWED;
+(SDLPermissionStatus*) USER_CONSENT_PENDING;

@end
