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


- (instancetype)initWithUpdateMode:(SDLUpdateMode)updateMode hours:(NSInteger)hours minutes:(NSInteger)minutes seconds:(NSInteger)seconds {
    self = [self initWithUpdateMode:updateMode];
    if (!self) {
        return nil;
    }

    self.startTime = [[SDLStartTime alloc] initWithHours:hours minutes:minutes seconds:seconds];

    return self;
}

- (instancetype)initWithUpdateMode:(SDLUpdateMode)updateMode {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.updateMode = updateMode;

    return self;
}

- (void)setStartTime:(SDLStartTime *)startTime {
    [self setObject:startTime forName:SDLNameStartTime];
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
    [self setObject:endTime forName:SDLNameEndTime];
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
    [self setObject:updateMode forName:SDLNameUpdateMode];
}

- (SDLUpdateMode)updateMode {
    NSObject *obj = [parameters objectForKey:SDLNameUpdateMode];
    return (SDLUpdateMode)obj;
}

@end
