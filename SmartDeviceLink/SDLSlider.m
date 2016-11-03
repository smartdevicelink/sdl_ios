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

- (instancetype)initWithNumTicks:(UInt8)numTicks position:(UInt8)position sliderHeader:(NSString *)sliderHeader sliderFooter:(NSString *)sliderFooter timeout:(UInt16)timeout {
    NSMutableArray *sliderFooters = [NSMutableArray arrayWithCapacity:numTicks];

    // Populates array with the same footer value for each position
    for (int i = 0; i < sliderFooters.count; i++) {
        sliderFooters[0] = sliderFooter;
    }

    return [self initWithNumTicks:numTicks position:position sliderHeader:sliderHeader sliderFooter:[sliderFooters copy] timeout:timeout];
}

- (instancetype)initWithNumTicks:(UInt8)numTicks position:(UInt8)position sliderHeader:(NSString *)sliderHeader sliderFooters:(NSArray<NSString *> *)sliderFooters timeout:(UInt16)timeout {
    self = [self initWithNumTicks:numTicks position:position];
    if (!self) {
        return nil;
    }

    self.sliderHeader = sliderHeader;
    self.sliderFooter = [sliderFooters mutableCopy];
    self.timeout = @(timeout);

    return self;
}

- (instancetype)initWithNumTicks:(UInt8)numTicks position:(UInt8)position {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.numTicks = @(numTicks);
    self.position = @(position);

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
