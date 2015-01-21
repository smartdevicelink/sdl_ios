//  SDLWiperStatus.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLEnum.h>

/*!
 Wiper Status
 */
@interface SDLWiperStatus : SDLEnum {}

/**
 * Convert String to SDLWiperStatus
 * @param value String
 * @return SDLWiperStatus
 */
+(SDLWiperStatus*) valueOf:(NSString*) value;
/*!
 @abstract Store the enumeration of all possible SDLWiperStatus
 @result return an array that store all possible SDLWiperStatus
 */
+(NSMutableArray*) values;

/*!
 @abstract SDLWiperStatus : <font color=gray><i> OFF </i></font>
 */
+(SDLWiperStatus*) OFF;
/*!
 @abstract SDLWiperStatus : <font color=gray><i> AUTO_OFF </i></font>
 */
+(SDLWiperStatus*) AUTO_OFF;
/*!
 @abstract SDLWiperStatus : <font color=gray><i> OFF_MOVING </i></font>
 */
+(SDLWiperStatus*) OFF_MOVING;
/*!
 @abstract SDLWiperStatus : <font color=gray><i> MAN_INT_OFF </i></font>
 */
+(SDLWiperStatus*) MAN_INT_OFF;
/*!
 @abstract SDLWiperStatus : <font color=gray><i> MAN_INT_ON </i></font>
 */
+(SDLWiperStatus*) MAN_INT_ON;
/*!
 @abstract SDLWiperStatus : <font color=gray><i> MAN_LOW </i></font>
 */
+(SDLWiperStatus*) MAN_LOW;
/*!
 @abstract SDLWiperStatus : <font color=gray><i> MAN_HIGH </i></font>
 */
+(SDLWiperStatus*) MAN_HIGH;
/*!
 @abstract SDLWiperStatus : <font color=gray><i> MAN_FLICK </i></font>
 */
+(SDLWiperStatus*) MAN_FLICK;
/*!
 @abstract SDLWiperStatus : <font color=gray><i> WASH </i></font>
 */
+(SDLWiperStatus*) WASH;
/*!
 @abstract SDLWiperStatus : <font color=gray><i> AUTO_LOW </i></font>
 */
+(SDLWiperStatus*) AUTO_LOW;
/*!
 @abstract SDLWiperStatus : <font color=gray><i> AUTO_HIGH </i></font>
 */
+(SDLWiperStatus*) AUTO_HIGH;
/*!
 @abstract SDLWiperStatus : <font color=gray><i> COURTESYWIPE </i></font>
 */
+(SDLWiperStatus*) COURTESYWIPE;
/*!
 @abstract SDLWiperStatus : <font color=gray><i> AUTO_ADJUST </i></font>
 */
+(SDLWiperStatus*) AUTO_ADJUST;
/*!
 @abstract SDLWiperStatus : <font color=gray><i> STALLED </i></font>
 */
+(SDLWiperStatus*) STALLED;
/*!
 @abstract SDLWiperStatus : <font color=gray><i> NO_DATA_EXISTS </i></font>
 */
+(SDLWiperStatus*) NO_DATA_EXISTS;

@end
