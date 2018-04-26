//  SDLOnButtonEvent.h
//

#import "SDLRPCNotification.h"

#import "SDLButtonName.h"
#import "SDLButtonEventMode.h"

/**
 Notifies application that user has depressed or released a button to which
 the application has subscribed.

 Further information about button events and button-presses can be found at SDLSubscribeButton.

 HMI Status Requirements:

 HMILevel:

 * The application will receive <i>SDLOnButtonEvent</i> notifications for all subscribed buttons when HMILevel is FULL.

 * The application will receive <i>SDLOnButtonEvent</i> notifications for subscribed media buttons when HMILevel is LIMITED.

 * Media buttons include SEEKLEFT, SEEKRIGHT, TUNEUP, TUNEDOWN, and PRESET_0-PRESET_9.

 * The application will not receive <i>SDLOnButtonEvent</i> notification when HMILevel is BACKGROUND.
 
 AudioStreamingState:
   * Any

 SystemContext:

 * MAIN, VR. In MENU, only PRESET buttons.

 * In VR, pressing any subscribable button will cancel VR.

 @see SDLSubscribeButton

 @since SDL 1.0
 */

NS_ASSUME_NONNULL_BEGIN

@interface SDLOnButtonEvent : SDLRPCNotification

/**
 * The name of the button
 */
@property (strong, nonatomic) SDLButtonName buttonName;

/**
 * Indicates whether this is an UP or DOWN event
 */
@property (strong, nonatomic) SDLButtonEventMode buttonEventMode;

/**
 * If ButtonName is "CUSTOM_BUTTON", this references the integer ID passed by a custom button. (e.g. softButton ID)
 *
 * @since SDL 2.0
 *
 * Optional, Integer, 0 - 65536
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *customButtonID;

@end

NS_ASSUME_NONNULL_END
