//  SDLSetMediaClockTimer.m
//


#import "SDLSetMediaClockTimer.h"

#import "SDLNames.h"
#import "SDLStartTime.h"
#import "SDLUpdateMode.h"


@implementation SDLSetMediaClockTimer

- (instancetype)init {
    if (self = [super initWithName:NAMES_SetMediaClockTimer]) {
    }
    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
    }
    return self;
}


- (instancetype)initWithUpdateMode:(SDLUpdateMode *)updateMode hours:(NSInteger)hours minutes:(NSInteger)minutes seconds:(NSInteger)seconds {
    self = [self initWithUpdateMode:updateMode];
    if (!self) {
        return nil;
    }

    self.startTime = [[SDLStartTime alloc] initWithHours:hours minutes:minutes seconds:seconds];

    return self;
}

- (instancetype)initWithUpdateMode:(SDLUpdateMode *)updateMode {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.updateMode = updateMode;

    return self;
}

- (void)setStartTime:(SDLStartTime *)startTime {
    if (startTime != nil) {
        [parameters setObject:startTime forKey:NAMES_startTime];
    } else {
        [parameters removeObjectForKey:NAMES_startTime];
    }
}

- (SDLStartTime *)startTime {
    NSObject *obj = [parameters objectForKey:NAMES_startTime];
    if (obj == nil || [obj isKindOfClass:SDLStartTime.class]) {
        return (SDLStartTime *)obj;
    } else {
        return [[SDLStartTime alloc] initWithDictionary:(NSMutableDictionary *)obj];
    }
}

- (void)setEndTime:(SDLStartTime *)endTime {
    if (endTime != nil) {
        [parameters setObject:endTime forKey:NAMES_endTime];
    } else {
        [parameters removeObjectForKey:NAMES_endTime];
    }
}

- (SDLStartTime *)endTime {
    NSObject *obj = [parameters objectForKey:NAMES_endTime];
    if (obj == nil || [obj isKindOfClass:SDLStartTime.class]) {
        return (SDLStartTime *)obj;
    } else {
        return [[SDLStartTime alloc] initWithDictionary:(NSMutableDictionary *)obj];
    }
}

- (void)setUpdateMode:(SDLUpdateMode *)updateMode {
    if (updateMode != nil) {
        [parameters setObject:updateMode forKey:NAMES_updateMode];
    } else {
        [parameters removeObjectForKey:NAMES_updateMode];
    }
}

- (SDLUpdateMode *)updateMode {
    NSObject *obj = [parameters objectForKey:NAMES_updateMode];
    if (obj == nil || [obj isKindOfClass:SDLUpdateMode.class]) {
        return (SDLUpdateMode *)obj;
    } else {
        return [SDLUpdateMode valueOf:(NSString *)obj];
    }
}

@end
