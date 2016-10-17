//  SDLSlider.m
//


#import "SDLSlider.h"

#import "SDLNames.h"

@implementation SDLSlider

- (instancetype)init {
    if (self = [super initWithName:SDLNameSlider]) {
    }
    return self;
}

- (void)setNumTicks:(NSNumber *)numTicks {
    if (numTicks != nil) {
        [parameters setObject:numTicks forKey:SDLNameNumberTicks];
    } else {
        [parameters removeObjectForKey:SDLNameNumberTicks];
    }
}

- (NSNumber *)numTicks {
    return [parameters objectForKey:SDLNameNumberTicks];
}

- (void)setPosition:(NSNumber *)position {
    if (position != nil) {
        [parameters setObject:position forKey:SDLNamePosition];
    } else {
        [parameters removeObjectForKey:SDLNamePosition];
    }
}

- (NSNumber *)position {
    return [parameters objectForKey:SDLNamePosition];
}

- (void)setSliderHeader:(NSString *)sliderHeader {
    if (sliderHeader != nil) {
        [parameters setObject:sliderHeader forKey:SDLNameSliderHeader];
    } else {
        [parameters removeObjectForKey:SDLNameSliderHeader];
    }
}

- (NSString *)sliderHeader {
    return [parameters objectForKey:SDLNameSliderHeader];
}

- (void)setSliderFooter:(NSMutableArray<NSString *> *)sliderFooter {
    if (sliderFooter != nil) {
        [parameters setObject:sliderFooter forKey:SDLNameSliderFooter];
    } else {
        [parameters removeObjectForKey:SDLNameSliderFooter];
    }
}

- (NSMutableArray<NSString *> *)sliderFooter {
    return [parameters objectForKey:SDLNameSliderFooter];
}

- (void)setTimeout:(NSNumber *)timeout {
    if (timeout != nil) {
        [parameters setObject:timeout forKey:SDLNameTimeout];
    } else {
        [parameters removeObjectForKey:SDLNameTimeout];
    }
}

- (NSNumber *)timeout {
    return [parameters objectForKey:SDLNameTimeout];
}

@end
