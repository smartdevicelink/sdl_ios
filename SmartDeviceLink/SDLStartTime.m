//  SDLStartTime.m
//


#import "SDLStartTime.h"

#import "SDLNames.h"

@implementation SDLStartTime

- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
    }
    return self;
}

- (instancetype)initWithHours:(NSInteger)hours minutes:(NSInteger)minutes seconds:(NSInteger)seconds {
    if (self = [super init]) {
        self.hours = @(hours);
        self.minutes = @(minutes);
        self.seconds = @(seconds);
    }
    return self;
}

- (void)setHours:(NSNumber *)hours {
    if (hours != nil) {
        [store setObject:hours forKey:NAMES_hours];
    } else {
        [store removeObjectForKey:NAMES_hours];
    }
}

- (NSNumber *)hours {
    return [store objectForKey:NAMES_hours];
}

- (void)setMinutes:(NSNumber *)minutes {
    if (minutes != nil) {
        [store setObject:minutes forKey:NAMES_minutes];
    } else {
        [store removeObjectForKey:NAMES_minutes];
    }
}

- (NSNumber *)minutes {
    return [store objectForKey:NAMES_minutes];
}

- (void)setSeconds:(NSNumber *)seconds {
    if (seconds != nil) {
        [store setObject:seconds forKey:NAMES_seconds];
    } else {
        [store removeObjectForKey:NAMES_seconds];
    }
}

- (NSNumber *)seconds {
    return [store objectForKey:NAMES_seconds];
}

@end
