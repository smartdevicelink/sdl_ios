//  SDLDriverDistractionState.h
//
//  

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLEnum.h>

/**
 * Enumeration that describes possible states of driver distraction.
 *
 * This enum is avaliable since <font color=red><b> SmartDeviceLink 1.0 </b></font>
 */
@interface SDLDriverDistractionState : SDLEnum {}

/**
 * Convert String to SDLDisplayType
 * @param value String
 * @return SDLDisplayType
 */
+(SDLDriverDistractionState*) valueOf:(NSString*) value;
/*!
 @abstract Store the enumeration of all possible SDLDriverDistractionState
 @result return an array that store all possible SDLDriverDistractionState
 */
+(NSMutableArray*) values;

/**
 * @abstract Driver distraction rules are in effect.
 * @result return a SDLDriverDistractionState with value of <font color=gray><i> DD_ON </i></font>
 */
+(SDLDriverDistractionState*) DD_ON;
/**
 * @abstract Driver distraction rules are NOT in effect.
 * @result return a SDLDriverDistractionState with value of <font color=gray><i> DD_OFF </i></font>
 */
+(SDLDriverDistractionState*) DD_OFF;

@end
