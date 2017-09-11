//
//  SDLTimer.m
//

#import "SDLTimer.h"

@protocol SDLTimerTargetDelegate <NSObject>

- (void)timerElapsed;

@end

@interface SDLTimerTarget : NSObject

@property (nonatomic, weak) id<SDLTimerTargetDelegate> delegate;

@end

@implementation SDLTimerTarget

- (instancetype)initWithDelegate:(id)delegate {
    self = [super init];
    if (self) {
        _delegate = delegate;
    }
    return self;
}

- (void)timerElapsed {
    if ([self.delegate conformsToProtocol:@protocol(SDLTimerTargetDelegate)]) {
        [_delegate timerElapsed];
    }
}

@end


@interface SDLTimer () <SDLTimerTargetDelegate>

@property (strong) NSTimer *timer;
@property (assign) BOOL timerRunning;
@property (nonatomic) BOOL repeat;
@end


@implementation SDLTimer

- (instancetype)init {
    if (self = [super init]) {
        _duration = 0;
        _timerRunning = NO;
    }
    return self;
}

- (instancetype)initWithDuration:(float)duration {
    return [self initWithDuration:duration repeat:NO];
}

- (instancetype)initWithDuration:(float)duration repeat:(BOOL)repeat {
    self = [super init];
    if (self) {
        _duration = duration;
        _repeat = repeat;
        _timerRunning = NO;
    }
    return self;
}

- (void)start {
    if (self.duration > 0) {
        [self stopAndDestroyTimer];
        
        SDLTimerTarget *timerTarget = [[SDLTimerTarget alloc] initWithDelegate:self];
        self.timer = [NSTimer timerWithTimeInterval:_duration target:timerTarget selector:@selector(timerElapsed) userInfo:nil repeats:_repeat];
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        self.timerRunning = YES;
    }
}

- (void)cancel {
    [self stopAndDestroyTimer];
    if (self.timerRunning && self.canceledBlock != nil) {
        self.timerRunning = NO;
        self.canceledBlock();
    }
    self.timerRunning = NO;
}

- (void)timerElapsed {
    if (self.repeat == NO) {
        [self stopAndDestroyTimer];
        self.timerRunning = NO;
    }
    if (self.elapsedBlock != nil) {
        self.elapsedBlock();
    }
}

- (void)stopAndDestroyTimer {
    if (self.timer != nil) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)dealloc {
    [self cancel];
}

@end
