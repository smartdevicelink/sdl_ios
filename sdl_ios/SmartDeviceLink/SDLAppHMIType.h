//  SDLAppHMIType.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLEnum.h>

/**
 * Enumeration listing possible app hmi types.
 *
 * This enum is avaliable since <font color=red><b>SmartDeviceLink 2.0</b></font>
 */
@interface SDLAppHMIType : SDLEnum {}

/**
 * @abstract Convert String to AppHMIType
 * @param value NSString
 * @result SDLAppHMIType
 */
+(SDLAppHMIType*) valueOf:(NSString*) value;
/*!
 @abstract Store the enumeration of all possible SDLAppHMIType
 @result return an array that store all possible SDLAppHMIType
 */
+(NSMutableArray*) values;

/**
 * @abstract  The App will have default rights.
 * @result SDLAppHMIType with value <font color=gray><i>DEFAULT</i></font>
 */
+(SDLAppHMIType*) DEFAULT;
/**
 * @abstract  Communication type of App
 * @result SDLAppHMIType with value <font color=gray><i>COMMUNICATION</i></font>
 */
+(SDLAppHMIType*) COMMUNICATION;
/**
 * @abstract  App dealing with Media
 * @result SDLAppHMIType with value <font color=gray><i>MEDIA</i></font>
 */
+(SDLAppHMIType*) MEDIA;
/**
 * @abstract  Messaging App
 * @result SDLAppHMIType with value <font color=gray><i>MESSAGING</i></font>
 */
+(SDLAppHMIType*) MESSAGING;
/**
 * @abstract  Navigation App
 * @result SDLAppHMIType with value <font color=gray><i>NAVIGATION</i></font>
 */
+(SDLAppHMIType*) NAVIGATION;
/**
 * @abstract  Information App
 * @result SDLAppHMIType with value <font color=gray><i>INFORMATION</i></font>
 */
+(SDLAppHMIType*) INFORMATION;
/**
 * @abstract  App dealing with social media
 * @result SDLAppHMIType with value <font color=gray><i>SOCIA</i></font>
 */
+(SDLAppHMIType*) SOCIAL;
/*!
 @abstract  To Be Continued
 */
+(SDLAppHMIType*) BACKGROUND_PROCESS;
/**
 * @abstract  App only for Testing purposes
 * @result SDLAppHMIType with value <font color=gray><i>TESTING</i></font>
 */
+(SDLAppHMIType*) TESTING;
/**
 * @abstract  System App
 * @result SDLAppHMIType with value <font color=gray><i>SYSTEM</i></font>
 */
+(SDLAppHMIType*) SYSTEM;

@end
