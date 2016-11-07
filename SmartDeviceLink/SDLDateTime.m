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
    if (millisecond != nil) {
        store[SDLNameMillisecond] = millisecond;
    } else {
        [store removeObjectForKey:SDLNameMillisecond];
    }
}

- (NSNumber<SDLInt> *)millisecond {
    return [self objectForName:SDLNameMillisecond];
}

- (void)setSecond:(NSNumber<SDLInt> *)second {
    if (second != nil) {
        store[SDLNameSecond] = second;
    } else {
        [store removeObjectForKey:SDLNameSecond];
    }
}

- (NSNumber<SDLInt> *)second {
    return [self objectForName:SDLNameSecond];
}

- (void)setMinute:(NSNumber<SDLInt> *)minute {
    if (minute != nil) {
        store[SDLNameMinute] = minute;
    } else {
        [store removeObjectForKey:SDLNameMinute];
    }
}

- (NSNumber<SDLInt> *)minute {
    return [self objectForName:SDLNameMinute];
}

- (void)setHour:(NSNumber<SDLInt> *)hour {
    if (hour != nil) {
        store[SDLNameHour] = hour;
    } else {
        [store removeObjectForKey:SDLNameHour];
    }
}

- (NSNumber<SDLInt> *)hour {
    return [self objectForName:SDLNameHour];
}

- (void)setDay:(NSNumber<SDLInt> *)day {
    if (day != nil) {
        store[SDLNameDay] = day;
    } else {
        [store removeObjectForKey:SDLNameDay];
    }
}

- (NSNumber<SDLInt> *)day {
    return [self objectForName:SDLNameDay];
}

- (void)setMonth:(NSNumber<SDLInt> *)month {
    if (month != nil) {
        store[SDLNameMonth] = month;
    } else {
        [store removeObjectForKey:SDLNameMonth];
    }
}

- (NSNumber<SDLInt> *)month {
    return [self objectForName:SDLNameMonth];
}

- (void)setYear:(NSNumber<SDLInt> *)year {
    if (year != nil) {
        store[SDLNameYear] = year;
    } else {
        [store removeObjectForKey:SDLNameYear];
    }
}

- (NSNumber<SDLInt> *)year {
    return [self objectForName:SDLNameYear];
}

- (void)setTimezoneMinuteOffset:(NSNumber<SDLInt> *)timezoneMinuteOffset {
    if (timezoneMinuteOffset != nil) {
        store[SDLNameTimezoneMinuteOffset] = timezoneMinuteOffset;
    } else {
        [store removeObjectForKey:SDLNameTimezoneMinuteOffset];
    }
}

- (NSNumber<SDLInt> *)timezoneMinuteOffset {
    return [self objectForName:SDLNameTimezoneMinuteOffset];
}

- (void)setTimezoneHourOffset:(NSNumber<SDLInt> *)timezoneHourOffset {
    if (timezoneHourOffset != nil) {
        store[SDLNameTimezoneHourOffset] = timezoneHourOffset;
    } else {
        [store removeObjectForKey:SDLNameTimezoneHourOffset];
    }
}

- (NSNumber<SDLInt> *)timezoneHourOffset {
    return [self objectForName:SDLNameTimezoneHourOffset];
}

@end
