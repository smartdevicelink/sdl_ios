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

@end

NS_ASSUME_NONNULL_END
