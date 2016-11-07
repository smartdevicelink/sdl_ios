//  SDLStartTime.m
//


#import "SDLStartTime.h"

#import "SDLNames.h"

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
    [self setObject:hours forName:SDLNameHours];
}

- (NSNumber<SDLInt> *)hours {
    return [self objectForName:SDLNameHours];
}

- (void)setMinutes:(NSNumber<SDLInt> *)minutes {
    [self setObject:minutes forName:SDLNameMinutes];
}

- (NSNumber<SDLInt> *)minutes {
    return [self objectForName:SDLNameMinutes];
}

- (void)setSeconds:(NSNumber<SDLInt> *)seconds {
    [self setObject:seconds forName:SDLNameSeconds];
}

- (NSNumber<SDLInt> *)seconds {
    return [self objectForName:SDLNameSeconds];
}

@end
