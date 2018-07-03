//  SDLSetMediaClockTimer.m
//


#import "SDLSetMediaClockTimer.h"

#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"
#import "SDLStartTime.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLSetMediaClockTimer

- (instancetype)init {
    if (self = [super initWithName:SDLNameSetMediaClockTimer]) {
    }
    return self;
}

- (instancetype)initWithUpdateMode:(SDLUpdateMode)updateMode hours:(UInt8)hours minutes:(UInt8)minutes seconds:(UInt8)seconds {
    SDLStartTime *startTime = [[SDLStartTime alloc] initWithHours:hours minutes:minutes seconds:seconds];

    return [self initWithUpdateMode:updateMode startTime:startTime endTime:nil enableSeek:nil];
}

- (instancetype)initWithUpdateMode:(SDLUpdateMode)updateMode {
    return [self initWithUpdateMode:updateMode startTime:nil endTime:nil enableSeek:nil];
}

- (instancetype)initWithUpdateMode:(SDLUpdateMode)updateMode startTime:(nullable SDLStartTime *)startTime endTime:(nullable SDLStartTime *)endTime enableSeek:(nullable NSNumber<SDLBool> *)enableSeek {
    self = [self init];
    if (!self) { return nil; }

    self.updateMode = updateMode;
    self.startTime = startTime;
    self.endTime = endTime;
    self.enableSeek = enableSeek;

    return self;
}

- (instancetype)initWithCountUpFromStartTime:(SDLStartTime *)startTime toEndTime:(SDLStartTime *)endTime enableSeekHandle:(BOOL)enableSeek {
    return [self initWithUpdateMode:SDLUpdateModeCountUp startTime:startTime endTime:endTime enableSeek:@(enableSeek)];
}

- (instancetype)initWithCountDownFromStartTime:(SDLStartTime *)startTime toEndTime:(SDLStartTime *)endTime enableSeekHandle:(BOOL)enableSeek {
    return [self initWithUpdateMode:SDLUpdateModeCountDown startTime:startTime endTime:endTime enableSeek:@(enableSeek)];
}

- (instancetype)initWithClear {
    return [self initWithUpdateMode:SDLUpdateModeClear startTime:nil endTime:nil enableSeek:nil];
}

- (instancetype)initWithResume {
    return [self initWithUpdateMode:SDLUpdateModeResume startTime:nil endTime:nil enableSeek:nil];
}

- (instancetype)initWithPause {
    return [self initWithUpdateMode:SDLUpdateModePause startTime:nil endTime:nil enableSeek:nil];
}

- (instancetype)initWithPauseAndUpdateStartTime:(nullable SDLStartTime *)startTime endTime:(nullable SDLStartTime *)endTime enableSeekHandle:(BOOL)enableSeek {
    return [self initWithUpdateMode:SDLUpdateModePause startTime:startTime endTime:endTime enableSeek:@(enableSeek)];
}

- (void)setStartTime:(nullable SDLStartTime *)startTime {
    [parameters sdl_setObject:startTime forName:SDLNameStartTime];
}

- (nullable SDLStartTime *)startTime {
    return [parameters sdl_objectForName:SDLNameStartTime ofClass:SDLStartTime.class];
}

- (void)setEndTime:(nullable SDLStartTime *)endTime {
    [parameters sdl_setObject:endTime forName:SDLNameEndTime];
}

- (nullable SDLStartTime *)endTime {
    return [parameters sdl_objectForName:SDLNameEndTime ofClass:SDLStartTime.class];
}

- (void)setUpdateMode:(SDLUpdateMode)updateMode {
    [parameters sdl_setObject:updateMode forName:SDLNameUpdateMode];
}

- (SDLUpdateMode)updateMode {
    return [parameters sdl_objectForName:SDLNameUpdateMode];
}

- (void)setEnableSeek:(nullable NSNumber<SDLBool> *)enableSeek {
    [parameters sdl_setObject:enableSeek forName:SDLNameEnableSeek];
}

- (nullable NSNumber<SDLBool> *)enableSeek {
    return [parameters sdl_objectForName:SDLNameEnableSeek];
}

@end

NS_ASSUME_NONNULL_END
