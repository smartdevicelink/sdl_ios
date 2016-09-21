//  SDLSetMediaClockTimer.m
//


#import "SDLSetMediaClockTimer.h"


#import "SDLStartTime.h"
#import "SDLUpdateMode.h"


@implementation SDLSetMediaClockTimer

- (instancetype)init {
    if (self = [super initWithName:SDLNameSetMediaClockTimer]) {
    }
    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
    }
    return self;
}

- (void)setStartTime:(SDLStartTime *)startTime {
    if (startTime != nil) {
        [parameters setObject:startTime forKey:SDLNameStartTime];
    } else {
        [parameters removeObjectForKey:SDLNameStartTime];
    }
}

- (SDLStartTime *)startTime {
    NSObject *obj = [parameters objectForKey:SDLNameStartTime];
    if (obj == nil || [obj isKindOfClass:SDLStartTime.class]) {
        return (SDLStartTime *)obj;
    } else {
        return [[SDLStartTime alloc] initWithDictionary:(NSMutableDictionary *)obj];
    }
}

- (void)setEndTime:(SDLStartTime *)endTime {
    if (endTime != nil) {
        [parameters setObject:endTime forKey:SDLNameEndTime];
    } else {
        [parameters removeObjectForKey:SDLNameEndTime];
    }
}

- (SDLStartTime *)endTime {
    NSObject *obj = [parameters objectForKey:SDLNameEndTime];
    if (obj == nil || [obj isKindOfClass:SDLStartTime.class]) {
        return (SDLStartTime *)obj;
    } else {
        return [[SDLStartTime alloc] initWithDictionary:(NSMutableDictionary *)obj];
    }
}

- (void)setUpdateMode:(SDLUpdateMode *)updateMode {
    if (updateMode != nil) {
        [parameters setObject:updateMode forKey:SDLNameUpdateMode];
    } else {
        [parameters removeObjectForKey:SDLNameUpdateMode];
    }
}

- (SDLUpdateMode *)updateMode {
    NSObject *obj = [parameters objectForKey:SDLNameUpdateMode];
    if (obj == nil || [obj isKindOfClass:SDLUpdateMode.class]) {
        return (SDLUpdateMode *)obj;
    } else {
        return [SDLUpdateMode valueOf:(NSString *)obj];
    }
}

@end
