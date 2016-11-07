//  SDLDateTime.m
//

#import "SDLDateTime.h"
#import "SDLNames.h"

@implementation SDLDateTime

- (instancetype)initWithHour:(UInt8)hour minute:(UInt8)minute {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.hour = @(hour);
    self.minute = @(minute);

    return self;
}

- (instancetype)initWithHour:(UInt8)hour minute:(UInt8)minute second:(UInt8)second millisecond:(UInt16)millisecond {
    self = [self initWithHour:hour minute:minute];
    if (!self) {
        return nil;
    }

    self.second = @(second);
    self.millisecond = @(millisecond);

    return self;
}

- (instancetype)initWithHour:(UInt8)hour minute:(UInt8)minute second:(UInt8)second millisecond:(UInt16)millisecond day:(UInt8)day month:(UInt8)month year:(UInt16)year {
    self = [self initWithHour:hour minute:minute second:second millisecond:millisecond];
    if (!self) {
        return nil;
    }

    self.day = @(day);
    self.month = @(month);
    self.year = @(year);

    return self;
}


- (instancetype)initWithHour:(UInt8)hour minute:(UInt8)minute second:(UInt8)second millisecond:(UInt16)millisecond day:(UInt8)day month:(UInt8)month year:(UInt16)year timezoneMinuteOffset:(UInt8)timezoneMinuteOffset timezoneHourOffset:(int)timezoneHourOffset {
    self = [self initWithHour:hour minute:minute second:second millisecond:millisecond day:day month:month year:year];
    if (!self) {
        return nil;
    }

    self.timezoneMinuteOffset = @(timezoneMinuteOffset);
    self.timezoneHourOffset = @(timezoneHourOffset);

    return self;
}

- (void)setMillisecond:(NSNumber<SDLInt> *)millisecond {
    [self setObject:millisecond forName:SDLNameMillisecond];
}

- (NSNumber<SDLInt> *)millisecond {
    return [self objectForName:SDLNameMillisecond];
}

- (void)setSecond:(NSNumber<SDLInt> *)second {
    [self setObject:second forName:SDLNameSecond];
}

- (NSNumber<SDLInt> *)second {
    return [self objectForName:SDLNameSecond];
}

- (void)setMinute:(NSNumber<SDLInt> *)minute {
    [self setObject:minute forName:SDLNameMinute];
}

- (NSNumber<SDLInt> *)minute {
    return [self objectForName:SDLNameMinute];
}

- (void)setHour:(NSNumber<SDLInt> *)hour {
    [self setObject:hour forName:SDLNameHour];
}

- (NSNumber<SDLInt> *)hour {
    return [self objectForName:SDLNameHour];
}

- (void)setDay:(NSNumber<SDLInt> *)day {
    [self setObject:day forName:SDLNameDay];
}

- (NSNumber<SDLInt> *)day {
    return [self objectForName:SDLNameDay];
}

- (void)setMonth:(NSNumber<SDLInt> *)month {
    [self setObject:month forName:SDLNameMonth];
}

- (NSNumber<SDLInt> *)month {
    return [self objectForName:SDLNameMonth];
}

- (void)setYear:(NSNumber<SDLInt> *)year {
    [self setObject:year forName:SDLNameYear];
}

- (NSNumber<SDLInt> *)year {
    return [self objectForName:SDLNameYear];
}

- (void)setTimezoneMinuteOffset:(NSNumber<SDLInt> *)timezoneMinuteOffset {
    [self setObject:timezoneMinuteOffset forName:SDLNameTimezoneMinuteOffset];
}

- (NSNumber<SDLInt> *)timezoneMinuteOffset {
    return [self objectForName:SDLNameTimezoneMinuteOffset];
}

- (void)setTimezoneHourOffset:(NSNumber<SDLInt> *)timezoneHourOffset {
    [self setObject:timezoneHourOffset forName:SDLNameTimezoneHourOffset];
}

- (NSNumber<SDLInt> *)timezoneHourOffset {
    return [self objectForName:SDLNameTimezoneHourOffset];
}

@end
