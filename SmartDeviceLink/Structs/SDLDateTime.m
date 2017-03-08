//  SDLDateTime.m
//

#import "SDLDateTime.h"

#import "NSMutableDictionary+Store.h"
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
    [store sdl_setObject:millisecond forName:SDLNameMillisecond];
}

- (NSNumber<SDLInt> *)millisecond {
    return [store sdl_objectForName:SDLNameMillisecond];
}

- (void)setSecond:(NSNumber<SDLInt> *)second {
    [store sdl_setObject:second forName:SDLNameSecond];
}

- (NSNumber<SDLInt> *)second {
    return [store sdl_objectForName:SDLNameSecond];
}

- (void)setMinute:(NSNumber<SDLInt> *)minute {
    [store sdl_setObject:minute forName:SDLNameMinute];
}

- (NSNumber<SDLInt> *)minute {
    return [store sdl_objectForName:SDLNameMinute];
}

- (void)setHour:(NSNumber<SDLInt> *)hour {
    [store sdl_setObject:hour forName:SDLNameHour];
}

- (NSNumber<SDLInt> *)hour {
    return [store sdl_objectForName:SDLNameHour];
}

- (void)setDay:(NSNumber<SDLInt> *)day {
    [store sdl_setObject:day forName:SDLNameDay];
}

- (NSNumber<SDLInt> *)day {
    return [store sdl_objectForName:SDLNameDay];
}

- (void)setMonth:(NSNumber<SDLInt> *)month {
    [store sdl_setObject:month forName:SDLNameMonth];
}

- (NSNumber<SDLInt> *)month {
    return [store sdl_objectForName:SDLNameMonth];
}

- (void)setYear:(NSNumber<SDLInt> *)year {
    [store sdl_setObject:year forName:SDLNameYear];
}

- (NSNumber<SDLInt> *)year {
    return [store sdl_objectForName:SDLNameYear];
}

- (void)setTimezoneMinuteOffset:(NSNumber<SDLInt> *)timezoneMinuteOffset {
    [store sdl_setObject:timezoneMinuteOffset forName:SDLNameTimezoneMinuteOffset];
}

- (NSNumber<SDLInt> *)timezoneMinuteOffset {
    return [store sdl_objectForName:SDLNameTimezoneMinuteOffset];
}

- (void)setTimezoneHourOffset:(NSNumber<SDLInt> *)timezoneHourOffset {
    [store sdl_setObject:timezoneHourOffset forName:SDLNameTimezoneHourOffset];
}

- (NSNumber<SDLInt> *)timezoneHourOffset {
    return [store sdl_objectForName:SDLNameTimezoneHourOffset];
}

@end
