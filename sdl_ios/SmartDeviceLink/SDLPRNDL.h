//  SDLPRNDL.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLEnum.h>

/**
 * The selected gear.
 *
 * Avaliable since <font color=red><b> AppLink 2.0 </b></font>
 */
@interface SDLPRNDL : SDLEnum {}

/*!
 @abstract get SDLPRNDL according value string
 @param value NSString
 @result SDLPRNDL object
 */
+(SDLPRNDL*) valueOf:(NSString*) value;
/*!
 @abstract declare an array to store all possible SDLPRNDL values
 @result return the array
 */
+(NSMutableArray*) values;

/**
 * @abstract Parking
 * @result return SDLPRNDL : <font color=gray><i> PARK </i></font>
 */
+(SDLPRNDL*) PARK;
/**
 * @abstract Reverse gear
 * @result return SDLPRNDL : <font color=gray><i> REVERSE </i></font>
 */
+(SDLPRNDL*) REVERSE;
/**
 * @abstract No gear
 * @result return SDLPRNDL : <font color=gray><i> NEUTRAL </i></font>
 */
+(SDLPRNDL*) NEUTRAL;
+(SDLPRNDL*) DRIVE;
/**
 * @abstract Drive Sport mode
 * @result return SDLPRNDL : <font color=gray><i> SPORT </i></font>
 */
+(SDLPRNDL*) SPORT;
/**
 * @abstract 1st gear hold
 * @result return SDLPRNDL : <font color=gray><i> LOWGEAR </i></font>
 */
+(SDLPRNDL*) LOWGEAR;
/**
 * @abstract First gear
 * @result return SDLPRNDL : <font color=gray><i> FIRST </i></font>
 */
+(SDLPRNDL*) FIRST;
/**
 * @abstract Second gear
 * @result return SDLPRNDL : <font color=gray><i> SECOND </i></font>
 */
+(SDLPRNDL*) SECOND;
/**
 * @abstract Third gear
 * @result return SDLPRNDL : <font color=gray><i> THIRD </i></font>
 */
+(SDLPRNDL*) THIRD;
/**
 * @abstract Fourth gear
 * @result return SDLPRNDL : <font color=gray><i> FOURTH </i></font>
 */
+(SDLPRNDL*) FOURTH;
/**
 * @abstract Fifth gear
 * @result return SDLPRNDL : <font color=gray><i> FIFTH </i></font>
 */
+(SDLPRNDL*) FIFTH;
/**
 * @abstract Sixth gear
 * @result return SDLPRNDL : <font color=gray><i> SIXTH </i></font>
 */
+(SDLPRNDL*) SIXTH;
/**
 * @abstract Seventh gear
 * @result return SDLPRNDL : <font color=gray><i> SEVENTH </i></font>
 */
+(SDLPRNDL*) SEVENTH;
/**
 * @abstract Eighth gear
 * @result return SDLPRNDL : <font color=gray><i> EIGHTH </i></font>
 */
+(SDLPRNDL*) EIGHTH;
/**
 * @abstract Unknown
 * @result return SDLPRNDL : <font color=gray><i> UNKNOWN </i></font>
 */
+(SDLPRNDL*) UNKNOWN;
/**
 * @abstract Fault
 * @result return SDLPRNDL : <font color=gray><i> FAULT </i></font>
 */
+(SDLPRNDL*) FAULT;

@end
