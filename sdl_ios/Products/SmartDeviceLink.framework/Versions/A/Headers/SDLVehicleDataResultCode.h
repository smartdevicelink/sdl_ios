//  SDLVehicleDataResultCode.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLEnum.h>

@interface SDLVehicleDataResultCode : SDLEnum {}

+(SDLVehicleDataResultCode*) valueOf:(NSString*) value;
+(NSMutableArray*) values;

+(SDLVehicleDataResultCode*) SUCCESS;
+(SDLVehicleDataResultCode*) TRUNCATED_DATA;
+(SDLVehicleDataResultCode*) DISALLOWED;
+(SDLVehicleDataResultCode*) USER_DISALLOWED;
+(SDLVehicleDataResultCode*) INVALID_ID;
+(SDLVehicleDataResultCode*) VEHICLE_DATA_NOT_AVAILABLE;
+(SDLVehicleDataResultCode*) DATA_ALREADY_SUBSCRIBED;
+(SDLVehicleDataResultCode*) DATA_NOT_SUBSCRIBED;
+(SDLVehicleDataResultCode*) IGNORED;

@end
