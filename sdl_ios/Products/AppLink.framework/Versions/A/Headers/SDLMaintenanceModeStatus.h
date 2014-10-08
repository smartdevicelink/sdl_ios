//  SDLMaintenanceModeStatus.h
//  SyncProxy
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <AppLink/SDLEnum.h>

@interface SDLMaintenanceModeStatus : SDLEnum {}

+(SDLMaintenanceModeStatus*) valueOf:(NSString*) value;
+(NSMutableArray*) values;

+(SDLMaintenanceModeStatus*) NORMAL;
+(SDLMaintenanceModeStatus*) NEAR;
+(SDLMaintenanceModeStatus*) ACTIVE;
+(SDLMaintenanceModeStatus*) FEATURE_NOT_PRESENT;

@end
