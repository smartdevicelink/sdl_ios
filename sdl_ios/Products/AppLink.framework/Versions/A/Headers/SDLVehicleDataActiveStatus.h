//  SDLVehicleDataActiveStatus.h
//  SyncProxy
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <AppLink/SDLEnum.h>

@interface SDLVehicleDataActiveStatus : SDLEnum {}

+(SDLVehicleDataActiveStatus*) valueOf:(NSString*) value;
+(NSMutableArray*) values;

+(SDLVehicleDataActiveStatus*) INACTIVE_NOT_CONFIRMED;
+(SDLVehicleDataActiveStatus*) INACTIVE_CONFIRMED;
+(SDLVehicleDataActiveStatus*) ACTIVE_NOT_CONFIRMED;
+(SDLVehicleDataActiveStatus*) ACTIVE_CONFIRMED;
+(SDLVehicleDataActiveStatus*) FAULT;

@end
