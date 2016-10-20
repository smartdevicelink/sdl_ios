//  SDLTextFieldName.h
//


#import "SDLEnum.h"

/**
 * Names of the text fields that can appear on a SDL display.
 *
 * @since SDL 1.0
 */
typedef SDLEnum SDLTextFieldName SDL_SWIFT_ENUM;

/**
 * @abstract The first line of the first set of main fields of the persistent display. Applies to SDLShow.
 */
extern SDLTextFieldName const SDLTextFieldNameMainField1;

/**
 * @abstract The second line of the first set of main fields of the persistent display. Applies to SDLShow.
 *
 * @since SDL 2.0
 */
extern SDLTextFieldName const SDLTextFieldNameMainField2;

/**
 * @abstract The first line of the second set of main fields of the persistent display. Applies to SDLShow.
 *
 * @since SDL 2.0
 */
extern SDLTextFieldName const SDLTextFieldNameMainField3;

/**
 * @abstract The second line of the second set of main fields of the persistent display. Applies to SDLShow.
 */
extern SDLTextFieldName const SDLTextFieldNameMainField4;

/**
 * @abstract The status bar on the NGN display. Applies to SDLShow.
 */
extern SDLTextFieldName const SDLTextFieldNameStatusBar;

/**
 * @abstract Text value for MediaClock field. Must be properly formatted according to MediaClockFormat. Applies to SDLShow.
 *
 * @discussion This field is commonly used to show elapsed or remaining time in an audio track or audio capture.
 */
extern SDLTextFieldName const SDLTextFieldNameMediaClock;

/**
 * @abstract The track field of NGN type ACMs. This field is only available for media applications on a NGN display. Applies to SDLShow.
 *
 * @discussion This field is commonly used to show the current track number
 */
extern SDLTextFieldName const SDLTextFieldNameMediaTrack;

/**
 * @abstract The first line of the alert text field. Applies to SDLAlert.
 */
extern SDLTextFieldName const SDLTextFieldNameAlertText1;

/**
 * @abstract The second line of the alert text field. Applies to SDLAlert.
 *
 * @since SDL 2.0
 */
extern SDLTextFieldName const SDLTextFieldNameAlertText2;

/**
 * @abstract The third line of the alert text field. Applies to SDLAlert.
 *
 * @since SDL 2.0
 */
extern SDLTextFieldName const SDLTextFieldNameAlertText3;

/**
 * @abstract Long form body of text that can include newlines and tabs. Applies to SDLScrollableMessage.
 *
 * @since SDL 2.0
 */
extern SDLTextFieldName const SDLTextFieldNameScrollableMessageBody;

/**
 * @abstract First line suggestion for a user response (in the case of VR enabled interaction).
 *
 * @since SDL 2.0
 */
extern SDLTextFieldName const SDLTextFieldNameInitialInteractionText;

/**
 * @abstract First line of navigation text.
 *
 * @since SDL 2.0
 */
extern SDLTextFieldName const SDLTextFieldNameNavigationText1;

/**
 * @abstract Second line of navigation text.
 *
 * @since SDL 2.0
 */
extern SDLTextFieldName const SDLTextFieldNameNavigationText2;

/**
 * @abstract Estimated Time of Arrival time for navigation.
 *
 * @since SDL 2.0
 */
extern SDLTextFieldName const SDLTextFieldNameETA;

/**
 * @abstract Total distance to destination for navigation.
 *
 * @since SDL 2.0
 */
extern SDLTextFieldName const SDLTextFieldNameTotalDistance;

/**
 * @abstract First line of text for audio pass thru.
 *
 * @since SDL 2.0
 */
extern SDLTextFieldName const SDLTextFieldNameAudioPassThruDisplayText1;

/**
 * @abstract Second line of text for audio pass thru.
 *
 * @since SDL 2.0
 */
extern SDLTextFieldName const SDLTextFieldNameAudioPassThruDisplayText2;

/**
 * @abstract Header text for slider.
 *
 * @since SDL 2.0
 */
extern SDLTextFieldName const SDLTextFieldNameSliderHeader;

/**
 * @abstract Footer text for slider
 *
 * @since SDL 2.0
 */
extern SDLTextFieldName const SDLTextFieldNameSliderFooter;

/**
 * Primary text for SDLChoice
 */
extern SDLTextFieldName const SDLTextFieldNameMenuName;

/**
 * Secondary text for SDLChoice
 */
extern SDLTextFieldName const SDLTextFieldNameSecondaryText;

/**
 * Tertiary text for SDLChoice
 */
extern SDLTextFieldName const SDLTextFieldNameTertiaryText;

/**
 * Optional text to label an app menu button (for certain touchscreen platforms)
 */
extern SDLTextFieldName const SDLTextFieldNameMenuTitle;

/**
 * Optional name / title of intended location for SDLSendLocation
 *
 * @since SDL 4.0
 */
extern SDLTextFieldName const SDLTextFieldNameLocationName;

/**
 * Optional description of intended location / establishment (if applicable) for SDLSendLocation
 *
 * @since SDL 4.0
 */
extern SDLTextFieldName const SDLTextFieldNameLocationDescription;

/**
 * Optional location address (if applicable) for SDLSendLocation
 *
 * @since SDL 4.0
 */
extern SDLTextFieldName const SDLTextFieldNameAddressLines;

/**
 * Optional hone number of intended location / establishment (if applicable) for SDLSendLocation
 *
 * @since SDL 4.0
 */
extern SDLTextFieldName const SDLTextFieldNamePhoneNumber;
