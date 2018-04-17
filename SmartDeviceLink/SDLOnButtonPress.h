//  SDLOnButtonPress.h
//

#import "SDLRPCNotification.h"

#import "SDLButtonName.h"
#import "SDLButtonPressMode.h"

/**
 Notifies application of button press events for buttons to which the application is subscribed. SDL supports two button press events defined as follows:

 SHORT - Occurs when a button is depressed, then released within two seconds. The event is considered to occur immediately after the button is released.

 LONG - Occurs when a button is depressed and held for two seconds or more. The event is considered to occur immediately after the two second threshold has been crossed, before the button is released.

 HMI Status Requirements:

 HMILevel:

 The application will receive OnButtonPress notifications for all subscribed buttons when HMILevel is FULL.

 The application will receive OnButtonPress notifications for subscribed media buttons when HMILevel is LIMITED. Media buttons include SEEKLEFT, SEEKRIGHT, TUNEUP, TUNEDOWN, and PRESET_0-PRESET_9.

 The application will not receive OnButtonPress notification when HMILevel is BACKGROUND or NONE.

 AudioStreamingState: Any

 SystemContext: MAIN, VR. In MENU, only PRESET buttons. In VR, pressing any subscribable button will cancel VR.

 @since SDL 1.0
 */

NS_ASSUME_NONNULL_BEGIN

@interface SDLOnButtonPress : SDLRPCNotification

/**
 * The button's name
 *
 * Required
 */
@property (strong, nonatomic) SDLButtonName buttonName;

/**
 * Indicates whether this is a LONG or SHORT button press event
 *
 * Required
 */
@property (strong, nonatomic) SDLButtonPressMode buttonPressMode;

/**
 * If ButtonName is "CUSTOM_BUTTON", this references the integer ID passed by a custom button. (e.g. softButton ID)
 *
 * @since SDL 2.0
 *
 * Optional, Integer 0 - 65536
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *customButtonID;

@end

NS_ASSUME_NONNULL_END
