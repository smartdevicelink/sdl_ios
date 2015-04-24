//  SDLTextFieldName.h
//



#import "SDLEnum.h"

/**
 * Names of the text fields that can appear on a SDL display.
 *
 * Avaliable since <font color=red><b> SmartDeviceLink 1.0 </b></font>
 */
@interface SDLTextFieldName : SDLEnum {}

/**
 * Convert String to SDLTextFieldName
 * @param value String
 * @return SDLTextFieldName
 */
+(SDLTextFieldName*) valueOf:(NSString*) value;
/*!
 @abstract Store the enumeration of all possible SDLTextFieldName
 @result return an array that store all possible SDLTextFieldName
 */
+(NSArray*) values;

/**
 * @abstract The first line of the first set of main fields of the persistent display. Applies to <i>Show</i>.
 * @result return a SDLTextFieldName with value of <font color=gray><i> mainField1 </i></font>
 */
+(SDLTextFieldName*) mainField1;
/**
 * @abstract The second line of the first set of main fields of the persistent display. Applies to <i>Show</i>.
 * @result return a SDLTextFieldName with value of <font color=gray><i> mainField2 </i></font>
 * @since <font color=red><b> SmartDeviceLink 2.0 </b></font>
 */
+(SDLTextFieldName*) mainField2;
/**
 * @abstract The first line of the second set of main fields of the persistent display. Applies to <i>Show</i>.
 * @result return a SDLTextFieldName with value of <font color=gray><i> mainField3 </i></font>
 * @since <font color=red><b> SmartDeviceLink 2.0 </b></font>
 */
+(SDLTextFieldName*) mainField3;
/**
 * @abstract The second line of the second set of main fields of the persistent display. Applies to <i>Show</i>.
 * @result return a SDLTextFieldName with value of <font color=gray><i> mainField4 </i></font>
 */
+(SDLTextFieldName*) mainField4;
/**
 * @abstract The status bar on the NGN display. Applies to <i>Show</i>.
 * @result return a SDLTextFieldName with value of <font color=gray><i> statusBar </i></font>
 */
+(SDLTextFieldName*) statusBar;
/**
 * @abstract Text value for MediaClock field. Must be properly formatted according to MediaClockFormat. Applies to <i>Show</i>.
 * @discussion This field is commonly used to show elapsed or remaining time in an audio track or audio capture.
 * @result return a SDLTextFieldName with value of <font color=gray><i> mediaClock </i></font>
 */
+(SDLTextFieldName*) mediaClock;
/**
 * @abstract The track field of NGN type ACMs. This field is only available for media applications on a NGN display. Applies to <i>Show</i>.
 * @discussion This field is commonly used to show the current track number
 * @result return a SDLTextFieldName with value of <font color=gray><i> mediaTrack </i></font>
 */
+(SDLTextFieldName*) mediaTrack;
/**
 * @abstract The first line of the alert text field. Applies to <i>Alert</i>.
 * @result return a SDLTextFieldName with value of <font color=gray><i> alertText1 </i></font>
 */
+(SDLTextFieldName*) alertText1;
/**
 * @abstract The second line of the alert text field. Applies to <i>Alert</i>.
 * @result return a SDLTextFieldName with value of <font color=gray><i> alertText2 </i></font>
 * @since <font color=red><b> SmartDeviceLink 2.0 </b></font>
 */
+(SDLTextFieldName*) alertText2;
/**
 * @abstract The third line of the alert text field. Applies to <i>Alert</i>.
 * @result return a SDLTextFieldName with value of <font color=gray><i> alertText3 </i></font>
 * @since <font color=red><b> SmartDeviceLink 2.0 </b></font>
 */
+(SDLTextFieldName*) alertText3;
/**
 * @abstract Long form body of text that can include newlines and tabs. Applies to ScrollableMessage (TBD)
 * @result return a SDLTextFieldName with value of <font color=gray><i> scrollableMessageBody </i></font>
 * @since <font color=red><b> SmartDeviceLink 2.0 </b></font>
 */
