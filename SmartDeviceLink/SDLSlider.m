//  SDLSlider.m
//


#import "SDLSlider.h"



@implementation SDLSlider

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

- (void)setNumTicks:(NSNumber *)numTicks {
    if (numTicks != nil) {
        [parameters setObject:numTicks forKey:SDLNameNumTicks];
    } else {
        [parameters removeObjectForKey:SDLNameNumTicks];
    }
}

- (NSNumber *)numTicks {
    return [parameters objectForKey:SDLNameNumTicks];
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

- (void)setSliderFooter:(NSMutableArray *)sliderFooter {
    if (sliderFooter != nil) {
        [parameters setObject:sliderFooter forKey:SDLNameSliderFooter];
    } else {
        [parameters removeObjectForKey:SDLNameSliderFooter];
    }
}

- (NSMutableArray *)sliderFooter {
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
