//  SDLStartTime.m
//


#import "SDLStartTime.h"

#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLStartTime

- (instancetype)initWithHours:(UInt8)hours minutes:(UInt8)minutes seconds:(UInt8)seconds {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.hours = @(hours);
    self.minutes = @(minutes);
    self.seconds = @(seconds);

    return self;
}

- (void)setHours:(NSNumber<SDLInt> *)hours {
    if (hours != nil) {
        [store setObject:hours forKey:SDLNameHours];
    } else {
        [store removeObjectForKey:SDLNameHours];
    }
}

- (NSNumber<SDLInt> *)hours {
    return [store objectForKey:SDLNameHours];
}

- (void)setMinutes:(NSNumber<SDLInt> *)minutes {
    if (minutes != nil) {
        [store setObject:minutes forKey:SDLNameMinutes];
    } else {
        [store removeObjectForKey:SDLNameMinutes];
    }
}

- (NSNumber<SDLInt> *)minutes {
    return [store objectForKey:SDLNameMinutes];
}

- (void)setSeconds:(NSNumber<SDLInt> *)seconds {
    if (seconds != nil) {
        [store setObject:seconds forKey:SDLNameSeconds];
    } else {
        [store removeObjectForKey:SDLNameSeconds];
    }
}

- (NSNumber<SDLInt> *)seconds {
    return [store objectForKey:SDLNameSeconds];
}

@end

NS_ASSUME_NONNULL_END
