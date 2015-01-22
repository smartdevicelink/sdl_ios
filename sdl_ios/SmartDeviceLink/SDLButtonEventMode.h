//  SDLButtonEventMode.h
//
// 

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLEnum.h>

/**
 * Indicates whether the button was depressed or released. A BUTTONUP event will
 * always be preceded by a BUTTONDOWN event.
 *
 * This enum is avaliable since <font color=red><b>SmartDeviceLink 1.0</b></font>
 */
@interface SDLButtonEventMode : SDLEnum {}

/**
 * @abstract Convert String to SDLButtonEventMode
 * @param value NSString
 * @result SDLButtonEventMode (BUTTONUP / BUTTONDOWN)
 */
+(SDLButtonEventMode*) valueOf:(NSString*) value;
/*!
 @abstract Store the enumeration of all possible SDLButtonEventMode
 @result return an array that store all possible SDLButtonEventMode
 */
+(NSMutableArray*) values;

/*!
 @abstract The button was released
 @result return a SDLButtonEventMode with value of <font color=gray><i>BUTTONUP</i></font>
 */
+(SDLButtonEventMode*) BUTTONUP;
/*!
 @abstract The button was depressed
 @result return a SDLButtonEventMode with value of <font color=gray><i>BUTTONDOWN</i></font>
 */
+(SDLButtonEventMode*) BUTTONDOWN;

@end
