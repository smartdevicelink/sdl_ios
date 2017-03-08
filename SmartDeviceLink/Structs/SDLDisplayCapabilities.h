//  SDLDisplayCapabilities.h
//

#import "SDLRPCMessage.h"

#import "SDLDisplayType.h"
#import "SDLMediaClockFormat.h"

@class SDLImageField;
@class SDLScreenParams;
@class SDLTextField;

/**
 * Contains information about the display for the SDL system to which the application is currently connected.
 * 
 * @since SDL 1.0
 */

NS_ASSUME_NONNULL_BEGIN

@interface SDLDisplayCapabilities : SDLRPCStruct

/**
 * @abstract The type of display
 *
 * Required
 */
@property (strong, nonatomic) SDLDisplayType displayType;

/**
 * @abstract An array of SDLTextField structures, each of which describes a field in the HMI which the application can write to using operations such as *SDLShow*, *SDLSetMediaClockTimer*, etc.
 *
 * @discussion This array of SDLTextField structures identify all the text fields to which the application can write on the current display (identified by SDLDisplayType).
 *
 * @see SDLTextField
 *
 * Required, Array of SDLTextField, 1 - 100 objects
 */
@property (strong, nonatomic) NSArray<SDLTextField *> *textFields;

/**
 * @abstract An array of SDLImageField elements
 *
 * @discussion A set of all fields that support images.
 *
 * @see SDLImageField
 *
 * Optional, Array of SDLImageField, 1 - 100 objects
 */
@property (nullable, strong, nonatomic) NSArray<SDLImageField *> *imageFields;

/**
 * @abstract An array of SDLMediaClockFormat elements, defining the valid string formats used in specifying the contents of the media clock field
 *
 * @see SDLMediaClockFormat
 *
 * Required, Array of SDLMediaClockFormats, 0 - 100 objects
 */
@property (strong, nonatomic) NSArray<SDLMediaClockFormat> *mediaClockFormats;

/**
 * @abstract The display's persistent screen supports.
 * 
 * @since SDL 2.0
 *
 * Required, Boolean
 */
@property (strong, nonatomic) NSNumber<SDLBool> *graphicSupported;

/**
 * @abstract Number of presets the screen supports
 *
 * @discussion The number of on-screen custom presets available (if any)
 *
 * Optional, Array of String, max string size 100, 0 - 100 objects
 */
@property (nullable, strong, nonatomic) NSArray<NSString *> *templatesAvailable;

/**
 * @abstract A set of all parameters related to a prescribed screen area (e.g. for video / touch input)
 *
 * Optional
 */
@property (nullable, strong, nonatomic) SDLScreenParams *screenParams;

/**
 * @abstract The number of on-screen custom presets available (if any); otherwise omitted
 *
 * Optional, Integer 1 - 100
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *numCustomPresetsAvailable;

@end

NS_ASSUME_NONNULL_END
