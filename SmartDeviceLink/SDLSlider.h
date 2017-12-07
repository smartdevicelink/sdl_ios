//  SDLSlider.h
//


#import "SDLRPCRequest.h"

/**
 * Creates a full screen or pop-up overlay (depending on platform) with a single user controlled slider
 *
 * HMILevel needs to be FULL
 *
 * Since SmartDeviceLink 2.0
 */

NS_ASSUME_NONNULL_BEGIN

@interface SDLSlider : SDLRPCRequest

/**
 Create an SDLSlider with only the number of ticks and position. Note that this is not enough to get a SUCCESS response. You must supply additional data. See below for required parameters.

 @param numTicks The number of ticks present on the slider.
 @param position The default starting position of the slider.
 @return An SDLSlider RPC Request.
 */
- (instancetype)initWithNumTicks:(UInt8)numTicks position:(UInt8)position;

/**
 Create an SDLSlider with all required data and a static footer (or no footer).

 @param numTicks The number of ticks present on the slider.
 @param position The default starting position of the slider.
 @param sliderHeader The header describing the slider.
 @param sliderFooter A static footer with text, or nil for no footer.
 @param timeout The length of time in milliseconds the popup should be displayed before automatically disappearing.
 @return An SDLSlider RPC Request.
 */
- (instancetype)initWithNumTicks:(UInt8)numTicks position:(UInt8)position sliderHeader:(NSString *)sliderHeader sliderFooter:(nullable NSString *)sliderFooter timeout:(UInt16)timeout;

/**
 Create an SDLSlider with all required data and a dynamic footer (or no footer).

 @param numTicks The number of ticks present on the slider.
 @param position The default starting position of the slider.
 @param sliderHeader The header describing the slider.
 @param sliderFooters An array of footers. This should be the same length as `numTicks` as each footer should correspond to a tick, or no footer if nil.
 @param timeout The length of time in milliseconds the popup should be displayed before automatically disappearing.
 @return An SDLSlider RPC Request.
 */
- (instancetype)initWithNumTicks:(UInt8)numTicks position:(UInt8)position sliderHeader:(NSString *)sliderHeader sliderFooters:(nullable NSArray<NSString *> *)sliderFooters timeout:(UInt16)timeout;

/**
 * @abstract Represents a number of selectable items on a horizontal axis
 *
 * Required, Integer, 2 - 26
 */
@property (strong, nonatomic) NSNumber<SDLInt> *numTicks;

/**
 * @abstract An Initial position of slider control
 *
 * Required, Integer, 1 - 26
 */
@property (strong, nonatomic) NSNumber<SDLInt> *position;

/**
 * @abstract A text header to display
 *
 * Required, Max length 500 chars
 */
@property (strong, nonatomic) NSString *sliderHeader;

/**
 * @abstract A text footer to display
 *
 * @discussion For a static text footer, only one footer string shall be provided in the array.
 * 
 * For a dynamic text footer, the number of footer text string in the array must match the numTicks value.
 *
 * For a dynamic text footer, text array string should correlate with potential slider position index.
 *
 * If omitted on supported displays, no footer text shall be displayed.
 *
 * Optional, Array of Strings, Array length 1 - 26, Max string length 500 chars
 */
@property (strong, nonatomic, nullable) NSArray<NSString *> *sliderFooter;

/**
 * @abstract An App defined timeout in milliseconds
 *
 * @discussion Indicates how long of a timeout from the last action (i.e. sliding control resets timeout).
 *
 * If omitted, the value is set to 10000.
 *
 * Optional, Integer, 1000 - 65535
 */
@property (strong, nonatomic, nullable) NSNumber<SDLInt> *timeout;

@end

NS_ASSUME_NONNULL_END
