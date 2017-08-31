//
//  SDLSystemCapabilityType.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 7/10/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDLEnum.h"

/**
 The type of system capability to get more information on
 */
@interface SDLSystemCapabilityType : SDLEnum

/**
 * Convert String to SDLSystemCapabilityType
 * @param value String
 * @return SDLSystemCapabilityType
 */
+ (SDLSystemCapabilityType *)valueOf:(NSString *)value;

/**
 Returns an array of all possible SDLSystemCapabilityType values
 @return an array that store all possible SDLSystemCapabilityType
 */
+ (NSArray *)values;

/**
 @abstract NAVIGATION
 */
+ (SDLSystemCapabilityType *)NAVIGATION;

/**
 @abstract PHONE_CALL
 */
+ (SDLSystemCapabilityType *)PHONE_CALL;

/**
 @abstract VIDEO_STREAMING
 */
+ (SDLSystemCapabilityType *)VIDEO_STREAMING;

@end
