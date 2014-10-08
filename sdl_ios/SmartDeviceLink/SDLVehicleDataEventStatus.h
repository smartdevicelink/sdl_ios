//  SDLVehicleDataEventStatus.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLEnum.h>

@interface SDLVehicleDataEventStatus : SDLEnum {}

+(SDLVehicleDataEventStatus*) valueOf:(NSString*) value;
+(NSMutableArray*) values;

+(SDLVehicleDataEventStatus*) NO_EVENT;
+(SDLVehicleDataEventStatus*) _NO;
+(SDLVehicleDataEventStatus*) _YES;
+(SDLVehicleDataEventStatus*) NOT_SUPPORTED;
+(SDLVehicleDataEventStatus*) FAULT;

@end
