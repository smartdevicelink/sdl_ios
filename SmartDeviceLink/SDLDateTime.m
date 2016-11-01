//  SDLDateTime.m
//

#import "SDLDateTime.h"
#import "SDLNames.h"

@implementation SDLDateTime

- (instancetype)initWithHour:(UInt8)hour minute:(UInt8)minute second:(UInt8)second millisecond:(UInt16)millisecond day:(UInt8)day month:(UInt8)month year:(UInt16)year timezoneMinuteOffset:(UInt8)timezoneMinuteOffset timezoneHourOffset:(int)timezoneHourOffset {
    self = [self init];
    if (!self) {
        return nil;
    }
    
    self.hour = @(hour);
    self.minute = @(minute);
    self.second = @(second);
    self.millisecond = @(millisecond);
    self.day = @(day);
    self.month = @(month);
    self.year = @(year);
    self.timezoneMinuteOffset = @(timezoneMinuteOffset);
    self.timezoneHourOffset = @(timezoneHourOffset);
    
    return self;
}

- (void)setMillisecond:(NSNumber *)millisecond {
    if (millisecond != nil) {
        store[NAMES_millisecond] = millisecond;
    } else {
        [store removeObjectForKey:NAMES_millisecond];
    }
}

- (NSNumber *)millisecond {
    return store[NAMES_millisecond];
}

- (void)setSecond:(NSNumber *)second {
    if (second != nil) {
        store[NAMES_second] = second;
    } else {
        [store removeObjectForKey:NAMES_second];
    }
}

- (NSNumber *)second {
    return store[NAMES_second];
}

- (void)setMinute:(NSNumber *)minute {
    if (minute != nil) {
        store[NAMES_minute] = minute;
    } else {
        [store removeObjectForKey:NAMES_minute];
    }
}

- (NSNumber *)minute {
    return store[NAMES_minute];
}

- (void)setHour:(NSNumber *)hour {
    if (hour != nil) {
        store[NAMES_hour] = hour;
    } else {
        [store removeObjectForKey:NAMES_hour];
    }
}

- (NSNumber *)hour {
    return store[NAMES_hour];
}

- (void)setDay:(NSNumber *)day {
    if (day != nil) {
        store[NAMES_day] = day;
    } else {
        [store removeObjectForKey:NAMES_day];
    }
}

- (NSNumber *)day {
    return store[NAMES_day];
}

- (void)setMonth:(NSNumber *)month {
    if (month != nil) {
        store[NAMES_month] = month;
    } else {
        [store removeObjectForKey:NAMES_month];
    }
}

- (NSNumber *)month {
    return store[NAMES_month];
}

- (void)setYear:(NSNumber *)year {
    if (year != nil) {
        store[NAMES_year] = year;
    } else {
        [store removeObjectForKey:NAMES_year];
    }
}

- (NSNumber *)year {
    return store[NAMES_year];
}

- (void)setTimezoneMinuteOffset:(NSNumber *)timezoneMinuteOffset {
    if (timezoneMinuteOffset != nil) {
        store[NAMES_timezoneMinuteOffset] = timezoneMinuteOffset;
    } else {
        [store removeObjectForKey:NAMES_timezoneMinuteOffset];
    }
}

- (NSNumber *)timezoneMinuteOffset {
    return store[NAMES_timezoneMinuteOffset];
}

- (void)setTimezoneHourOffset:(NSNumber *)timezoneHourOffset {
    if (timezoneHourOffset != nil) {
        store[NAMES_timezoneHourOffset] = timezoneHourOffset;
    } else {
        [store removeObjectForKey:NAMES_timezoneHourOffset];
    }
}

- (NSNumber *)timezoneHourOffset {
    return store[NAMES_timezoneHourOffset];
}

@end
