//  SDLSliderResponse.m
//


#import "SDLSliderResponse.h"

#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLSliderResponse

- (instancetype)init {
    if (self = [super initWithName:SDLNameSlider]) {
    }
    return self;
}

- (void)setSliderPosition:(nullable NSNumber<SDLInt> *)sliderPosition {
    [parameters sdl_setObject:sliderPosition forName:SDLNameSliderPosition];
}

- (nullable NSNumber<SDLInt> *)sliderPosition {
    return [parameters sdl_objectForName:SDLNameSliderPosition];
}

@end

NS_ASSUME_NONNULL_END
