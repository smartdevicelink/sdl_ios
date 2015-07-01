//  SDLOnButtonPress.h
//

#import "SDLRPCNotification.h"

@class SDLButtonName;
@class SDLButtonPressMode;


/**
 * Notifies application of button press events for buttons to which the
 * application is subscribed. SDL supports two button press events defined as
 * follows:
 *
 * <ul>
 * <li>SHORT - Occurs when a button is depressed, then released within two
 * seconds. The event is considered to occur immediately after the button is
 * released.</li>
 * <li>LONG - Occurs when a button is depressed and held for two seconds or
 * more. The event is considered to occur immediately after the two second
 * threshold has been crossed, before the button is released</li>
 * </ul>
 * <b>HMI Status Requirements:</b>
 * <ul>
 * HMILevel:
 * <ul>
 * <li>The application will receive OnButtonPress notifications for all
 * subscribed buttons when HMILevel is FULL.</li>
 * <li>The application will receive OnButtonPress notifications for subscribed
 * media buttons when HMILevel is LIMITED.</li>
 * <li>Media buttons include SEEKLEFT, SEEKRIGHT, TUNEUP, TUNEDOWN, and
 * PRESET_0-PRESET_9.</li>
 * <li>The application will not receive OnButtonPress notification when HMILevel
 * is BACKGROUND or NONE.</li>
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
 *
 * @see SDLSubscribeButton
 * @see SDLUnsubscribeButton
 *
 * @since SDL 1.0
 */
@interface SDLOnButtonPress : SDLRPCNotification {
}

/**
 * Constructs a newly allocated SDLOnButtonPress object
 */
- (instancetype)init;

/**
 * Constructs a newly allocated SDLOnButtonPress object indicated by the dictionary parameter
 *
 * @param dict The dictionary to use
 */
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

/**
 * @abstract the button's name
 *
 * @see SDLButtonName
 *
 * Required
 */
@property (strong) SDLButtonName *buttonName;

/**
 * @abstract Indicates whether this is a LONG or SHORT button press event
 *
 * @see SDLButtonPressMode
 *
 * Required
 */
@property (strong) SDLButtonPressMode *buttonPressMode;

/**
 * @abstract If ButtonName is "CUSTOM_BUTTON", this references the integer ID passed by a custom button. (e.g. softButton ID)
 *
 * @since SDL 2.0
 *
 * Optional, Integer 0 - 65536
 */
@property (strong) NSNumber *customButtonID;

@end
