//  SDLButtonName.h
//


#import "SDLEnum.h"

/**
 * Defines logical buttons which, on a given SDL unit, would correspond to either physical or soft (touchscreen) buttons. These logical buttons present a standard functional abstraction which the developer can rely upon, independent of the SDL unit. For example, the developer can rely upon the OK button having the same meaning to the user across SDL platforms.

 * The preset buttons (0-9) can typically be interpreted by the application as corresponding to some user-configured choices, though the application is free to interpret these button presses as it sees fit.
 *
 * The application can discover which buttons a given SDL unit implements by interrogating the ButtonCapabilities parameter of the RegisterAppInterface response.
 *
 * @since SDL 1.0
 */
typedef SDLEnum SDLButtonName SDL_SWIFT_ENUM;

/**
 * Represents the button usually labeled "OK". A typical use of this button is for the user to press it to make a selection.
 */
extern SDLButtonName const SDLButtonNameOk;

/**
 * Represents the seek-left button. A typical use of this button is for the user to scroll to the left through menu choices one menu item per press.
 */
extern SDLButtonName const SDLButtonNameSeekLeft;

/**
 * Represents the seek-right button. A typical use of this button is for the user to scroll to the right through menu choices one menu item per press.
 */
extern SDLButtonName const SDLButtonNameSeekRight;

/**
 * Represents a turn of the tuner knob in the clockwise direction one tick.
 */
extern SDLButtonName const SDLButtonNameTuneUp;

/**
 * Represents a turn of the tuner knob in the counter-clockwise direction one tick.
 */
extern SDLButtonName const SDLButtonNameTuneDown;

/**
 * Represents the preset 0 button.
 */
extern SDLButtonName const SDLButtonNamePreset0;

/**
 * Represents the preset 1 button.
 */
extern SDLButtonName const SDLButtonNamePreset1;

/**
 * Represents the preset 2 button.
 */
extern SDLButtonName const SDLButtonNamePreset2;

/**
 * Represents the preset 3 button.
 */
extern SDLButtonName const SDLButtonNamePreset3;

/**
 * Represents the preset 4 button.
 */
extern SDLButtonName const SDLButtonNamePreset4;

/**
 * Represents the preset 5 button.
 */
extern SDLButtonName const SDLButtonNamePreset5;

/**
 * Represents the preset 6 button.
 */
extern SDLButtonName const SDLButtonNamePreset6;

/**
 * Represents the preset 7 button.
 */
extern SDLButtonName const SDLButtonNamePreset7;

/**
 * Represents the preset 8 button.
 */
extern SDLButtonName const SDLButtonNamePreset8;

/**
 * Represents the preset 9 button.
 */
extern SDLButtonName const SDLButtonNamePreset9;

/**
 * Represents the Custom button.
 *
 */
extern SDLButtonName const SDLButtonNameCustomButton;

/**
 * Represents the SEARCH button.
 *
 */
extern SDLButtonName const SDLButtonNameSearch;

#pragma mark - Climate Buttons

/**
 * Represents AC max button *
 */
extern SDLButtonName const SDLButtonNameACMax;

/**
 * Represents AC button *
 */
extern SDLButtonName const SDLButtonNameAC;

/**
 * Represents a Recirculate button
 */
extern SDLButtonName const SDLButtonNameRecirculate;

/**
 * Represents a Fan up button
 */
extern SDLButtonName const SDLButtonNameFanUp;

/**
 * Represents a fan down button
 */
extern SDLButtonName const SDLButtonNameFanDown;

/**
 * Represents a temperature up button
 */
extern SDLButtonName const SDLButtonNameTempUp;

/**
 * Represents a temperature down button
 */
extern SDLButtonName const SDLButtonNameTempDown;

/**
 * Represents a Defrost max button.
 *
 */
extern SDLButtonName const SDLButtonNameDefrostMax;

/**
 * Represents a Defrost button.
 *
 */
extern SDLButtonName const SDLButtonNameDefrost;

/**
 * Represents a Defrost rear button.
 *
 */
extern SDLButtonName const SDLButtonNameDefrostRear;

/**
 * Represents a Upper Vent button.
 *
 */
extern SDLButtonName const SDLButtonNameUpperVent;

/**
 * Represents a Lower vent button.
 *
 */
extern SDLButtonName const SDLButtonNameLowerVent;

#pragma mark - Radio Buttons
/**
 * Represents a volume up button.
 */
extern SDLButtonName const SDLButtonNameVolumeUp;

/**
 * Represents a volume down button.
 *
 */
extern SDLButtonName const SDLButtonNameVolumeDown;

/**
 * Represents a Eject Button.
 *
 */
extern SDLButtonName const SDLButtonNameEject;

/**
 * Represents a Source button.
 *
 */
extern SDLButtonName const SDLButtonNameSource;

/**
 * Represents a SHUFFLE button.
 *
 */
extern SDLButtonName const SDLButtonNameShuffle;

/**
 * Represents a Repeat button.
 */
extern SDLButtonName const SDLButtonNameRepeat;
