//  SDLTextFieldName.h
//


#import "SDLEnum.h"

/**
 * Names of the text fields that can appear on a SDL display.
 *
 * @since SDL 1.0
 */
@interface SDLTextFieldName : SDLEnum {
}

/**
 * Convert String to SDLTextFieldName
 *
 * @param value String value to retrieve the object for
 *
 * @return SDLTextFieldName
 */
+ (SDLTextFieldName *)valueOf:(NSString *)value;

/**
 * @abstract Store the enumeration of all possible SDLTextFieldName
 * 
 * @return an array that store all possible SDLTextFieldName
 */
+ (NSArray *)values;

/**
 * @abstract The first line of the first set of main fields of the persistent display. Applies to SDLShow.
 *
 * @return a SDLTextFieldName with value of *mainField1*
 */
+ (SDLTextFieldName *)mainField1;

/**
 * @abstract The second line of the first set of main fields of the persistent display. Applies to SDLShow.
 *
 * @return a SDLTextFieldName with value of *mainField2*
 *
 * @since SDL 2.0
 */
+ (SDLTextFieldName *)mainField2;

/**
 * @abstract The first line of the second set of main fields of the persistent display. Applies to SDLShow.
 *
 * @return a SDLTextFieldName with value of *mainField3*
 *
 * @since SDL 2.0
 */
+ (SDLTextFieldName *)mainField3;

/**
 * @abstract The second line of the second set of main fields of the persistent display. Applies to SDLShow.
 *
 * @return a SDLTextFieldName with value of *mainField4*
 */
+ (SDLTextFieldName *)mainField4;

/**
 * @abstract The status bar on the NGN display. Applies to SDLShow.
 *
 * @return a SDLTextFieldName with value of *statusBar*
 */
+ (SDLTextFieldName *)statusBar;

/**
 * @abstract Text value for MediaClock field. Must be properly formatted according to MediaClockFormat. Applies to SDLShow.
 *
 * @discussion This field is commonly used to show elapsed or remaining time in an audio track or audio capture.
 *
 * @return a SDLTextFieldName with value of *mediaClock*
 */
+ (SDLTextFieldName *)mediaClock;

/**
 * @abstract The track field of NGN type ACMs. This field is only available for media applications on a NGN display. Applies to SDLShow.
 *
 * @discussion This field is commonly used to show the current track number
 *
 * @return a SDLTextFieldName with value of *mediaTrack*
 */
+ (SDLTextFieldName *)mediaTrack;

/**
 * @abstract The first line of the alert text field. Applies to SDLAlert.
 *
 * @return a SDLTextFieldName with value of *alertText1*
 */
+ (SDLTextFieldName *)alertText1;

/**
 * @abstract The second line of the alert text field. Applies to SDLAlert.
 *
 * @return a SDLTextFieldName with value of *alertText2*
 *
 * @since SDL 2.0
 */
+ (SDLTextFieldName *)alertText2;

/**
 * @abstract The third line of the alert text field. Applies to SDLAlert.
 *
 * @return a SDLTextFieldName with value of *alertText3*
 *
 * @since SDL 2.0
 */
+ (SDLTextFieldName *)alertText3;

/**
 * @abstract Long form body of text that can include newlines and tabs. Applies to SDLScrollableMessage.
 *
 * @return a SDLTextFieldName with value of *scrollableMessageBody*
 *
 * @since SDL 2.0
 */
+ (SDLTextFieldName *)scrollableMessageBody;

/**
 * @abstract First line suggestion for a user response (in the case of VR enabled interaction).
 *
 * @return a SDLTextFieldName with value of *initialInteractionText*
 *
 * @since SDL 2.0
 */
+ (SDLTextFieldName *)initialInteractionText;

/**
 * @abstract First line of navigation text.
 *
 * @return a SDLTextFieldName with value of *navigationText1*
 *
 * @since SDL 2.0
 */
+ (SDLTextFieldName *)navigationText1;

/**
 * @abstract Second line of navigation text.
 *
 * @return a SDLTextFieldName with value of *navigationText2*
 *
 * @since SDL 2.0
 */
+ (SDLTextFieldName *)navigationText2;

/**
 * @abstract Estimated Time of Arrival time for navigation.
 *
 * @return a SDLTextFieldName with value of *ETA*
 *
 * @since SDL 2.0
 */
+ (SDLTextFieldName *)ETA;

/**
 * @abstract Total distance to destination for navigation.
 *
 * @return a SDLTextFieldName with value of *totalDistance*
 *
 * @since SDL 2.0
 */
+ (SDLTextFieldName *)totalDistance;

/**
 * @abstract First line of text for audio pass thru.
 *
 * @return a SDLTextFieldName with value of *audioPassThruDisplayText1*
 *
 * @since SDL 2.0
 */
+ (SDLTextFieldName *)audioPassThruDisplayText1;

/**
 * @abstract Second line of text for audio pass thru.
 *
 * @return a SDLTextFieldName with value of *audioPassThruDisplayText2*
 *
 * @since SDL 2.0
 */
+ (SDLTextFieldName *)audioPassThruDisplayText2;

/**
 * @abstract Header text for slider.
 *
 * @return a SDLTextFieldName with value of *sliderHeader*
 *
 * @since SDL 2.0
 */
+ (SDLTextFieldName *)sliderHeader;

/**
 * @abstract Footer text for slider
 *
 * @return a SDLTextFieldName with value of *sliderFooter*
 *
 * @since SDL 2.0
 */
+ (SDLTextFieldName *)sliderFooter;

/**
 * Primary text for SDLChoice
 *
 * @return a SDLTextFieldName with value of *menuName*
 */
+ (SDLTextFieldName *)menuName;

/**
 * Secondary text for SDLChoice
 *
 * @return a SDLTextFieldName with value of *secondaryText*
 */
+ (SDLTextFieldName *)secondaryText;

/**
 * Tertiary text for SDLChoice
 *
 * @return a SDLTextFieldName with value of *tertiaryText*
 */
+ (SDLTextFieldName *)tertiaryText;

/**
 * Optional text to label an app menu button (for certain touchscreen platforms)
 *
 * @return a SDLTextFieldName with value of *menuTitle*
 */
+ (SDLTextFieldName *)menuTitle;

/**
 * Optional name / title of intended location for SDLSendLocation
 *
 * @return a SDLTextFieldName with value of *locationName*
 *
 * @since SDL 4.0
 */
+ (SDLTextFieldName *)locationName;

/**
 * Optional description of intended location / establishment (if applicable) for SDLSendLocation
 *
 * @return a SDLTextFieldName with value of *locationDescription*
 *
 * @since SDL 4.0
 */
+ (SDLTextFieldName *)locationDescription;

/**
 * Optional location address (if applicable) for SDLSendLocation
 *
 * @return a SDLTextFieldName with value of *addressLines*
 *
 * @since SDL 4.0
 */
+ (SDLTextFieldName *)addressLines;

/**
 * Optional hone number of intended location / establishment (if applicable) for SDLSendLocation
 *
 * @return a SDLTextFieldName with value of *phoneNumber*
 *
 * @since SDL 4.0
 */
+ (SDLTextFieldName *)phoneNumber;

@end
