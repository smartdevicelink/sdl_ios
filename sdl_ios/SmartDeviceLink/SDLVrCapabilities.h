//  SDLVrCapabilities.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLEnum.h>

/**
 * The VR capabilities of the connected SYNC platform.
 *
 */
@interface SDLVrCapabilities : SDLEnum {}

/**
 * Convert String to SDLVrCapabilities
 * @param value String
 * @return SDLVrCapabilities
 */
+(SDLVrCapabilities*) valueOf:(NSString*) value;
/*!
 @abstract Store the enumeration of all possible SDLVrCapabilities
 @result return an array that store all possible SDLVrCapabilities
 */
+(NSMutableArray*) values;

/**
 * @abstract The SYNC platform is capable of recognizing spoken text in the current
 * language.
 * @result return an SDLVrCapabilities instance pointer with value of <font color=gray><i> TEXT </i></font>
 * @since <font color=red><b> AppLink 1.0 </b></font>
 */
+(SDLVrCapabilities*) TEXT;

@end
