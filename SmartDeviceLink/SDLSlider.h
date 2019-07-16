//  SDLSlider.h
//


#import "SDLRPCRequest.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Creates a full screen or pop-up overlay (depending on platform) with a single user controlled slider.
 *
 * HMILevel needs to be FULL
 *
 * Since SDL 2.0
 */
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
 *  Represents a number of selectable items on a horizontal axis
 *
 *  Required, Integer, 2 - 26
 *
 *  Since SDL 2.0
 */
@property (strong, nonatomic) NSNumber<SDLInt> *numTicks;

/**
 *  Initial position of slider control (cannot exceed numTicks).
 *
 *  Integer, Required, Min Value: 1, Max Value: 26
 *
 *  @since SDL 2.0
 */
@property (strong, nonatomic) NSNumber<SDLInt> *position;

/**
 *  Text header to display.
 *
 *  String, Required, Max length 500 chars
 *
 *  Since SDL 2.0
 */
@property (strong, nonatomic) NSString *sliderHeader;

/**
 *  Text footer to display (meant to display min/max threshold descriptors).
 *
 *  For a static text footer, only one footer string shall be provided in the array.
 *  For a dynamic text footer, the number of footer text string in the array must match the numTicks value.
 *  For a dynamic text footer, text array string should correlate with potential slider position index.
 *  If omitted on supported displays, no footer text shall be displayed.
 *
 *  Array of Strings, Optional, Array length 1 - 26, Max length 500 chars
 *
 *  Since SDL 2.0
 */
@property (strong, nonatomic, nullable) NSArray<NSString *> *sliderFooter;

/**
 *  App defined timeout. Indicates how long of a timeout from the last action (i.e. sliding control resets timeout). If omitted, the value is set to 10 seconds.
 *
 *  Integer, Optional, Min value: 1000, Max value: 65535, Default value: 10000
 *
 *  Since SDL 2.0
 */
@property (strong, nonatomic, nullable) NSNumber<SDLInt> *timeout;

@end

NS_ASSUME_NONNULL_END
