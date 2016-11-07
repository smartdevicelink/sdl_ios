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

- (void)setNumTicks:(NSNumber<SDLInt> *)numTicks {
    [self setObject:numTicks forName:SDLNameNumberTicks];
}

- (NSNumber<SDLInt> *)numTicks {
    return [parameters objectForKey:SDLNameNumberTicks];
}

- (void)setPosition:(NSNumber<SDLInt> *)position {
    [self setObject:position forName:SDLNamePosition];
}

- (NSNumber<SDLInt> *)position {
    return [parameters objectForKey:SDLNamePosition];
}

- (void)setSliderHeader:(NSString *)sliderHeader {
    [self setObject:sliderHeader forName:SDLNameSliderHeader];
}

- (NSString *)sliderHeader {
    return [parameters objectForKey:SDLNameSliderHeader];
}

- (void)setSliderFooter:(NSMutableArray<NSString *> *)sliderFooter {
    [self setObject:sliderFooter forName:SDLNameSliderFooter];
}

- (NSMutableArray<NSString *> *)sliderFooter {
    return [parameters objectForKey:SDLNameSliderFooter];
}

- (void)setTimeout:(NSNumber<SDLInt> *)timeout {
    [self setObject:timeout forName:SDLNameTimeout];
}

- (NSNumber<SDLInt> *)timeout {
    return [parameters objectForKey:SDLNameTimeout];
}

@end
