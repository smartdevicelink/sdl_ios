//  SDLMaintenanceModeStatus.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.


#import "SDLEnum.h"

@interface SDLMaintenanceModeStatus : SDLEnum {}

+(SDLMaintenanceModeStatus*) valueOf:(NSString*) value;
+(NSMutableArray*) values;

+(SDLMaintenanceModeStatus*) NORMAL;
+(SDLMaintenanceModeStatus*) NEAR;
+(SDLMaintenanceModeStatus*) ACTIVE;
+(SDLMaintenanceModeStatus*) FEATURE_NOT_PRESENT;

@end
