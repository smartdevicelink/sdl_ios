//  SDLPermissionStatus.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLEnum.h>

/**
 * Enumeration that describes possible permission states of a policy table entry.
 *
 * Avaliable since <font color=red><b> AppLink 2.0 </b></font>
 */
@interface SDLPermissionStatus : SDLEnum {}

/*!
 @abstract SDLPermissionStatus
 @param value NSString
 @result return a SDLPermissionStatus object
 */
+(SDLPermissionStatus*) valueOf:(NSString*) value;
/*!
 @abstract declare an array to store all possible SDLPermissionStatus values
 @result return the array
 */
+(NSMutableArray*) values;


/*!
 @abstract permission : allowed
 @result return permission status : <font color=gray><i> ALLOWED </i></font>
 */
+(SDLPermissionStatus*) ALLOWED;
/*!
 @abstract permission : disallowed
 @result return permission status : <font color=gray><i> DISALLOWED </i></font>
 */
+(SDLPermissionStatus*) DISALLOWED;
/*!
 @abstract permission : user disallowed
 @result return permission status : <font color=gray><i> USER_DISALLOWED </i></font>
 */
+(SDLPermissionStatus*) USER_DISALLOWED;
/*!
 @abstract permission : user consent pending
 @result return permission status : <font color=gray><i> USER_CONSENT_PENDING </i></font>
 */
+(SDLPermissionStatus*) USER_CONSENT_PENDING;

@end
