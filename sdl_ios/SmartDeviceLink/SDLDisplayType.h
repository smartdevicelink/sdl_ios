//  SDLDisplayType.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLEnum.h>

/**
 * Identifies the various display types used by SYNC. See AppLink TDK and Head Unit Guide for further information regarding the displays.
 *
 * This enum is avaliable since <font color=red><b>AppLink 1.0</b></font>
 */
@interface SDLDisplayType : SDLEnum {}

/**
 * Convert String to SDLDisplayType
 * @param value String
 * @return SDLDisplayType
 */
+(SDLDisplayType*) valueOf:(NSString*) value;
/*!
 @abstract Store the enumeration of all possible SDLDisplayType
 @result return an array that store all possible SDLDisplayType
 */
+(NSMutableArray*) values;

/**
 * @abstract This display type provides a 2-line x 20 character "dot matrix" display.
 * @result return SDLDisplayType with value of <font color=gray><i> CID </i></font>
 */
+(SDLDisplayType*) CID;
+(SDLDisplayType*) TYPE2;
+(SDLDisplayType*) TYPE5;
/**
 * @abstract This display type provides an 8 inch touchscreen display.
 * @result return SDLDisplayType with value of <font color=gray><i> NGN </i></font>
 */
+(SDLDisplayType*) NGN;
+(SDLDisplayType*) GEN2_8_DMA;
+(SDLDisplayType*) GEN2_6_DMA;
+(SDLDisplayType*) MFD3;
+(SDLDisplayType*) MFD4;
+(SDLDisplayType*) MFD5;
+(SDLDisplayType*) GEN3_8_INCH;

@end
