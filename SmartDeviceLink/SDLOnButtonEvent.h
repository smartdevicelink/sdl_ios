//  SDLOnButtonEvent.h
//

#import "SDLRPCNotification.h"

@class SDLButtonName;
@class SDLButtonEventMode;


/**
 * Notifies application that user has depressed or released a button to which
 * the application has subscribed.
 *
 * Further information about button events
 * and button-presses can be found at SDLSubscribeButton.
 * <p>
 * </p>
 * <b>HMI Status Requirements:</b>
 * <ul>
 * HMILevel:
 * <ul>
 * <li>The application will receive <i>SDLOnButtonEvent</i> notifications for all
 * subscribed buttons when HMILevel is FULL.</li>
 * <li>The application will receive <i>SDLOnButtonEvent</i> notifications for subscribed
 * media buttons when HMILevel is LIMITED.</li>
 * <li>Media buttons include SEEKLEFT, SEEKRIGHT, TUNEUP, TUNEDOWN, and
 * PRESET_0-PRESET_9.</li>
 * <li>The application will not receive <i>SDLOnButtonEvent</i> notification when HMILevel
 * is BACKGROUND.</li>
 * </ul>
 * AudioStreamingState:
 * <ul>
 * <li> Any </li>
 * </ul>
 * SystemContext:
 * <ul>
 * <li>MAIN, VR. In MENU, only PRESET buttons. In VR, pressing any subscribable
 * button will cancel VR.</li>
 * </ul>
 * </ul>
 * <p>
 *
 * @see SDLSubscribeButton
 *
 * @since SDL 1.0
 */
@interface SDLOnButtonEvent : SDLRPCNotification {
}

/**
 * Constructs a newly allocated SDLOnButtonEvent object
 */
- (instancetype)init;

/**
 * @abstract Constructs a newly allocated SDLOnButtonEvent object indicated by the dictionary parameter
 *
 * @param dict The dictionary to use
 */
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

/**
 * @abstract The name of the button
 */
@property (strong) SDLButtonName *buttonName;

/**
 * @abstract Indicates whether this is an UP or DOWN event
 */
@property (strong) SDLButtonEventMode *buttonEventMode;

/**
 * @abstract If ButtonName is "CUSTOM_BUTTON", this references the integer ID passed by a custom button. (e.g. softButton ID)
 *
 * @since SDL 2.0
 *
 * Optional, Integer, 0 - 65536
 */
@property (strong) NSNumber *customButtonID;

@end
