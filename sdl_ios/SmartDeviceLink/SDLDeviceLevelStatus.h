//  SDLDeviceLevelStatus.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLEnum.h>

/**
 * Reflects the reported battery status of the connected device, if reported.
 *
 * This enum is avaliable since <font color=red><b>AppLink 2.0</b></font>
 */
@interface SDLDeviceLevelStatus : SDLEnum {}

/**
 * Convert String to DeviceLevelStatus
 * @param value String
 * @return DeviceLevelStatus
 */
+(SDLDeviceLevelStatus*) valueOf:(NSString*) value;
/*!
 @abstract Store the enumeration of all possible SDLDeviceLevelStatus
 @result return an array that store all possible SDLDeviceLevelStatus
 */
+(NSMutableArray*) values;

/**
 * @abstract Device Level Status is : <font color=green>Zero level bars</font>
 * @result return a SDLDeviceLevelStatus with value of <font color=gray><i>ZERO_LEVEL_BARS</i></font>
 */
+(SDLDeviceLevelStatus*) ZERO_LEVEL_BARS;
/**
 * @abstract Device Level Status is : <font color=green>One level bars</font>
 * @result return a SDLDeviceLevelStatus with value of <font color=gray><i>ZERO_LEVEL_BARS</i></font>
 */
+(SDLDeviceLevelStatus*) ONE_LEVEL_BARS;
/**
 * @abstract Device Level Status is : <font color=green>Two level bars</font>
 * @result return a SDLDeviceLevelStatus with value of <font color=gray><i>ZERO_LEVEL_BARS</i></font>
 */
+(SDLDeviceLevelStatus*) TWO_LEVEL_BARS;
/**
 * @abstract Device Level Status is : <font color=green>Three level bars</font>
 * @result return a SDLDeviceLevelStatus with value of <font color=gray><i>ZERO_LEVEL_BARS</i></font>
 */
+(SDLDeviceLevelStatus*) THREE_LEVEL_BARS;
/**
 * @abstract Device Level Status is : <font color=green>Four level bars</font>
 * @result return a SDLDeviceLevelStatus with value of <font color=gray><i>ZERO_LEVEL_BARS</i></font>
 */
+(SDLDeviceLevelStatus*) FOUR_LEVEL_BARS;
/**
 * @abstract Device Level Status is :<font color=green>Not provided</font>
 * @result return a SDLDeviceLevelStatus with value of <font color=gray><i>ZERO_LEVEL_BARS</i></font>
 */
+(SDLDeviceLevelStatus*) NOT_PROVIDED;

@end
