//  SDLVehicleDataNotificationStatus.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.


#import "SDLEnum.h"

@interface SDLVehicleDataNotificationStatus : SDLEnum {}

+(SDLVehicleDataNotificationStatus*) valueOf:(NSString*) value;
+(NSMutableArray*) values;

+(SDLVehicleDataNotificationStatus*) NOT_SUPPORTED;
+(SDLVehicleDataNotificationStatus*) NORMAL;
+(SDLVehicleDataNotificationStatus*) ACTIVE;
+(SDLVehicleDataNotificationStatus*) NOT_USED;

@end
