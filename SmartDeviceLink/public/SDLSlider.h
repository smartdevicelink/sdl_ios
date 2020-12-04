//  SDLSlider.h
//


#import "SDLRPCRequest.h"

NS_ASSUME_NONNULL_BEGIN

/**
 Creates a full screen or pop-up overlay (depending on platform) with a single user controlled slider.

 If connecting to SDL Core v.6.0+, the slider can be canceled programmatically using the `cancelID`. On older versions of SDL Core, the slider will persist until the user has interacted with the slider or the specified timeout has elapsed.

 Since SDL 2.0
 */
@interface SDLSlider : SDLRPCRequest

/**
 Convenience init with all parameters.

 @param numTicks Number of selectable items on a horizontal axis
 @param position Initial position of slider control
 @param sliderHeader Text header to display
 @param sliderFooters Text footers to display. See the `sliderFooter` documentation for how placing various numbers of footers will affect the display
 @param timeout Indicates how long of a timeout from the last action (i.e. sliding control resets timeout)
 @param cancelID An ID for this specific slider to allow cancellation through the `CancelInteraction` RPC.
 @return An SDLSlider object
 */
- (instancetype)initWithNumTicks:(UInt8)numTicks position:(UInt8)position sliderHeader:(NSString *)sliderHeader sliderFooters:(nullable NSArray<NSString *> *)sliderFooters timeout:(UInt16)timeout cancelID:(UInt32)cancelID;

/**
 Creates a slider with only the number of ticks and position. Note that this is not enough to get a SUCCESS response. You must supply additional data. See below for required parameters.

 @param numTicks Number of selectable items on a horizontal axis
 @param position Initial position of slider control
 @return An SDLSlider object
 */
- (instancetype)initWithNumTicks:(UInt8)numTicks position:(UInt8)position;

/**
 Creates a slider with all required data and a static footer (or no footer).

 @param numTicks Number of selectable items on a horizontal axis
 @param position Initial position of slider control
 @param sliderHeader Text header to display
 @param sliderFooter Text footer to display
 @param timeout Indicates how long of a timeout from the last action (i.e. sliding control resets timeout)
 @return An SDLSlider object
 */
- (instancetype)initWithNumTicks:(UInt8)numTicks position:(UInt8)position sliderHeader:(NSString *)sliderHeader sliderFooter:(nullable NSString *)sliderFooter timeout:(UInt16)timeout;

/**
 Creates an slider with all required data and a dynamic footer (or no footer).

 @param numTicks Number of selectable items on a horizontal axis
 @param position Initial position of slider control
 @param sliderHeader Text header to display
 @param sliderFooters Text footers to display
 @param timeout Indicates how long of a timeout from the last action (i.e. sliding control resets timeout)
 @return An SDLSlider object
 */
- (instancetype)initWithNumTicks:(UInt8)numTicks position:(UInt8)position sliderHeader:(NSString *)sliderHeader sliderFooters:(nullable NSArray<NSString *> *)sliderFooters timeout:(UInt16)timeout;

/**
 Represents a number of selectable items on a horizontal axis.

 Integer, Required, Min value: 2, Max Value: 26

 Since SDL 2.0
 */
@property (strong, nonatomic) NSNumber<SDLInt> *numTicks;

/**
 Initial position of slider control (cannot exceed numTicks).

 Integer, Required, Min Value: 1, Max Value: 26

 @since SDL 2.0
 */
@property (strong, nonatomic) NSNumber<SDLInt> *position;

/**
 Text header to display.

 String, Required, Max length 500 chars

 Since SDL 2.0
 */
@property (strong, nonatomic) NSString *sliderHeader;

/**
 Text footer to display.

 For a static text footer, only one footer string shall be provided in the array.
 For a dynamic text footer, the number of footer text string in the array must match the numTicks value.
 For a dynamic text footer, text array string should correlate with potential slider position index.
 If omitted on supported displays, no footer text shall be displayed.

 Array of Strings, Optional, Array length 1 - 26, Max length 500 chars

 Since SDL 2.0
 */
@property (strong, nonatomic, nullable) NSArray<NSString *> *sliderFooter;

/**
 App defined timeout. Indicates how long of a timeout from the last action (i.e. sliding control resets timeout). If omitted, the value is set to 10 seconds.

 Integer, Optional, Min value: 1000, Max value: 65535, Default value: 10000

 Since SDL 2.0
 */
@property (strong, nonatomic, nullable) NSNumber<SDLInt> *timeout;

/**
 An ID for this specific slider to allow cancellation through the `CancelInteraction` RPC.

 Integer, Optional

 @see SDLCancelInteraction
 @since SDL 6.0
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *cancelID;

@end

NS_ASSUME_NONNULL_END
