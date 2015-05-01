//
//  SDLTimer.m
//

#import "SDLTimer.h"


@interface SDLTimer ()

@property (strong) NSTimer *timer;
@property (assign) BOOL timerRunning;

@end


@implementation SDLTimer

- (id)init
{
    if (self = [super init]) {
        _duration = 0;
        _timerRunning = NO;
    }
    return self;
}

- (id)initWithDuration:(float)duration
{
    if (self = [super init]) {
        _duration = duration;
        _timerRunning = NO;
    }
    return self;
}

- (void)start
{
    if (self.duration > 0) {
        [self stopAndDestroyTimer];
        self.timer = [NSTimer timerWithTimeInterval:self.duration target:self selector:@selector(timerElapsed) userInfo:nil repeats:NO];
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        self.timerRunning = YES;
    }
}

- (void)cancel
{
    [self stopAndDestroyTimer];
    if (self.timerRunning && self.canceledBlock != nil) {
        self.timerRunning = NO;
        self.canceledBlock();
    }
    self.timerRunning = NO;
}

- (void)timerElapsed
{
    [self stopAndDestroyTimer];
    self.timerRunning = NO;
    if (self.elapsedBlock != nil) {
        self.elapsedBlock();
    }
}

-(void)stopAndDestroyTimer {
    if (self.timer != nil) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

@end
