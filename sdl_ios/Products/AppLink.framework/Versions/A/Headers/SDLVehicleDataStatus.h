//  SDLVehicleDataStatus.h
//  SyncProxy
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <AppLink/SDLEnum.h>

@interface SDLVehicleDataStatus : SDLEnum {}

+(SDLVehicleDataStatus*) valueOf:(NSString*) value;
+(NSMutableArray*) values;

+(SDLVehicleDataStatus*) NO_DATA_EXISTS;
+(SDLVehicleDataStatus*) OFF;
+(SDLVehicleDataStatus*) ON;

@end
