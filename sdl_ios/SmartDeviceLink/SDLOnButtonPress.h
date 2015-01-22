//  SDLOnButtonPress.h
//
//

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCNotification.h>

#import <SmartDeviceLink/SDLButtonName.h>
#import <SmartDeviceLink/SDLButtonPressMode.h>

/**
 * <p>
 * Notifies application of button press events for buttons to which the
 * application is subscribed. SDL supports two button press events defined as
 * follows:
 * </p>
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
 * <p>
 * <b>Parameter List:</b>
 * <table  border="1" rules="all">
 * <tr>
 * <th>Name</th>
 * <th>Type</th>
 * <th>Description</th>
 * <th>Req</th>
 * <th>Notes</th>
 * <th>SmartDeviceLink Ver Available</th>
 * </tr>
 * <tr>
 * <td>buttonName</td>
 * <td>SDLButtonName* </td>
 * <td>Name of the button which triggered this event</td>
 * <td></td>
 * <td></td>
 * <td>SmartDeviceLink 1.0</td>
 * </tr>
 * <tr>
 * <td>buttonPressMode</td>
 * <td>SDLButtonPressMode* </td>
 * <td>Indicates whether this is an SHORT or LONG button press event.</td>
 * <td></td>
 * <td></td>
 * <td>SmartDeviceLink 1.0</td>
 * </tr>
 * <tr>
 * <td>customButtonID</td>
 * <td>NSNumber* </td>
 * <td>If SDLButtonName is “CUSTOM_BUTTON", this references the integer ID passed
 * by a custom button. (e.g. softButton ID)</td>
 * <td>N</td>
 * <td>Minvalue=0 Maxvalue=65536</td>
 * <td>SmartDeviceLink 2.0</td>
 * </tr>
 * </table>
 * </p>
 *
 * Since <b>SmartDeviceLink 1.0</b><br>
 * see SDLSubscribeButton SDLUnsubscribeButton
 */
@interface SDLOnButtonPress : SDLRPCNotification {}

/**
 *Constructs a newly allocated SDLOnButtonPress object
 */
-(id) init;
/**
 * <p>
 * Constructs a newly allocated SDLOnButtonPress object indicated by the
 * NSMutableDictionary parameter
 * </p>
 *
 * @param dict The NSMutableDictionary to use
 */
-(id) initWithDictionary:(NSMutableDictionary*) dict;

/**
 * @abstract the button's name
 * @discussion
 */
@property(strong) SDLButtonName* buttonName;
/**
 * @abstract button press mode whether this is a long or short button press event
 * @discussion
 */
@property(strong) SDLButtonPressMode* buttonPressMode;
@property(strong) NSNumber* customButtonID;

@end
