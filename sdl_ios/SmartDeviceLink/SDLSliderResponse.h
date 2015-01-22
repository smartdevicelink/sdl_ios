//  SDLSliderResponse.h
//
//  

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCResponse.h>

/**
 * Slider Response is sent, when Slider has been called
 *
 * Since SmartDeviceLink 2.0
 */
@interface SDLSliderResponse : SDLRPCResponse {}

/**
 * @abstract Constructs a new SDLSliderResponse object
 */
-(id) init;
/**
 * @abstract Constructs a new SDLSliderResponse object indicated by the NSMutableDictionary
 * parameter
 * @param dict The NSMutableDictionary to use
 */
-(id) initWithDictionary:(NSMutableDictionary*) dict;

/**
 * @abstract The selected position of the slider.
 */
@property(strong) NSNumber* sliderPosition;

@end
