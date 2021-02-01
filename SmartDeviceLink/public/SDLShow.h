//  SDLShow.h
//

#import "SDLRPCRequest.h"

#import "SDLTextAlignment.h"
#import "SDLMetadataType.h"

@class SDLImage;
@class SDLSoftButton;
@class SDLMetadataTags;
@class SDLTemplateConfiguration;


/**
 * Updates the application's display text area, regardless of whether or not
 * this text area is visible to the user at the time of the request. The
 * application's display text area remains unchanged until updated by subsequent
 * calls to Show
 * <p>
 * The content of the application's display text area is visible to the user
 * when the application
 * is FULL or LIMITED, and the
 * SDLSystemContext=MAIN and no
 * SDLAlert is in progress
 * <p>
 * The Show operation cannot be used to create an animated scrolling screen. To
 * avoid distracting the driver, Show commands cannot be issued more than once
 * every 4 seconds. Requests made more frequently than this will be rejected
 * <p>
 * <b>HMILevel needs to be FULL, LIMITED or BACKGROUND</b>
 * </p>
 *
 * Since SmartDeviceLink 1.0
 * See SDLAlert SDLSetMediaClockTimer
 */

NS_ASSUME_NONNULL_BEGIN

@interface SDLShow : SDLRPCRequest

/// Convenience init to set template elements with the following parameters
///
/// @param mainField1 The text displayed on the first display line
/// @param mainField2 The text displayed on the second display line
/// @param alignment The alignment that specifies how the text should be aligned on display
/// @return An SDLShow object
- (instancetype)initWithMainField1:(nullable NSString *)mainField1 mainField2:(nullable NSString *)mainField2 alignment:(nullable SDLTextAlignment)alignment __deprecated_msg("Use initWithMainField1:mainField2:mainField3:mainField4:alignment:statusBar:mediaTrack:graphic:secondaryGraphic:softButtons:customPresets:metadataTags:templateTitle:windowID:templateConfiguration: instead");

/// Convenience init to set template elements with the following parameters
///
/// @param mainField1 The text displayed on the first display line
/// @param mainField1Type Text field metadata types
/// @param mainField2 The text displayed on the second display line
/// @param mainField2Type Text field metadata types
/// @param alignment The alignment that specifies how the text should be aligned on display
/// @return An SDLShow object
- (instancetype)initWithMainField1:(nullable NSString *)mainField1 mainField1Type:(nullable SDLMetadataType)mainField1Type mainField2:(nullable NSString *)mainField2 mainField2Type:(nullable SDLMetadataType)mainField2Type alignment:(nullable SDLTextAlignment)alignment __deprecated_msg("Use initWithMainField1:mainField2:mainField3:mainField4:alignment:statusBar:mediaTrack:graphic:secondaryGraphic:softButtons:customPresets:metadataTags:templateTitle:windowID:templateConfiguration: instead");

/// Convenience init to set template elements with the following parameters
///
/// @param mainField1 The text displayed on the first display line
/// @param mainField2 The text displayed on the second display line
/// @param mainField3 The text displayed on the third display line
/// @param mainField4 The text displayed on the fourth display line
/// @param alignment The alignment that specifies how the text should be aligned on display
/// @return An SDLShow object
- (instancetype)initWithMainField1:(nullable NSString *)mainField1 mainField2:(nullable NSString *)mainField2 mainField3:(nullable NSString *)mainField3 mainField4:(nullable NSString *)mainField4 alignment:(nullable SDLTextAlignment)alignment __deprecated_msg("Use initWithMainField1:mainField2:mainField3:mainField4:alignment:statusBar:mediaTrack:graphic:secondaryGraphic:softButtons:customPresets:metadataTags:templateTitle:windowID:templateConfiguration: instead");

