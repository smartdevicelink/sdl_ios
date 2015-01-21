//  SDLHmiZoneCapabilities.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLEnum.h>

/**
 * Specifies HMI Zones in the vehicle.
 *
 */
@interface SDLHmiZoneCapabilities : SDLEnum {}

/*!
 @abstract return SDLHMIZoneCapabilities (FRONT / BACK)
 @param value NSString
 @result return SDLHMIZoneCapabilities
 */
+(SDLHmiZoneCapabilities*) valueOf:(NSString*) value;
/*!
 @abstract store all possible SDLHMIZoneCapabilities values
 @result return an array with all possible SDLHMIZoneCapabilities values inside
 */
+(NSMutableArray*) values;

/**
 * @abstract Indicates HMI available for front seat passengers.
 * @result return a SDLHMIZoneCapabilities with value of <font color=gray><i> FRONT </i></font>
 * @since <font color=red><b> AppLink 1.0 </b></font>
 */
+(SDLHmiZoneCapabilities*) FRONT;
/**
 * @abstract Indicates HMI available for rear seat passengers.
 * @result return a SDLHMIZoneCapabilities with value of <font color=gray><i> BACK </i></font>
 * @since <font color=red><b> AppLink 1.0 </b></font>
 */
+(SDLHmiZoneCapabilities*) BACK;

@end
