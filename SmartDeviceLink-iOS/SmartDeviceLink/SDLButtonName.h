//  SDLButtonName.h
//



#import "SDLEnum.h"

/**
 * <p>
 * Defines logical buttons which, on a given SDL unit, would correspond to
 * either physical or soft (touchscreen) buttons. These logical buttons present
 * a standard functional abstraction which the developer can rely upon,
 * independent of the SDL unit. For example, the developer can rely upon the OK
 * button having the same meaning to the user across SDL platforms.
 * </p>
 * <p>
 * The preset buttons (0-9) can typically be interpreted by the application as
 * corresponding to some user-configured choices, though the application is free
 * to interpret these button presses as it sees fit.
 * </p>
 * <p>
 * The application can discover which buttons a given SDL unit implements by
 * interrogating the ButtonCapabilities parameter of the
 * RegisterAppInterface response.
 * </p>
 *
 * This enum is avaliable since <font color=red><b>SmartDeviceLink 1.0</b></font>
 */
@interface SDLButtonName : SDLEnum {}

/**
 * @abstract Convert String to SDLButtonName
 * @param value NSString
 * @result SDLButtonName
 */
+(SDLButtonName*) valueOf:(NSString*) value;

/*!
 @abstract Store the enumeration of all possible SDLButtonName
 @result return an array that store all possible SDLButtonName
 */
+(NSArray*) values;

/**
 * @abstract Represents the button usually labeled "OK". A typical use of this button
 * is for the user to press it to make a selection.
 * @result return a SDLButtonName with the value of <font color=gray><i>OK</i></font>
 * @since <font color=red><b>SmartDeviceLink 1.0</b></font>
 */
+(SDLButtonName*) OK;

/**
 * @abstract Represents the seek-left button. A typical use of this button is for the
 * user to scroll to the left through menu choices one menu item per press.
 * @result return a SDLButtonName with the value of <font color=gray><i>SEEKLEFT</i></font>
 * @since <font color=red><b>SmartDeviceLink 1.0</b></font>
 */
+(SDLButtonName*) SEEKLEFT;

/**
 * @abstract Represents the seek-right button. A typical use of this button is for the
 * user to scroll to the right through menu choices one menu item per press.
 * @result return a SDLButtonName with the value of <font color=gray><i>SEEKRIGHT</i></font>
 * @since <font color=red><b>SmartDeviceLink 1.0</b></font>
 */
+(SDLButtonName*) SEEKRIGHT;

/**
 * @abstract Represents a turn of the tuner knob in the clockwise direction one tick.
 * @result return a SDLButtonName with the value of <font color=gray><i>TUNEUP</i></font>
 * @since <font color=red><b>SmartDeviceLink 1.0</b></font>
 */
+(SDLButtonName*) TUNEUP;

/**
 * @abstract Represents a turn of the tuner knob in the counter-clockwise direction
 * one tick.
 * @result return a SDLButtonName with the value of <font color=gray><i>TUNEDOWN</i></font>
 * @since <font color=red><b>SmartDeviceLink 1.0</b></font>
 */
+(SDLButtonName*) TUNEDOWN;

/**
 * @abstract Represents the preset 0 button.
 * @result return a SDLButtonName with the value of <font color=gray><i>PRESET_0</i></font>
 * @since <font color=red><b>SmartDeviceLink 1.0</b></font>
 */
+(SDLButtonName*) PRESET_0;

/**
 * @abstract Represents the preset 1 button.
 * @result return a SDLButtonName with the value of <font color=gray><i>PRESET_1</i></font>
 * @since <font color=red><b>SmartDeviceLink 1.0</b></font>
 */
+(SDLButtonName*) PRESET_1;

/**
 * @abstract Represents the preset 2 button.
 * @result return a SDLButtonName with the value of <font color=gray><i>PRESET_2</i></font>
 * @since <font color=red><b>SmartDeviceLink 1.0</b></font>
 */
+(SDLButtonName*) PRESET_2;

/**
 * @abstract Represents the preset 3 button.
 * @result return a SDLButtonName with the value of <font color=gray><i>PRESET_3</i></font>
 * @since <font color=red><b>SmartDeviceLink 1.0</b></font>
 */
+(SDLButtonName*) PRESET_3;

/**
 * @abstract Represents the preset 4 button.
 * @result return a SDLButtonName with the value of <font color=gray><i>PRESET_4</i></font>
 * @since <font color=red><b>SmartDeviceLink 1.0</b></font>
 */
+(SDLButtonName*) PRESET_4;

/**
 * @abstract Represents the preset 5 button.
 * @result return a SDLButtonName with the value of <font color=gray><i>PRESET_5</i></font>
 * @since <font color=red><b>SmartDeviceLink 1.0</b></font>
 */
+(SDLButtonName*) PRESET_5;

/**
 * @abstract Represents the preset 6 button.
 * @result return a SDLButtonName with the value of <font color=gray><i>PRESET_6</i></font>
 * @since <font color=red><b>SmartDeviceLink 1.0</b></font>
 */
+(SDLButtonName*) PRESET_6;

/**
 * @abstract Represents the preset 7 button.
 * @result return a SDLButtonName with the value of <font color=gray><i>PRESET_7</i></font>
 * @since <font color=red><b>SmartDeviceLink 1.0</b></font>
 */
+(SDLButtonName*) PRESET_7;

/**
 * @abstract Represents the preset 8 button.
 * @result return a SDLButtonName with the value of <font color=gray><i>PRESET_8</i></font>
 * @since <font color=red><b>SmartDeviceLink 1.0</b></font>
 */
+(SDLButtonName*) PRESET_8;

/**
 * @abstract Represents the preset 9 button.
 * @result return a SDLButtonName with the value of <font color=gray><i>PRESET_9</i></font>
 * @since <font color=red><b>SmartDeviceLink 1.0</b></font>
 */
+(SDLButtonName*) PRESET_9;
+(SDLButtonName*) CUSTOM_BUTTON;
+(SDLButtonName*) SEARCH;

@end
