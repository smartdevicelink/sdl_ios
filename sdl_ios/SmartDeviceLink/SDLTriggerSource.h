//  SDLTriggerSource.h
//
//  

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLEnum.h>

/**
 * Indicates whether choice/command was selected via VR or via a menu selection
 * (using SEEKRIGHT/SEEKLEFT, TUNEUP, TUNEDOWN and OK buttons)
 *
 * Avaliable since <font color=red><b> SmartDeviceLink 1.0 </b></font>
 *
 */
@interface SDLTriggerSource : SDLEnum {}

/**
 * Convert String to SDLTriggerSource
 * @param value String
 * @return SDLTriggerSource
 */
+(SDLTriggerSource*) valueOf:(NSString*) value;
/*!
 @abstract Store the enumeration of all possible SDLTriggerSource
 @result return an array that store all possible SDLTriggerSource
 */
+(NSMutableArray*) values;

/**
 * @abstract Selection made via menu (i.e. using SEEKRIGHT/SEEKLEFT, TUNEUP, TUNEDOWN
 * and OK buttons)
 * @result return SDLTriggerSource with value of <font color=gray><i> MENU </i></font>
 */
+(SDLTriggerSource*) MENU;
/**
 * @abstract Selection made via VR session
 * @result return SDLTriggerSource with value of <font color=gray><i> VR </i></font>
 */
+(SDLTriggerSource*) VR;
+(SDLTriggerSource*) KEYBOARD;

@end
