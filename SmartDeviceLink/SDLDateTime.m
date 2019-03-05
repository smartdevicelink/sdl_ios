//  SDLDateTime.m
//

#import "SDLDateTime.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"

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
    [store sdl_setObject:millisecond forName:SDLRPCParameterNameMillisecond];
}

- (NSNumber<SDLInt> *)millisecond {
    return [store sdl_objectForName:SDLRPCParameterNameMillisecond];
}

- (void)setSecond:(NSNumber<SDLInt> *)second {
    [store sdl_setObject:second forName:SDLRPCParameterNameSecond];
}

- (NSNumber<SDLInt> *)second {
    return [store sdl_objectForName:SDLRPCParameterNameSecond];
}

- (void)setMinute:(NSNumber<SDLInt> *)minute {
    [store sdl_setObject:minute forName:SDLRPCParameterNameMinute];
}

- (NSNumber<SDLInt> *)minute {
    return [store sdl_objectForName:SDLRPCParameterNameMinute];
}

- (void)setHour:(NSNumber<SDLInt> *)hour {
    [store sdl_setObject:hour forName:SDLRPCParameterNameHour];
}

- (NSNumber<SDLInt> *)hour {
    return [store sdl_objectForName:SDLRPCParameterNameHour];
}

- (void)setDay:(NSNumber<SDLInt> *)day {
    [store sdl_setObject:day forName:SDLRPCParameterNameDay];
}

- (NSNumber<SDLInt> *)day {
    return [store sdl_objectForName:SDLRPCParameterNameDay];
}

- (void)setMonth:(NSNumber<SDLInt> *)month {
    [store sdl_setObject:month forName:SDLRPCParameterNameMonth];
}

- (NSNumber<SDLInt> *)month {
    return [store sdl_objectForName:SDLRPCParameterNameMonth];
}

- (void)setYear:(NSNumber<SDLInt> *)year {
    [store sdl_setObject:year forName:SDLRPCParameterNameYear];
}

- (NSNumber<SDLInt> *)year {
    return [store sdl_objectForName:SDLRPCParameterNameYear];
}

- (void)setTimezoneMinuteOffset:(NSNumber<SDLInt> *)timezoneMinuteOffset {
    [store sdl_setObject:timezoneMinuteOffset forName:SDLRPCParameterNameTimezoneMinuteOffset];
}

- (NSNumber<SDLInt> *)timezoneMinuteOffset {
    return [store sdl_objectForName:SDLRPCParameterNameTimezoneMinuteOffset];
}

- (void)setTimezoneHourOffset:(NSNumber<SDLInt> *)timezoneHourOffset {
    [store sdl_setObject:timezoneHourOffset forName:SDLRPCParameterNameTimezoneHourOffset];
}

- (NSNumber<SDLInt> *)timezoneHourOffset {
    return [store sdl_objectForName:SDLRPCParameterNameTimezoneHourOffset];
}

@end
