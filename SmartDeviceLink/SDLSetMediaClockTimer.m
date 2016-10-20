//  SDLSetMediaClockTimer.m
//


#import "SDLSetMediaClockTimer.h"

#import "SDLNames.h"
#import "SDLStartTime.h"

@implementation SDLSetMediaClockTimer

- (instancetype)init {
    if (self = [super initWithName:SDLNameSetMediaClockTimer]) {
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
        return [[SDLStartTime alloc] initWithDictionary:(NSDictionary *)obj];
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
        return [[SDLStartTime alloc] initWithDictionary:(NSDictionary *)obj];
    }
}

- (void)setUpdateMode:(SDLUpdateMode)updateMode {
    if (updateMode != nil) {
        [parameters setObject:updateMode forKey:SDLNameUpdateMode];
    } else {
        [parameters removeObjectForKey:SDLNameUpdateMode];
    }
}

- (SDLUpdateMode)updateMode {
    NSObject *obj = [parameters objectForKey:SDLNameUpdateMode];
    return (SDLUpdateMode)obj;
}

@end
