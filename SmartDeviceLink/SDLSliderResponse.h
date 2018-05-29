//  SDLSliderResponse.h
//


#import "SDLRPCResponse.h"

NS_ASSUME_NONNULL_BEGIN

/**
 Response to SDLSlider

 Since SmartDeviceLink 2.0
 */
@interface SDLSliderResponse : SDLRPCResponse

/**
 The selected position of the slider.
 */
@property (strong, nonatomic, nullable) NSNumber<SDLInt> *sliderPosition;

@end

NS_ASSUME_NONNULL_END
