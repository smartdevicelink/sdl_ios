//  SDLVehicleDataStatus.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLEnum.h>

/**
 * Reflects the status of a binary vehicle data item.
 *
 * Avaliable since <font color=red><b> AppLink 2.0 </b></font>
 */
@interface SDLVehicleDataStatus : SDLEnum {}

/**
 * Convert String to SDLVehicleDataStatus
 * @param value String
 * @return SDLVehicleDataStatus
 */
+(SDLVehicleDataStatus*) valueOf:(NSString*) value;
/*!
 @abstract Store the enumeration of all possible SDLVehicleDataStatus
 @result return an array that store all possible SDLVehicleDataStatus
 */
+(NSMutableArray*) values;

/*!
 @abstract No data avaliable
 @result return SDLVehicleDataStatus : <font color=gray><i> NO_DATA_EXISTS </i></font>
 */
+(SDLVehicleDataStatus*) NO_DATA_EXISTS;
/*!
 @abstract return SDLVehicleDataStatus : <font color=gray><i> OFF </i></font>
 */
+(SDLVehicleDataStatus*) OFF;
/*!
 @abstract return SDLVehicleDataStatus : <font color=gray><i> ON </i></font>
 */
+(SDLVehicleDataStatus*) ON;

@end
