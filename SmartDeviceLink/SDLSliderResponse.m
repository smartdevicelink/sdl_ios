//  SDLSliderResponse.m
//


#import "SDLSliderResponse.h"

#import "SDLNames.h"

@implementation SDLSliderResponse

- (instancetype)init {
    if (self = [super initWithName:SDLNameSlider]) {
    }
    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
    }
    return self;
}

- (void)setSliderPosition:(NSNumber *)sliderPosition {
    if (sliderPosition != nil) {
        [parameters setObject:sliderPosition forKey:SDLNameSliderPosition];
    } else {
        [parameters removeObjectForKey:SDLNameSliderPosition];
    }
}

- (NSNumber *)sliderPosition {
    return [parameters objectForKey:SDLNameSliderPosition];
}

@end
