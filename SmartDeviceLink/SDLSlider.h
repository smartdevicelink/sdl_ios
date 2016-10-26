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
@interface SDLSlider : SDLRPCRequest {
}

/**
 * @abstract Constructs a new SDLSlider object
 */
- (instancetype)init;

/**
 * @abstract Constructs a new SDLSlider object indicated by the dictionary parameter
 * @param dict The dictionary to use
 */
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

- (instancetype)initWithNumTicks:(UInt8)numTicks position:(UInt8)position;

- (instancetype)initWithNumTicks:(UInt8)numTicks position:(UInt8)position sliderHeader:(NSString *)sliderHeader sliderFooter:(NSString *)sliderFooter timeout:(UInt16)timeout;

- (instancetype)initWithNumTicks:(UInt8)numTicks position:(UInt8)position sliderHeader:(NSString *)sliderHeader sliderFooters:(NSArray<NSString *> *)sliderFooters timeout:(UInt16)timeout;

/**
 * @abstract Represents a number of selectable items on a horizontal axis
 *
 * Required, Integer, 2 - 26
 */
@property (strong) NSNumber *numTicks;

/**
 * @abstract An Initial position of slider control
 *
 * Required, Integer, 1 - 26
 */
@property (strong) NSNumber *position;

/**
 * @abstract A text header to display
 *
 * Rquired, Max length 500 chars
 */
@property (strong) NSString *sliderHeader;

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
@property (strong) NSMutableArray *sliderFooter;

/**
 * @abstract An App defined timeout
 *
 * @discussion Indicates how long of a timeout from the last action (i.e. sliding control resets timeout).
 *
 * If omitted, the value is set to 10000.
 *
 * Optional, Integer, 1000 - 65535
 */
@property (strong) NSNumber *timeout;

@end