/// Convenience init to set template elements with the following parameters
///
/// @param mainField1 The text displayed on the first display line
/// @param mainField1Type Text field metadata types
/// @param mainField2 The text displayed on the second display line
/// @param mainField2Type Text field metadata types
/// @param mainField3 The text displayed on the third display line
/// @param mainField3Type Text field metadata types
/// @param mainField4 The text displayed on the fourth display line
/// @param mainField4Type Text field metadata types
/// @param alignment The alignment that specifies how the text should be aligned on display
/// @return An SDLShow object
- (instancetype)initWithMainField1:(nullable NSString *)mainField1 mainField1Type:(nullable SDLMetadataType)mainField1Type mainField2:(nullable NSString *)mainField2 mainField2Type:(nullable SDLMetadataType)mainField2Type mainField3:(nullable NSString *)mainField3 mainField3Type:(nullable SDLMetadataType)mainField3Type mainField4:(nullable NSString *)mainField4 mainField4Type:(nullable SDLMetadataType)mainField4Type alignment:(nullable SDLTextAlignment)alignment __deprecated_msg("Use initWithMainField1:mainField2:mainField3:mainField4:alignment:statusBar:mediaTrack:graphic:secondaryGraphic:softButtons:customPresets:metadataTags:templateTitle:windowID:templateConfiguration: instead");

/// Convenience init to set template elements with the following parameters
///
/// @param mainField1 The text displayed on the first display line
/// @param mainField2 The text displayed on the second display line
/// @param alignment The alignment that specifies how the text should be aligned on display
/// @param statusBar Text in the status Bar
/// @param mediaClock The value for the mediaClock field
/// @param mediaTrack The text in the track field
/// @return An SDLShow object
- (instancetype)initWithMainField1:(nullable NSString *)mainField1 mainField2:(nullable NSString *)mainField2 alignment:(nullable SDLTextAlignment)alignment statusBar:(nullable NSString *)statusBar mediaClock:(nullable NSString *)mediaClock mediaTrack:(nullable NSString *)mediaTrack __deprecated_msg("Use initWithMainField1:mainField2:mainField3:mainField4:alignment:statusBar:mediaTrack:graphic:secondaryGraphic:softButtons:customPresets:metadataTags:templateTitle:windowID:templateConfiguration: instead");

/// Convenience init to set template elements with the following parameters
///
/// @param mainField1 The text displayed on the first display line
/// @param mainField2 The text displayed on the second display line
/// @param mainField3 The text displayed on the third display line
/// @param mainField4 The text displayed on the fourth display line
/// @param alignment The alignment that specifies how the text should be aligned on display
/// @param statusBar Text in the status bar
/// @param mediaClock The value for the mediaClock field
/// @param mediaTrack The text in the track field
/// @param graphic An image to be shown on supported displays
/// @param softButtons The the Soft buttons defined by the app
/// @param customPresets The custom presets defined by the App
/// @param metadata Text field metadata
/// @return An SDLShow object
- (instancetype)initWithMainField1:(nullable NSString *)mainField1 mainField2:(nullable NSString *)mainField2 mainField3:(nullable NSString *)mainField3 mainField4:(nullable NSString *)mainField4 alignment:(nullable SDLTextAlignment)alignment statusBar:(nullable NSString *)statusBar mediaClock:(nullable NSString *)mediaClock mediaTrack:(nullable NSString *)mediaTrack graphic:(nullable SDLImage *)graphic softButtons:(nullable NSArray<SDLSoftButton *> *)softButtons customPresets:(nullable NSArray<NSString *> *)customPresets textFieldMetadata:(nullable SDLMetadataTags *)metadata __deprecated_msg("Use initWithMainField1:mainField2:mainField3:mainField4:alignment:statusBar:mediaTrack:graphic:secondaryGraphic:softButtons:customPresets:metadataTags:templateTitle:windowID:templateConfiguration: instead");

/**
 * @param mainField1 - mainField1
 * @param mainField2 - mainField2
 * @param mainField3 - mainField3
 * @param mainField4 - mainField4
 * @param alignment - alignment
 * @param statusBar - statusBar
 * @param mediaTrack - mediaTrack
 * @param graphic - graphic
 * @param secondaryGraphic - secondaryGraphic
 * @param softButtons - softButtons
 * @param customPresets - customPresets
 * @param metadataTags - metadataTags
 * @param templateTitle - templateTitle
 * @param windowID - windowID
 * @param templateConfiguration - templateConfiguration
 * @return A SDLShow object
 */
