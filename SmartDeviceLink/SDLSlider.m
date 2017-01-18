//  SDLSlider.m
//


#import "SDLSlider.h"

#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLSlider

- (instancetype)init {
    if (self = [super initWithName:SDLNameSlider]) {
    }
    return self;
}

- (instancetype)initWithNumTicks:(UInt8)numTicks position:(UInt8)position sliderHeader:(NSString *)sliderHeader sliderFooter:(nullable NSString *)sliderFooter timeout:(UInt16)timeout {
    NSMutableArray *sliderFooters = [NSMutableArray arrayWithCapacity:numTicks];

    // Populates array with the same footer value for each position
    for (int i = 0; i < sliderFooters.count; i++) {
        sliderFooters[0] = sliderFooter;
    }

    return [self initWithNumTicks:numTicks position:position sliderHeader:sliderHeader sliderFooter:[sliderFooters copy] timeout:timeout];
}

- (instancetype)initWithNumTicks:(UInt8)numTicks position:(UInt8)position sliderHeader:(NSString *)sliderHeader sliderFooters:(nullable NSArray<NSString *> *)sliderFooters timeout:(UInt16)timeout {
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
    if (numTicks != nil) {
        [parameters setObject:numTicks forKey:SDLNameNumberTicks];
    } else {
        [parameters removeObjectForKey:SDLNameNumberTicks];
    }
}

- (NSNumber<SDLInt> *)numTicks {
    return [parameters objectForKey:SDLNameNumberTicks];
}

- (void)setPosition:(NSNumber<SDLInt> *)position {
    if (position != nil) {
        [parameters setObject:position forKey:SDLNamePosition];
    } else {
        [parameters removeObjectForKey:SDLNamePosition];
    }
}

- (NSNumber<SDLInt> *)position {
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

- (void)setSliderFooter:(nullable NSMutableArray<NSString *> *)sliderFooter {
    if (sliderFooter != nil) {
        [parameters setObject:sliderFooter forKey:SDLNameSliderFooter];
    } else {
        [parameters removeObjectForKey:SDLNameSliderFooter];
    }
}

- (nullable NSMutableArray<NSString *> *)sliderFooter {
    return [parameters objectForKey:SDLNameSliderFooter];
}

- (void)setTimeout:(nullable NSNumber<SDLInt> *)timeout {
    if (timeout != nil) {
        [parameters setObject:timeout forKey:SDLNameTimeout];
    } else {
        [parameters removeObjectForKey:SDLNameTimeout];
    }
}

- (nullable NSNumber<SDLInt> *)timeout {
    return [parameters objectForKey:SDLNameTimeout];
}

@end

NS_ASSUME_NONNULL_END
