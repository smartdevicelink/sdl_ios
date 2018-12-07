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

- (instancetype)initWithUpdateMode:(SDLUpdateMode)updateMode startTime:(nullable SDLStartTime *)startTime endTime:(nullable SDLStartTime *)endTime playPauseIndicator:(nullable SDLAudioStreamingIndicator)playPauseIndicator {
    self = [self init];
    if (!self) { return nil; }

    self.updateMode = updateMode;
    self.startTime = startTime;
    self.endTime = endTime;
    self.audioStreamingIndicator = playPauseIndicator;

    return self;
}

+ (instancetype)countUpFromStartTimeInterval:(NSTimeInterval)startTime toEndTimeInterval:(NSTimeInterval)endTime playPauseIndicator:(nullable SDLAudioStreamingIndicator)playPauseIndicator {
    SDLStartTime *startTimeRPC = [[SDLStartTime alloc] initWithTimeInterval:startTime];
    SDLStartTime *endTimeRPC = [[SDLStartTime alloc] initWithTimeInterval:endTime];

    return [[self alloc] initWithUpdateMode:SDLUpdateModeCountUp startTime:startTimeRPC endTime:endTimeRPC playPauseIndicator:playPauseIndicator];
}

+ (instancetype)countUpFromStartTime:(SDLStartTime *)startTime toEndTime:(SDLStartTime *)endTime playPauseIndicator:(nullable SDLAudioStreamingIndicator)playPauseIndicator {
    return [[self alloc] initWithUpdateMode:SDLUpdateModeCountUp startTime:startTime endTime:endTime playPauseIndicator:playPauseIndicator];
}

+ (instancetype)countDownFromStartTimeInterval:(NSTimeInterval)startTime toEndTimeInterval:(NSTimeInterval)endTime playPauseIndicator:(nullable SDLAudioStreamingIndicator)playPauseIndicator {
    SDLStartTime *startTimeRPC = [[SDLStartTime alloc] initWithTimeInterval:startTime];
    SDLStartTime *endTimeRPC = [[SDLStartTime alloc] initWithTimeInterval:endTime];

    return [[self alloc] initWithUpdateMode:SDLUpdateModeCountDown startTime:startTimeRPC endTime:endTimeRPC playPauseIndicator:playPauseIndicator];
}

+ (instancetype)countDownFromStartTime:(SDLStartTime *)startTime toEndTime:(SDLStartTime *)endTime playPauseIndicator:(nullable SDLAudioStreamingIndicator)playPauseIndicator {
    return [[self alloc] initWithUpdateMode:SDLUpdateModeCountDown startTime:startTime endTime:endTime playPauseIndicator:playPauseIndicator];
}

+ (instancetype)pauseWithPlayPauseIndicator:(nullable SDLAudioStreamingIndicator)playPauseIndicator {
    return [[self alloc] initWithUpdateMode:SDLUpdateModePause startTime:nil endTime:nil playPauseIndicator:playPauseIndicator];
}

+ (instancetype)updatePauseWithNewStartTimeInterval:(NSTimeInterval)startTime endTimeInterval:(NSTimeInterval)endTime playPauseIndicator:(nullable SDLAudioStreamingIndicator)playPauseIndicator {
    SDLStartTime *startTimeRPC = [[SDLStartTime alloc] initWithTimeInterval:startTime];
    SDLStartTime *endTimeRPC = [[SDLStartTime alloc] initWithTimeInterval:endTime];

    return [[self alloc] initWithUpdateMode:SDLUpdateModePause startTime:startTimeRPC endTime:endTimeRPC playPauseIndicator:playPauseIndicator];
}

+ (instancetype)updatePauseWithNewStartTime:(SDLStartTime *)startTime endTime:(SDLStartTime *)endTime playPauseIndicator:(nullable SDLAudioStreamingIndicator)playPauseIndicator {
    return [[self alloc] initWithUpdateMode:SDLUpdateModePause startTime:startTime endTime:endTime playPauseIndicator:playPauseIndicator];
}

+ (instancetype)resumeWithPlayPauseIndicator:(nullable SDLAudioStreamingIndicator)playPauseIndicator {
    return [[self alloc] initWithUpdateMode:SDLUpdateModeResume startTime:nil endTime:nil playPauseIndicator:playPauseIndicator];
}

+ (instancetype)clearWithPlayPauseIndicator:(nullable SDLAudioStreamingIndicator)playPauseIndicator {
    return [[self alloc] initWithUpdateMode:SDLUpdateModeClear startTime:nil endTime:nil playPauseIndicator:playPauseIndicator];
}

- (instancetype)initWithUpdateMode:(SDLUpdateMode)updateMode hours:(UInt8)hours minutes:(UInt8)minutes seconds:(UInt8)seconds audioStreamingIndicator:(SDLAudioStreamingIndicator)audioStreamingIndicator {
    self = [self initWithUpdateMode:updateMode hours:hours minutes:minutes seconds:seconds];
    if (!self) {
        return nil;
    }
    
    self.audioStreamingIndicator = audioStreamingIndicator;
    
    return self;
}

- (instancetype)initWithUpdateMode:(SDLUpdateMode)updateMode hours:(UInt8)hours minutes:(UInt8)minutes seconds:(UInt8)seconds {
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

- (void)setAudioStreamingIndicator:(nullable SDLAudioStreamingIndicator)audioStreamingIndicator {
    [parameters sdl_setObject:audioStreamingIndicator forName:SDLNameAudioStreamingIndicator];
}

- (nullable SDLAudioStreamingIndicator)audioStreamingIndicator {
    return [parameters sdl_objectForName:SDLNameAudioStreamingIndicator];
}

@end

NS_ASSUME_NONNULL_END
