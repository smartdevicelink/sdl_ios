//  SDLSetMediaClockTimer.m
//


#import "SDLSetMediaClockTimer.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"
#import "SDLStartTime.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLSetMediaClockTimer

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameSetMediaClockTimer]) {
    }
    return self;
}
#pragma clang diagnostic pop

- (instancetype)initWithUpdateMode:(SDLUpdateMode)updateMode startTime:(nullable SDLStartTime *)startTime endTime:(nullable SDLStartTime *)endTime playPauseIndicator:(nullable SDLAudioStreamingIndicator)playPauseIndicator {
    self = [self init];
    if (!self) { return nil; }

    self.updateMode = updateMode;
    self.startTime = startTime;
    self.endTime = endTime;
    self.audioStreamingIndicator = playPauseIndicator;

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

- (instancetype)initWithUpdateMode:(SDLUpdateMode)updateMode startTime:(nullable SDLStartTime *)startTime endTime:(nullable SDLStartTime *)endTime audioStreamingIndicator:(nullable SDLAudioStreamingIndicator)audioStreamingIndicator forwardSeekIndicator:(nullable SDLSeekStreamingIndicator *)forwardSeekIndicator backSeekIndicator:(nullable SDLSeekStreamingIndicator *)backSeekIndicator {
    self = [self initWithUpdateMode:updateMode];
    if (!self) {
        return nil;
    }
    self.startTime = startTime;
    self.endTime = endTime;
    self.audioStreamingIndicator = audioStreamingIndicator;
    self.forwardSeekIndicator = forwardSeekIndicator;
    self.backSeekIndicator = backSeekIndicator;
    return self;
}

+ (instancetype)countUpFromStartTimeInterval:(NSTimeInterval)startTime toEndTimeInterval:(NSTimeInterval)endTime playPauseIndicator:(nullable SDLAudioStreamingIndicator)playPauseIndicator {
    return [self countUpFromStartTimeInterval:startTime toEndTimeInterval:endTime playPauseIndicator:playPauseIndicator  forwardSeekIndicator:nil backSeekIndicator:nil];
}

+ (instancetype)countUpFromStartTimeInterval:(NSTimeInterval)startTime toEndTimeInterval:(NSTimeInterval)endTime playPauseIndicator:(nullable SDLAudioStreamingIndicator)playPauseIndicator forwardSeekIndicator:(nullable SDLSeekStreamingIndicator *)forwardSeekIndicator backSeekIndicator:(nullable SDLSeekStreamingIndicator *)backSeekIndicator {
    SDLStartTime *startTimeRPC = [[SDLStartTime alloc] initWithTimeInterval:startTime];
    SDLStartTime *endTimeRPC = [[SDLStartTime alloc] initWithTimeInterval:endTime];

    return [[self alloc] initWithUpdateMode:SDLUpdateModeCountUp startTime:startTimeRPC endTime:endTimeRPC audioStreamingIndicator:playPauseIndicator forwardSeekIndicator:forwardSeekIndicator backSeekIndicator:backSeekIndicator];
}

+ (instancetype)countUpFromStartTime:(SDLStartTime *)startTime toEndTime:(SDLStartTime *)endTime playPauseIndicator:(nullable SDLAudioStreamingIndicator)playPauseIndicator {
    return [self countUpFromStartTime:startTime toEndTime:endTime playPauseIndicator:playPauseIndicator forwardSeekIndicator:nil backSeekIndicator:nil];
}

+ (instancetype)countUpFromStartTime:(SDLStartTime *)startTime toEndTime:(SDLStartTime *)endTime playPauseIndicator:(nullable SDLAudioStreamingIndicator)playPauseIndicator forwardSeekIndicator:(nullable SDLSeekStreamingIndicator *)forwardSeekIndicator backSeekIndicator:(nullable SDLSeekStreamingIndicator *)backSeekIndicator {
    return [[self alloc] initWithUpdateMode:SDLUpdateModeCountUp startTime:startTime endTime:endTime audioStreamingIndicator:playPauseIndicator forwardSeekIndicator:forwardSeekIndicator backSeekIndicator:backSeekIndicator];
}

+ (instancetype)countDownFromStartTimeInterval:(NSTimeInterval)startTime toEndTimeInterval:(NSTimeInterval)endTime playPauseIndicator:(nullable SDLAudioStreamingIndicator)playPauseIndicator {
    return [self countDownFromStartTimeInterval:startTime toEndTimeInterval:endTime playPauseIndicator:playPauseIndicator forwardSeekIndicator:nil backSeekIndicator:nil];
}

+ (instancetype)countDownFromStartTimeInterval:(NSTimeInterval)startTime toEndTimeInterval:(NSTimeInterval)endTime playPauseIndicator:(nullable SDLAudioStreamingIndicator)playPauseIndicator forwardSeekIndicator:(nullable SDLSeekStreamingIndicator *)forwardSeekIndicator backSeekIndicator:(nullable SDLSeekStreamingIndicator *)backSeekIndicator {
    SDLStartTime *startTimeRPC = [[SDLStartTime alloc] initWithTimeInterval:startTime];
    SDLStartTime *endTimeRPC = [[SDLStartTime alloc] initWithTimeInterval:endTime];

    return [[self alloc] initWithUpdateMode:SDLUpdateModeCountDown startTime:startTimeRPC endTime:endTimeRPC audioStreamingIndicator:playPauseIndicator forwardSeekIndicator:forwardSeekIndicator backSeekIndicator:backSeekIndicator];
}

+ (instancetype)countDownFromStartTime:(SDLStartTime *)startTime toEndTime:(SDLStartTime *)endTime playPauseIndicator:(nullable SDLAudioStreamingIndicator)playPauseIndicator {
    return [self countDownFromStartTime:startTime toEndTime:endTime playPauseIndicator:playPauseIndicator forwardSeekIndicator:nil backSeekIndicator:nil];
}

+ (instancetype)countDownFromStartTime:(SDLStartTime *)startTime toEndTime:(SDLStartTime *)endTime playPauseIndicator:(nullable SDLAudioStreamingIndicator)playPauseIndicator forwardSeekIndicator:(nullable SDLSeekStreamingIndicator *)forwardSeekIndicator backSeekIndicator:(nullable SDLSeekStreamingIndicator *)backSeekIndicator {
    return [[self alloc] initWithUpdateMode:SDLUpdateModeCountDown startTime:startTime endTime:endTime audioStreamingIndicator:playPauseIndicator forwardSeekIndicator:nil backSeekIndicator:nil];
}

+ (instancetype)pauseWithPlayPauseIndicator:(nullable SDLAudioStreamingIndicator)playPauseIndicator {
    return [[self alloc] initWithUpdateMode:SDLUpdateModePause startTime:nil endTime:nil audioStreamingIndicator:playPauseIndicator forwardSeekIndicator:nil backSeekIndicator:nil];
}

+ (instancetype)updatePauseWithNewStartTimeInterval:(NSTimeInterval)startTime endTimeInterval:(NSTimeInterval)endTime playPauseIndicator:(nullable SDLAudioStreamingIndicator)playPauseIndicator {
    SDLStartTime *startTimeRPC = [[SDLStartTime alloc] initWithTimeInterval:startTime];
    SDLStartTime *endTimeRPC = [[SDLStartTime alloc] initWithTimeInterval:endTime];

    return [[self alloc] initWithUpdateMode:SDLUpdateModePause startTime:startTimeRPC endTime:endTimeRPC audioStreamingIndicator:playPauseIndicator forwardSeekIndicator:nil backSeekIndicator:nil];
}

+ (instancetype)updatePauseWithNewStartTime:(SDLStartTime *)startTime endTime:(SDLStartTime *)endTime playPauseIndicator:(nullable SDLAudioStreamingIndicator)playPauseIndicator {
    return [[self alloc] initWithUpdateMode:SDLUpdateModePause startTime:startTime endTime:endTime audioStreamingIndicator:playPauseIndicator forwardSeekIndicator:nil backSeekIndicator:nil];
}

+ (instancetype)resumeWithPlayPauseIndicator:(nullable SDLAudioStreamingIndicator)playPauseIndicator {
    return [[self alloc] initWithUpdateMode:SDLUpdateModeResume startTime:nil endTime:nil audioStreamingIndicator:playPauseIndicator forwardSeekIndicator:nil backSeekIndicator:nil];
}

+ (instancetype)clearWithPlayPauseIndicator:(nullable SDLAudioStreamingIndicator)playPauseIndicator {
    return [[self alloc] initWithUpdateMode:SDLUpdateModeClear startTime:nil endTime:nil audioStreamingIndicator:playPauseIndicator forwardSeekIndicator:nil backSeekIndicator:nil];
}

- (void)setStartTime:(nullable SDLStartTime *)startTime {
    [self.parameters sdl_setObject:startTime forName:SDLRPCParameterNameStartTime];
}

- (nullable SDLStartTime *)startTime {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameStartTime ofClass:SDLStartTime.class error:nil];
}

