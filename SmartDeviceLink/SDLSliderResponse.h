//  SDLSliderResponse.h
//


#import "SDLRPCResponse.h"

/**
 * Slider Response is sent, when Slider has been called
 *
 * Since SmartDeviceLink 2.0
 */
@interface SDLSliderResponse : SDLRPCResponse

/**
 * @abstract The selected position of the slider.
 */
@property (strong, nonatomic) NSNumber<SDLInt> *sliderPosition;

@end
