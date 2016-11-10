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
    [parameters sdl_setObject:numTicks forName:SDLNameNumberTicks];
}

- (NSNumber<SDLInt> *)numTicks {
    return [parameters sdl_objectForName:SDLNameNumberTicks];
}

- (void)setPosition:(NSNumber<SDLInt> *)position {
    [parameters sdl_setObject:position forName:SDLNamePosition];
}

- (NSNumber<SDLInt> *)position {
    return [parameters sdl_objectForName:SDLNamePosition];
}

- (void)setSliderHeader:(NSString *)sliderHeader {
    [parameters sdl_setObject:sliderHeader forName:SDLNameSliderHeader];
}

- (NSString *)sliderHeader {
    return [parameters sdl_objectForName:SDLNameSliderHeader];
}

- (void)setSliderFooter:(NSMutableArray<NSString *> *)sliderFooter {
    [parameters sdl_setObject:sliderFooter forName:SDLNameSliderFooter];
}

- (NSMutableArray<NSString *> *)sliderFooter {
    return [parameters sdl_objectForName:SDLNameSliderFooter];
}

- (void)setTimeout:(NSNumber<SDLInt> *)timeout {
    [parameters sdl_setObject:timeout forName:SDLNameTimeout];
}

- (NSNumber<SDLInt> *)timeout {
    return [parameters sdl_objectForName:SDLNameTimeout];
}

@end
