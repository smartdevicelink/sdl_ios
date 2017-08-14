//  SDLButtonName.h
//


#import "SDLEnum.h"

/**
 * Defines logical buttons which, on a given SDL unit, would correspond to
 * either physical or soft (touchscreen) buttons. These logical buttons present
 * a standard functional abstraction which the developer can rely upon,
 * independent of the SDL unit. For example, the developer can rely upon the OK
 * button having the same meaning to the user across SDL platforms.
 *
 * The preset buttons (0-9) can typically be interpreted by the application as
 * corresponding to some user-configured choices, though the application is free
 * to interpret these button presses as it sees fit.
 *
 * The application can discover which buttons a given SDL unit implements by
 * interrogating the ButtonCapabilities parameter of the
 * RegisterAppInterface response.
 *
 * @since SDL 1.0
 */
typedef SDLEnum SDLButtonName SDL_SWIFT_ENUM;

/**
 * @abstract Represents the button usually labeled "OK". A typical use of this button is for the user to press it to make a selection.
 */
extern SDLButtonName const SDLButtonNameOk;

/**
 * @abstract Represents the seek-left button. A typical use of this button is for the user to scroll to the left through menu choices one menu item per press.
 */
extern SDLButtonName const SDLButtonNameSeekLeft;

/**
 * @abstract Represents the seek-right button. A typical use of this button is for the user to scroll to the right through menu choices one menu item per press.
 */
extern SDLButtonName const SDLButtonNameSeekRight;

/**
 * @abstract Represents a turn of the tuner knob in the clockwise direction one tick.
 */
extern SDLButtonName const SDLButtonNameTuneUp;

/**
 * @abstract Represents a turn of the tuner knob in the counter-clockwise direction one tick.
 */
extern SDLButtonName const SDLButtonNameTuneDown;

/**
 * @abstract Represents the preset 0 button.
 */
extern SDLButtonName const SDLButtonNamePreset0;

/**
 * @abstract Represents the preset 1 button.
 */
extern SDLButtonName const SDLButtonNamePreset1;

/**
 * @abstract Represents the preset 2 button.
 */
extern SDLButtonName const SDLButtonNamePreset2;

/**
 * @abstract Represents the preset 3 button.
 */
extern SDLButtonName const SDLButtonNamePreset3;

/**
 * @abstract Represents the preset 4 button.
 */
extern SDLButtonName const SDLButtonNamePreset4;

/**
 * @abstract Represents the preset 5 button.
 */
extern SDLButtonName const SDLButtonNamePreset5;

/**
 * @abstract Represents the preset 6 button.
 */
extern SDLButtonName const SDLButtonNamePreset6;

/**
 * @abstract Represents the preset 7 button.
 */
extern SDLButtonName const SDLButtonNamePreset7;

/**
 * @abstract Represents the preset 8 button.
 */
extern SDLButtonName const SDLButtonNamePreset8;

/**
 * @abstract Represents the preset 9 button.
 */
extern SDLButtonName const SDLButtonNamePreset9;

extern SDLButtonName const SDLButtonNameCustomButton;

/**
 * @abstract Represents the SEARCH button.
 *
 */
extern SDLButtonName const SDLButtonNameSearch;


#pragma mark - Climate Buttons

/**
 * @abstract Represents AC max button *
 */
extern SDLButtonName const SDLButtonNameAcMax;


/**
 * @abstract Represents AC button *
 */
extern SDLButtonName const SDLButtonNameAc;


/**
 * @abstract Represents a Recirculate button
 */
extern SDLButtonName const SDLButtonNameRecirculate;

/**
 * @abstract Represents a Fan up button
 */
extern SDLButtonName const SDLButtonNameFanUp;

/**
 * @abstract Represents a fan down button
 */
extern SDLButtonName const SDLButtonNameFanDown;

/**
 * @abstract Represents a temperature up button
 */
extern SDLButtonName const SDLButtonNameTempUp;

/**
 * @abstract Represents a temperature down button
 */
extern SDLButtonName const SDLButtonNameTempDown;

/**
 * @abstract Represents a Defrost max button.
 *
 */
extern SDLButtonName const SDLButtonNameDefrostMax;

/**
 * @abstract Represents a Defrost button.
 *
 */
extern SDLButtonName const SDLButtonNameDefrost;

/**
 * @abstract Represents a Defrost rear button.
 *
 */
extern SDLButtonName const SDLButtonNameDefrostRear;

/**
 * @abstract Represents a Upper Vent button.
 *
 */
extern SDLButtonName const SDLButtonNameUpperVent;

/**
 * @abstract Represents a Lower vent button.
 *
 */
extern SDLButtonName const SDLButtonNameLowerVent;

#pragma mark - Radio Buttons
/**
 * @abstract Represents a volume up button.
 */
extern SDLButtonName const SDLButtonNameVolumeUp;

/**
 * @abstract Represents a volume down button.
 *
 */
extern SDLButtonName const SDLButtonNameVolumeDown;

/**
 * @abstract Represents a Eject Button.
 *
 */
extern SDLButtonName const SDLButtonNameEject;

/**
 * @abstract Represents a Source button.
 *
 */
extern SDLButtonName const SDLButtonNameSource;

/**
 * @abstract Represents a SHUFFLE button.
 *
 */
extern SDLButtonName const SDLButtonNameShuffle;

/**
 * @abstract Represents a Repeat button *
 */
extern SDLButtonName const SDLButtonNameRepeat;
