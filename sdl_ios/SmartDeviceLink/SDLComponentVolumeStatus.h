//  SDLComponentVolumeStatus.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLEnum.h>

/**
 * The volume status of a vehicle component.
 *
 * This enum is avaliable since <font color=red><b>AppLink 2.0</b></font>
 */
@interface SDLComponentVolumeStatus : SDLEnum {}

/**
 * @abstract Convert String to SDLComponentVolumeStatus
 * @param value NSString
 * @result SDLComponentVolumeStatus
 *
 */
+(SDLComponentVolumeStatus*) valueOf:(NSString*) value;
/*!
 @abstract Store the enumeration of all possible SDLComponentVolumeStatus
 @result return an array that store all possible SDLComponentVolumeStatus
 */
+(NSMutableArray*) values;

/*!
 @abstract Unknown SDLComponentVolumeStatus
 @result return a SDLComponentVolumeStatus with the value of <font color=gray><i>UNKNOWN</i></font>
 */
+(SDLComponentVolumeStatus*) UNKNOWN;
/*!
 @abstract Normal SDLComponentVolumeStatus
 @result return a SDLComponentVolumeStatus with the value of <font color=gray><i>NORMAL</i></font>
 */
+(SDLComponentVolumeStatus*) NORMAL;
/*!
 @abstract Low SDLComponentVolumeStatus
 @result return a SDLComponentVolumeStatus with the value of <font color=gray><i>LOW</i></font>
 */
+(SDLComponentVolumeStatus*) LOW;
/*!
 @abstract Fault SDLComponentVolumeStatus
 @result return a SDLComponentVolumeStatus with the value of <font color=gray><i>FAULT</i></font>
 */
+(SDLComponentVolumeStatus*) FAULT;
/*!
 @abstract Alert SDLComponentVolumeStatus
 @result return a SDLComponentVolumeStatus with the value of <font color=gray><i>ALERT</i></font>
 */
+(SDLComponentVolumeStatus*) ALERT;
/*!
 @abstract Not supported SDLComponentVolumeStatus
 @result return a SDLComponentVolumeStatus with the value of <font color=gray><i>NOT_SUPPORTED</i></font>
 */
+(SDLComponentVolumeStatus*) NOT_SUPPORTED;

@end
