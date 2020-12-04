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
    [self.store sdl_setObject:millisecond forName:SDLRPCParameterNameMillisecond];
}

- (NSNumber<SDLInt> *)millisecond {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNameMillisecond ofClass:NSNumber.class error:&error];
}

- (void)setSecond:(NSNumber<SDLInt> *)second {
    [self.store sdl_setObject:second forName:SDLRPCParameterNameSecond];
}

- (NSNumber<SDLInt> *)second {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNameSecond ofClass:NSNumber.class error:&error];
}

- (void)setMinute:(NSNumber<SDLInt> *)minute {
    [self.store sdl_setObject:minute forName:SDLRPCParameterNameMinute];
}

- (NSNumber<SDLInt> *)minute {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNameMinute ofClass:NSNumber.class error:&error];
}

- (void)setHour:(NSNumber<SDLInt> *)hour {
    [self.store sdl_setObject:hour forName:SDLRPCParameterNameHour];
}

- (NSNumber<SDLInt> *)hour {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNameHour ofClass:NSNumber.class error:&error];
}

- (void)setDay:(NSNumber<SDLInt> *)day {
    [self.store sdl_setObject:day forName:SDLRPCParameterNameDay];
}

- (NSNumber<SDLInt> *)day {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNameDay ofClass:NSNumber.class error:&error];
}

- (void)setMonth:(NSNumber<SDLInt> *)month {
    [self.store sdl_setObject:month forName:SDLRPCParameterNameMonth];
}

- (NSNumber<SDLInt> *)month {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNameMonth ofClass:NSNumber.class error:&error];
}

- (void)setYear:(NSNumber<SDLInt> *)year {
    [self.store sdl_setObject:year forName:SDLRPCParameterNameYear];
}

- (NSNumber<SDLInt> *)year {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNameYear ofClass:NSNumber.class error:&error];
}

- (void)setTimezoneMinuteOffset:(NSNumber<SDLInt> *)timezoneMinuteOffset {
    [self.store sdl_setObject:timezoneMinuteOffset forName:SDLRPCParameterNameTimezoneMinuteOffset];
}

- (NSNumber<SDLInt> *)timezoneMinuteOffset {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNameTimezoneMinuteOffset ofClass:NSNumber.class error:&error];
}

- (void)setTimezoneHourOffset:(NSNumber<SDLInt> *)timezoneHourOffset {
    [self.store sdl_setObject:timezoneHourOffset forName:SDLRPCParameterNameTimezoneHourOffset];
}

- (NSNumber<SDLInt> *)timezoneHourOffset {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNameTimezoneHourOffset ofClass:NSNumber.class error:&error];
}

@end
