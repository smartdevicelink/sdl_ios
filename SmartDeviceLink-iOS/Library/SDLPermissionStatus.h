//  SDLPermissionStatus.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.


#import "SDLEnum.h"

@interface SDLPermissionStatus : SDLEnum {}

+(SDLPermissionStatus*) valueOf:(NSString*) value;
+(NSMutableArray*) values;

+(SDLPermissionStatus*) ALLOWED;
+(SDLPermissionStatus*) DISALLOWED;
+(SDLPermissionStatus*) USER_DISALLOWED;
+(SDLPermissionStatus*) USER_CONSENT_PENDING;

@end
