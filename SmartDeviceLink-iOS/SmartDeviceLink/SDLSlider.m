//  SDLSlider.m
//


#import "SDLSlider.h"

#import "SDLNames.h"

@implementation SDLSlider

- (instancetype)init {
    if (self = [super initWithName:NAMES_Slider]) {
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
        [parameters setObject:numTicks forKey:NAMES_numTicks];
    } else {
        [parameters removeObjectForKey:NAMES_numTicks];
    }
}

- (NSNumber *)numTicks {
    return [parameters objectForKey:NAMES_numTicks];
}

- (void)setPosition:(NSNumber *)position {
    if (position != nil) {
        [parameters setObject:position forKey:NAMES_position];
    } else {
        [parameters removeObjectForKey:NAMES_position];
    }
}

- (NSNumber *)position {
    return [parameters objectForKey:NAMES_position];
}

- (void)setSliderHeader:(NSString *)sliderHeader {
    if (sliderHeader != nil) {
        [parameters setObject:sliderHeader forKey:NAMES_sliderHeader];
    } else {
        [parameters removeObjectForKey:NAMES_sliderHeader];
    }
}

- (NSString *)sliderHeader {
    return [parameters objectForKey:NAMES_sliderHeader];
}

- (void)setSliderFooter:(NSMutableArray *)sliderFooter {
    if (sliderFooter != nil) {
        [parameters setObject:sliderFooter forKey:NAMES_sliderFooter];
    } else {
        [parameters removeObjectForKey:NAMES_sliderFooter];
    }
}

- (NSMutableArray *)sliderFooter {
    return [parameters objectForKey:NAMES_sliderFooter];
}

- (void)setTimeout:(NSNumber *)timeout {
    if (timeout != nil) {
        [parameters setObject:timeout forKey:NAMES_timeout];
    } else {
        [parameters removeObjectForKey:NAMES_timeout];
    }
}

- (NSNumber *)timeout {
    return [parameters objectForKey:NAMES_timeout];
}

@end
