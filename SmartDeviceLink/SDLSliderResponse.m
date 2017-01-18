//  SDLSliderResponse.m
//


#import "SDLSliderResponse.h"

#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"

@implementation SDLSliderResponse

- (instancetype)init {
    if (self = [super initWithName:SDLNameSlider]) {
    }
    return self;
}

- (void)setSliderPosition:(NSNumber<SDLInt> *)sliderPosition {
    [parameters sdl_setObject:sliderPosition forName:SDLNameSliderPosition];
}

- (NSNumber<SDLInt> *)sliderPosition {
    return [parameters objectForKey:SDLNameSliderPosition];
}

@end
