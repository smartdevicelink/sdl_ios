//  SDLSystemContext.h
//
//

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLEnum.h>

/**
 * Indicates whether or not a user-initiated interaction is in progress, and if
 * so, in what mode (i.e. MENU or VR).
 *
 * Avaliable since <font color=red><b> SmartDeviceLink 1.0 </b></font>
 */
@interface SDLSystemContext : SDLEnum {}

/**
 * Convert String to SDLSystemContext
 * @param value String
 * @return SDLSystemContext
 */
+(SDLSystemContext*) valueOf:(NSString*) value;
/*!
 @abstract Store the enumeration of all possible SDLSystemContext
 @result return an array that store all possible SDLSystemContext
 */
+(NSMutableArray*) values;

/**
 * @abstract No user interaction (user-initiated or app-initiated) is in progress.
 * @result SDLSystemContext object of value <font color=gray><i> MAIN </i></font>
 * @since <font color=red><b> SmartDeviceLink 1.0 </b></font>
 */
+(SDLSystemContext*) MAIN;
/**
 * @abstract VR-oriented, user-initiated or app-initiated interaction is in-progress.
 * @result SDLSystemContext object of value <font color=gray><i> VRSESSION </i></font>
 * @since <font color=red><b> SmartDeviceLink 1.0 </b></font>
 */
+(SDLSystemContext*) VRSESSION;
/**
 * @abstract Menu-oriented, user-initiated or app-initiated interaction is
 * in-progress.
 * @result SDLSystemContext object of value <font color=gray><i> MENU </i></font>
 * @since <font color=red><b> SmartDeviceLink 1.0 </b></font>
 */
+(SDLSystemContext*) MENU;
/**
 * @abstract The app's display HMI is currently being obscured by either a system or
 * other app's overlay.
 * @result SDLSystemContext object of value <font color=gray><i> HMI_OBSCURED </i></font>
 * @since <font color=red><b> SmartDeviceLink 2.0 </b></font>
 */
+(SDLSystemContext*) HMI_OBSCURED;
/**
 * @abstract Broadcast only to whichever app has an alert currently being displayed.
 * @result SDLSystemContext object of value <font color=gray><i> ALERT </i></font>
 * @since <font color=red><b> SmartDeviceLink 2.0 </b></font>
 */
+(SDLSystemContext*) ALERT;

@end
