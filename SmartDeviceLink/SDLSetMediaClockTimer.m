//  SDLSetMediaClockTimer.m
//


#import "SDLSetMediaClockTimer.h"

#import "SDLNames.h"
#import "SDLStartTime.h"

NS_ASSUME_NONNULL_BEGIN

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

- (void)setStartTime:(nullable SDLStartTime *)startTime {
    if (startTime != nil) {
        [parameters setObject:startTime forKey:SDLNameStartTime];
    } else {
        [parameters removeObjectForKey:SDLNameStartTime];
    }
}

- (nullable SDLStartTime *)startTime {
    NSObject *obj = [parameters objectForKey:SDLNameStartTime];
    if ([obj isKindOfClass:NSDictionary.class]) {
        return [[SDLStartTime alloc] initWithDictionary:(NSDictionary *)obj];
    }
    
    return (SDLStartTime*)obj;
}

- (void)setEndTime:(nullable SDLStartTime *)endTime {
    if (endTime != nil) {
        [parameters setObject:endTime forKey:SDLNameEndTime];
    } else {
        [parameters removeObjectForKey:SDLNameEndTime];
    }
}

- (nullable SDLStartTime *)endTime {
    NSObject *obj = [parameters objectForKey:SDLNameEndTime];
    if ([obj isKindOfClass:NSDictionary.class]) {
        return [[SDLStartTime alloc] initWithDictionary:(NSDictionary *)obj];
    }
    
    return (SDLStartTime*)obj;
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

NS_ASSUME_NONNULL_END