+(SDLTextFieldName*) scrollableMessageBody;
/**
 * @abstract First line suggestion for a user response (in the case of VR enabled interaction).
 * @result return a SDLTextFieldName with value of <font color=gray><i> initialInteractionText </i></font>
 * @since <font color=red><b> SmartDeviceLink 2.0 </b></font>
 */
+(SDLTextFieldName*) initialInteractionText;
/**
 * @abstract First line of navigation text.
 * @result return a SDLTextFieldName with value of <font color=gray><i> navigationText1 </i></font>
 * @since <font color=red><b> SmartDeviceLink 2.0 </b></font>
 */
+(SDLTextFieldName*) navigationText1;
/**
 * @abstract Second  line of navigation text.
 * @result return a SDLTextFieldName with value of <font color=gray><i> navigationText2 </i></font>
 * @since <font color=red><b> SmartDeviceLink 2.0 </b></font>
 */
+(SDLTextFieldName*) navigationText2;
/**
 * @abstract Estimated Time of Arrival time for navigation.
 * @result return a SDLTextFieldName with value of <font color=gray><i> ETA </i></font>
 * @since <font color=red><b> SmartDeviceLink 2.0 </b></font>
 */
+(SDLTextFieldName*) ETA;
/**
 * @abstract Total distance to destination for navigation.
 * @result return a SDLTextFieldName with value of <font color=gray><i> totalDistance </i></font>
 * @since <font color=red><b> SmartDeviceLink 2.0 </b></font>
 */
+(SDLTextFieldName*) totalDistance;
/**
 * @abstract First line of text for audio pass thru.
 * @result return a SDLTextFieldName with value of <font color=gray><i> audioPassThruDisplayText1 </i></font>
 * @since <font color=red><b> SmartDeviceLink 2.0 </b></font>
 */
+(SDLTextFieldName*) audioPassThruDisplayText1;
/**
 * @abstract Second line of text for audio pass thru.
 * @result return a SDLTextFieldName with value of <font color=gray><i> audioPassThruDisplayText2 </i></font>
 * @since <font color=red><b> SmartDeviceLink 2.0 </b></font>
 */
+(SDLTextFieldName*) audioPassThruDisplayText2;
/**
 * @abstract Header text for slider.
 * @result return a SDLTextFieldName with value of <font color=gray><i> sliderHeader </i></font>
 * @since <font color=red><b> SmartDeviceLink 2.0 </b></font>
 */
+(SDLTextFieldName*) sliderHeader;
/**
 * @abstract Footer text for slider
 * @result return a SDLTextFieldName with value of <font color=gray><i> sliderFooter </i></font>
 * @since <font color=red><b> SmartDeviceLink 2.0 </b></font>
 */
+(SDLTextFieldName*) sliderFooter;

/**
 * Primary text for Choice
 */
+(SDLTextFieldName*) menuName;

/**
 * Secondary text for Choice
 */
+(SDLTextFieldName*) secondaryText;

/**
 * Tertiary text for Choice
 */
+(SDLTextFieldName*) tertiaryText;

/**
 * Optional text to label an app menu button (for certain touchscreen platforms)
 */
+(SDLTextFieldName*) menuTitle;

/**
 * Optional name / title of intended location for SendLocation
 * @since SDL 4.0
 */
+(SDLTextFieldName*) locationName;

/**
 * Optional description of intended location / establishment (if applicable) for SendLocation
 * @since SDL 4.0
 */
+(SDLTextFieldName*) locationDescription;

/**
 * Optional location address (if applicable) for SendLocation
 * @since SDL 4.0
 */
+(SDLTextFieldName*) addressLines;

/**
 * Optional hone number of intended location / establishment (if applicable) for SendLocation
 * @since SDL 4.0
 */
+(SDLTextFieldName*) phoneNumber;

@end

