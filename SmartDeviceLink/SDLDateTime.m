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
        store[NAMES_millisecond] = millisecond;
    } else {
        [store removeObjectForKey:NAMES_millisecond];
    }
}

- (NSNumber<SDLInt> *)millisecond {
    return store[NAMES_millisecond];
}

- (void)setSecond:(NSNumber<SDLInt> *)second {
    if (second != nil) {
        store[NAMES_second] = second;
    } else {
        [store removeObjectForKey:NAMES_second];
    }
}

- (NSNumber<SDLInt> *)second {
    return store[NAMES_second];
}

- (void)setMinute:(NSNumber<SDLInt> *)minute {
    if (minute != nil) {
        store[NAMES_minute] = minute;
    } else {
        [store removeObjectForKey:NAMES_minute];
    }
}

- (NSNumber<SDLInt> *)minute {
    return store[NAMES_minute];
}

- (void)setHour:(NSNumber<SDLInt> *)hour {
    if (hour != nil) {
        store[NAMES_hour] = hour;
    } else {
        [store removeObjectForKey:NAMES_hour];
    }
}

- (NSNumber<SDLInt> *)hour {
    return store[NAMES_hour];
}

- (void)setDay:(NSNumber<SDLInt> *)day {
    if (day != nil) {
        store[NAMES_day] = day;
    } else {
        [store removeObjectForKey:NAMES_day];
    }
}

- (NSNumber<SDLInt> *)day {
    return store[NAMES_day];
}

- (void)setMonth:(NSNumber<SDLInt> *)month {
    if (month != nil) {
        store[NAMES_month] = month;
    } else {
        [store removeObjectForKey:NAMES_month];
    }
}

- (NSNumber<SDLInt> *)month {
    return store[NAMES_month];
}

- (void)setYear:(NSNumber<SDLInt> *)year {
    if (year != nil) {
        store[NAMES_year] = year;
    } else {
        [store removeObjectForKey:NAMES_year];
    }
}

- (NSNumber<SDLInt> *)year {
    return store[NAMES_year];
}

- (void)setTimezoneMinuteOffset:(NSNumber<SDLInt> *)timezoneMinuteOffset {
    if (timezoneMinuteOffset != nil) {
        store[NAMES_timezoneMinuteOffset] = timezoneMinuteOffset;
    } else {
        [store removeObjectForKey:NAMES_timezoneMinuteOffset];
    }
}

- (NSNumber<SDLInt> *)timezoneMinuteOffset {
    return store[NAMES_timezoneMinuteOffset];
}

- (void)setTimezoneHourOffset:(NSNumber<SDLInt> *)timezoneHourOffset {
    if (timezoneHourOffset != nil) {
        store[NAMES_timezoneHourOffset] = timezoneHourOffset;
    } else {
        [store removeObjectForKey:NAMES_timezoneHourOffset];
    }
}

- (NSNumber<SDLInt> *)timezoneHourOffset {
    return store[NAMES_timezoneHourOffset];
}

@end
