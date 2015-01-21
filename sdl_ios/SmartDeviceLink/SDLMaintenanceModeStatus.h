//  SDLMaintenanceModeStatus.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLEnum.h>

/**
 *
 * The SDLMaintenanceModeStatus class.
 */
@interface SDLMaintenanceModeStatus : SDLEnum {}

/*!
 @abstract Maintenance Mode Status
 @param value NSString
 @result return SDLMaintenanceModeStatus
 */
+(SDLMaintenanceModeStatus*) valueOf:(NSString*) value;
/*!
 @abstract declare an array that store all possible Maintenance Mode Status inside
 @result return the array
 */
+(NSMutableArray*) values;

/*!
 @abstract Maintenance Mode Status : Normal
 @result return the object with value of <font color=gray><i> NORMAL </i></font>
 */
+(SDLMaintenanceModeStatus*) NORMAL;
/*!
 @abstract Maintenance Mode Status : Near
 @result return the object with value of <font color=gray><i> NEAR </i></font>
 */
+(SDLMaintenanceModeStatus*) NEAR;
/*!
 @abstract Maintenance Mode Status : Active
 @result return the object with value of <font color=gray><i> ACTIVE </i></font>
 */
+(SDLMaintenanceModeStatus*) ACTIVE;
/*!
 @abstract Maintenance Mode Status : Feature not present
 @result return the object with value of <font color=gray><i> FEATURE_NOT_PRESENT </i></font>
 */
+(SDLMaintenanceModeStatus*) FEATURE_NOT_PRESENT;

@end