- (instancetype)initWithMainField1:(nullable NSString *)mainField1 mainField2:(nullable NSString *)mainField2 mainField3:(nullable NSString *)mainField3 mainField4:(nullable NSString *)mainField4 alignment:(nullable SDLTextAlignment)alignment statusBar:(nullable NSString *)statusBar mediaTrack:(nullable NSString *)mediaTrack graphic:(nullable SDLImage *)graphic secondaryGraphic:(nullable SDLImage *)secondaryGraphic softButtons:(nullable NSArray<SDLSoftButton *> *)softButtons customPresets:(nullable NSArray<NSString *> *)customPresets metadataTags:(nullable SDLMetadataTags *)metadataTags templateTitle:(nullable NSString *)templateTitle windowID:(nullable NSNumber<SDLInt> *)windowID templateConfiguration:(nullable SDLTemplateConfiguration *)templateConfiguration;

/**
 * The text displayed in a single-line display, or in the upper display
 * line in a two-line display
 * @discussion The String value representing the text displayed in a
 *            single-line display, or in the upper display line in a
 *            two-line display
 *            <p>
 *            <b>Notes: </b>
 *            <ul>
 *            <li>If this parameter is omitted, the text of mainField1 does
 *            not change</li>
 *            <li>If this parameter is an empty string, the field will be
 *            cleared</li>
 *            </ul>
 */
@property (strong, nonatomic, nullable) NSString *mainField1;
/**
 * The text displayed on the second display line of a two-line display
 *
 * @discussion The String value representing the text displayed on the second
 *            display line of a two-line display
 *            <p>
 *            <b>Notes: </b>
 *            <ul>
 *            <li>If this parameter is omitted, the text of mainField2 does
 *            not change</li>
 *            <li>If this parameter is an empty string, the field will be
 *            cleared</li>
 *            <li>If provided and the display is a single-line display, the
 *            parameter is ignored</li>
 *            <li>Maxlength = 500</li>
 *            </ul>
 */
@property (strong, nonatomic, nullable) NSString *mainField2;
/**
 * The text displayed on the first display line of the second page
 *
 * @discussion The String value representing the text displayed on the first
 *            display line of the second page
 *            <p>
 *            <b>Notes: </b>
 *            <ul>
 *            <li>If this parameter is omitted, the text of mainField3 does
 *            not change</li>
 *            <li>If this parameter is an empty string, the field will be
 *            cleared</li>
 *            <li>If provided and the display is a single-line display, the
 *            parameter is ignored</li>
 *            <li>Maxlength = 500</li>
 *            </ul>
 * @since SmartDeviceLink 2.0
 */
@property (strong, nonatomic, nullable) NSString *mainField3;
/**
 * The text displayed on the second display line of the second page
 *
 * @discussion The String value representing the text displayed on the second
 *            display line of the second page
 *            <p>
 *            <b>Notes: </b>
 *            <ul>
 *            <li>If this parameter is omitted, the text of mainField4 does
 *            not change</li>
 *            <li>If this parameter is an empty string, the field will be
 *            cleared</li>
 *            <li>If provided and the display is a single-line display, the
 *            parameter is ignored</li>
 *            <li>Maxlength = 500</li>
 *            </ul>
 * @since SmartDeviceLink 2.0
 */
@property (strong, nonatomic, nullable) NSString *mainField4;
/**
 * The alignment that Specifies how mainField1 and mainField2 text
 * should be aligned on display
 *
 * @discussion An Enumeration value
 *            <p>
 *            <b>Notes: </b>
 *            <ul>
 *            <li>Applies only to mainField1 and mainField2 provided on this
 *            call, not to what is already showing in display</li>
 *            <li>If this parameter is omitted, text in both mainField1 and
 *            mainField2 will be centered</li>
 *            <li>Has no effect with navigation display</li>
 *            </ul>
 */
@property (strong, nonatomic, nullable) SDLTextAlignment alignment;
/**
 * Text in the Status Bar
 *
 * @discussion A String representing the text you want to add in the Status
 *            Bar
 *            <p>
 *            <b>Notes: </b><i>The status bar only exists on navigation
 *            displays</i><br/>
 *            <ul>
 *            <li>If this parameter is omitted, the status bar text will
 *            remain unchanged</li>
 *            <li>If this parameter is an empty string, the field will be
 *            cleared</li>
 *            <li>If provided and the display has no status bar, this
 *            parameter is ignored</li>
 *            </ul>
 */
