//  SDLSliderResponse.h
//


#import "SDLRPCResponse.h"

/**
 * Slider Response is sent, when Slider has been called
 *
 * Since SmartDeviceLink 2.0
 */

NS_ASSUME_NONNULL_BEGIN

@interface SDLSliderResponse : SDLRPCResponse

/**
 * @abstract The selected position of the slider.
 */
@property (nullable, strong) NSNumber<SDLInt> *sliderPosition;

@end

NS_ASSUME_NONNULL_END
