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

- (void)setMillisecond:(nullable NSNumber<SDLInt> *)millisecond {
    if (millisecond != nil) {
        store[SDLNameMillisecond] = millisecond;
    } else {
        [store removeObjectForKey:SDLNameMillisecond];
    }
}

- (nullable NSNumber<SDLInt> *)millisecond {
    return store[SDLNameMillisecond];
}

- (void)setSecond:(nullable NSNumber<SDLInt> *)second {
    if (second != nil) {
        store[SDLNameSecond] = second;
    } else {
        [store removeObjectForKey:SDLNameSecond];
    }
}

- (nullable NSNumber<SDLInt> *)second {
    return store[SDLNameSecond];
}

- (void)setMinute:(nullable NSNumber<SDLInt> *)minute {
    if (minute != nil) {
        store[SDLNameMinute] = minute;
    } else {
        [store removeObjectForKey:SDLNameMinute];
    }
}

- (nullable NSNumber<SDLInt> *)minute {
    return store[SDLNameMinute];
}

- (void)setHour:(nullable NSNumber<SDLInt> *)hour {
    if (hour != nil) {
        store[SDLNameHour] = hour;
    } else {
        [store removeObjectForKey:SDLNameHour];
    }
}

- (nullable NSNumber<SDLInt> *)hour {
    return store[SDLNameHour];
}

- (void)setDay:(nullable NSNumber<SDLInt> *)day {
    if (day != nil) {
        store[SDLNameDay] = day;
    } else {
        [store removeObjectForKey:SDLNameDay];
    }
}

- (nullable NSNumber<SDLInt> *)day {
    return store[SDLNameDay];
}

- (void)setMonth:(nullable NSNumber<SDLInt> *)month {
    if (month != nil) {
        store[SDLNameMonth] = month;
    } else {
        [store removeObjectForKey:SDLNameMonth];
    }
}

- (nullable NSNumber<SDLInt> *)month {
    return store[SDLNameMonth];
}

- (void)setYear:(nullable NSNumber<SDLInt> *)year {
    if (year != nil) {
        store[SDLNameYear] = year;
    } else {
        [store removeObjectForKey:SDLNameYear];
    }
}

- (nullable NSNumber<SDLInt> *)year {
    return store[SDLNameYear];
}

- (void)setTimezoneMinuteOffset:(nullable NSNumber<SDLInt> *)timezoneMinuteOffset {
    if (timezoneMinuteOffset != nil) {
        store[SDLNameTimezoneMinuteOffset] = timezoneMinuteOffset;
    } else {
        [store removeObjectForKey:SDLNameTimezoneMinuteOffset];
    }
}

- (nullable NSNumber<SDLInt> *)timezoneMinuteOffset {
    return store[SDLNameTimezoneMinuteOffset];
}

- (void)setTimezoneHourOffset:(nullable NSNumber<SDLInt> *)timezoneHourOffset {
    if (timezoneHourOffset != nil) {
        store[SDLNameTimezoneHourOffset] = timezoneHourOffset;
    } else {
        [store removeObjectForKey:SDLNameTimezoneHourOffset];
    }
}

- (nullable NSNumber<SDLInt> *)timezoneHourOffset {
    return store[SDLNameTimezoneHourOffset];
}

@end