@property (strong, nonatomic, nullable) NSString *statusBar;

/**
 * Text value for MediaClock field. Has to be properly formatted by Mobile App according to the module's capabilities. If this text is set, any automatic media clock updates previously set with SetMediaClockTimer will be stopped.
 * {"string_min_length": 0, "string_max_length": 500}
 *
 * @deprecated in SmartDeviceLink 7.1.0
 * @added in SmartDeviceLink 1.0.0
 */
@property (strong, nonatomic, nullable) NSString *mediaClock __deprecated;
/**
 * The text in the track field
 *
 * @discussion A String value disaplayed in the track field
 *            <p>
 *            <b>Notes: </b><br/>
 *            <ul>
 *            <li>If parameter is omitted, the track field remains unchanged</li>
 *            <li>If an empty string is provided, the field will be cleared</li>
 *            <li>This field is only valid for media applications on navigation displays</li>
 *            </ul>
 */
@property (strong, nonatomic, nullable) NSString *mediaTrack;
/**
 * An image to be shown on supported displays
 *
 * @discussion The value representing the image shown on supported displays
 *            <p>
 *            <b>Notes: </b>If omitted on supported displays, the displayed
 *            graphic shall not change<br/>
 * @since SmartDeviceLink 2.0
 */
@property (strong, nonatomic, nullable) SDLImage *graphic;
/**
 * An image to be shown on supported displays
 *
 * @discussion The value representing the image shown on supported displays
 *            <p>
 *            <b>Notes: </b>If omitted on supported displays, the displayed
 *            graphic shall not change<br/>
 * @since SmartDeviceLink 2.0
 */
@property (strong, nonatomic, nullable) SDLImage *secondaryGraphic;
/**
 * The the Soft buttons defined by the App
 *
 * @discussion A Vector value represemting the Soft buttons defined by the
 *            App
 *            <p>
 *            <b>Notes: </b><br/>
 *            <ul>
 *            <li>If omitted on supported displays, the currently displayed
 *            SoftButton values will not change</li>
 *            <li>Array Minsize: 0</li>
 *            <li>Array Maxsize: 8</li>
 *            </ul>
 *
 * @since SmartDeviceLink 2.0
 */
@property (strong, nonatomic, nullable) NSArray<SDLSoftButton *> *softButtons;
/**
 * The Custom Presets defined by the App
 *
 * @discussion A Vector value representing the Custom Presets defined by the App
 *            <p>
 *            <ul>
 *            <li>If omitted on supported displays, the presets will be shown as not defined</li>
 *            <li>Array Minsize: 0</li>
 *            <li>Array Maxsize: 6</li>
 *            </ul>
 * @since SmartDeviceLink 2.0
 */
@property (strong, nonatomic, nullable) NSArray<NSString *> *customPresets;

/**
 Text Field Metadata

 App defined metadata information. See MetadataStruct. Uses mainField1, mainField2, mainField3, mainField4. If omitted on supported displays, the currently set metadata tags will not change. If any text field contains no tags or the none tag, the metadata tag for that textfield should be removed.

 @since SmartDeviceLink 2.0
 */
@property (strong, nonatomic, nullable) SDLMetadataTags *metadataTags;


/**
 This is the unique ID assigned to the window that this RPC is intended. If this param is not included, it will be assumed that this request is specifically for the main window on the main display. @see PredefinedWindows enum.
 
 @since SDL 6.0
 */
@property (strong, nonatomic, nullable) NSNumber<SDLUInt> *windowID;

/**
 Used to set an alternate template layout to a window.
 
 @since SDL 6.0
 */
@property (strong, nonatomic, nullable) SDLTemplateConfiguration *templateConfiguration;

/**
 The title of the current template.

 How this will be displayed is dependent on the OEM design and implementation of the template.

 Optional, since SmartDeviceLink 6.0
 */
@property (strong, nonatomic, nullable) NSString *templateTitle;

@end

NS_ASSUME_NONNULL_END
