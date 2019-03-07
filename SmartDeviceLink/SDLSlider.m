//  SDLSlider.m
//


#import "SDLSlider.h"

#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLSlider

- (instancetype)init {
    if (self = [super initWithName:SDLNameSlider]) {
    }
    return self;
}

- (instancetype)initWithNumTicks:(UInt8)numTicks position:(UInt8)position sliderHeader:(NSString *)sliderHeader sliderFooter:(nullable NSString *)sliderFooter timeout:(UInt16)timeout {
    NSArray<NSString *> *footer = nil;
    if (sliderFooter != nil) {
        footer = @[sliderFooter];
    }

    return [self initWithNumTicks:numTicks position:position sliderHeader:sliderHeader sliderFooters:footer timeout:timeout];
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
    [parameters sdl_setObject:numTicks forName:SDLNameNumberTicks];
}

- (NSNumber<SDLInt> *)numTicks {
    NSError *error;
    return [parameters sdl_objectForName:SDLNameNumberTicks ofClass:NSNumber.class error:&error];
}

- (void)setPosition:(NSNumber<SDLInt> *)position {
    [parameters sdl_setObject:position forName:SDLNamePosition];
}

- (NSNumber<SDLInt> *)position {
    NSError *error;
    return [parameters sdl_objectForName:SDLNamePosition ofClass:NSNumber.class error:&error];
}

- (void)setSliderHeader:(NSString *)sliderHeader {
    [parameters sdl_setObject:sliderHeader forName:SDLNameSliderHeader];
}

- (NSString *)sliderHeader {
    NSError *error;
    return [parameters sdl_objectForName:SDLNameSliderHeader ofClass:NSString.class error:&error];
}

- (void)setSliderFooter:(nullable NSArray<NSString *> *)sliderFooter {
    [parameters sdl_setObject:sliderFooter forName:SDLNameSliderFooter];
}

- (nullable NSArray<NSString *> *)sliderFooter {
    return [parameters sdl_objectsForName:SDLNameSliderFooter ofClass:NSString.class];
}

- (void)setTimeout:(nullable NSNumber<SDLInt> *)timeout {
    [parameters sdl_setObject:timeout forName:SDLNameTimeout];
}

- (nullable NSNumber<SDLInt> *)timeout {
    return [parameters sdl_objectForName:SDLNameTimeout ofClass:NSNumber.class];
}

@end

NS_ASSUME_NONNULL_END
