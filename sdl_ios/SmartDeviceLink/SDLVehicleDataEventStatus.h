//  SDLVehicleDataEventStatus.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLEnum.h>

/**
 * Reflects the status of a vehicle data event; e.g. a seat belt event status.
 *
 * Avaliable since <font color=red><b> AppLink 2.0 </b></font>
 */
@interface SDLVehicleDataEventStatus : SDLEnum {}

/**
 * Convert String to SDLVehicleDataEventStatus
 * @param value String
 * @return SDLVehicleDataEventStatus
 */
+(SDLVehicleDataEventStatus*) valueOf:(NSString*) value;
/*!
 @abstract Store the enumeration of all possible SDLVehicleDataEventStatus
 @result return an array that store all possible SDLVehicleDataEventStatus
 */
+(NSMutableArray*) values;

/*!
 @abstract No event avaliable
 @result return the SDLVehicleDataEventStatus instance with value of <font color=gray><i> NO_EVENT </i></font>
 */
+(SDLVehicleDataEventStatus*) NO_EVENT;
/*!
 @abstract return the SDLVehicleDataEventStatus instance with value of <font color=gray><i> NO </i></font>
 */
+(SDLVehicleDataEventStatus*) _NO;
/*!
 @abstract return the SDLVehicleDataEventStatus instance with value of <font color=gray><i> YES </i></font>
 */
+(SDLVehicleDataEventStatus*) _YES;
/*!
 @abstract Vehicle data event is not support
 @result return the SDLVehicleDataEventStatus instance with value of <font color=gray><i> NOT_SUPPORTED </i></font>
 */
+(SDLVehicleDataEventStatus*) NOT_SUPPORTED;
/*!
 @abstract return the SDLVehicleDataEventStatus instance with value of <font color=gray><i> FAULT </i></font>
 */
+(SDLVehicleDataEventStatus*) FAULT;

@end