- (void)setEndTime:(nullable SDLStartTime *)endTime {
    [self.parameters sdl_setObject:endTime forName:SDLRPCParameterNameEndTime];
}

- (nullable SDLStartTime *)endTime {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameEndTime ofClass:SDLStartTime.class error:nil];
}

- (void)setUpdateMode:(SDLUpdateMode)updateMode {
    [self.parameters sdl_setObject:updateMode forName:SDLRPCParameterNameUpdateMode];
}

- (SDLUpdateMode)updateMode {
    NSError *error = nil;
    return [self.parameters sdl_enumForName:SDLRPCParameterNameUpdateMode error:&error];
}

- (void)setAudioStreamingIndicator:(nullable SDLAudioStreamingIndicator)audioStreamingIndicator {
    [self.parameters sdl_setObject:audioStreamingIndicator forName:SDLRPCParameterNameAudioStreamingIndicator];
}

- (nullable SDLAudioStreamingIndicator)audioStreamingIndicator {
    return [self.parameters sdl_enumForName:SDLRPCParameterNameAudioStreamingIndicator error:nil];
}

- (void)setForwardSeekIndicator:(nullable SDLSeekStreamingIndicator *)forwardSeekIndicator {
    [self.parameters sdl_setObject:forwardSeekIndicator forName:SDLRPCParameterNameForwardSeekIndicator];
}

- (nullable SDLSeekStreamingIndicator *)forwardSeekIndicator {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameForwardSeekIndicator ofClass:SDLSeekStreamingIndicator.class error:nil];
}

- (void)setBackSeekIndicator:(nullable SDLSeekStreamingIndicator *)backSeekIndicator {
    [self.parameters sdl_setObject:backSeekIndicator forName:SDLRPCParameterNameBackSeekIndicator];
}

- (nullable SDLSeekStreamingIndicator *)backSeekIndicator {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameBackSeekIndicator ofClass:SDLSeekStreamingIndicator.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
