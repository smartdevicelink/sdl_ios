//
//  SDLTimer.m
//

#import "SDLLogMacros.h"
#import "SDLTimer.h"

NS_ASSUME_NONNULL_BEGIN

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

@property (strong, nonatomic, nullable) NSTimer *timer;

@end


@implementation SDLTimer

- (instancetype)initWithDuration:(NSTimeInterval)duration {
    return [self initWithDuration:duration repeat:NO];
}

- (instancetype)initWithDuration:(NSTimeInterval)duration repeat:(BOOL)repeat {
    self = [super init];
    if (!self) { return nil; }

    NSAssert(duration > 0, @"Cannot create a timer with a 0 duration");

    _duration = duration;
    _repeat = repeat;
    _timerRunning = NO;

    return self;
}

- (void)dealloc {
    [self cancel];
}

- (void)start {
    [self startOnRunLoop:[NSRunLoop mainRunLoop]];
}

- (void)startOnRunLoop:(NSRunLoop *)runLoop {
    if (self.duration > 0) {
        [self stopAndDestroyTimer];

        SDLTimerTarget *timerTarget = [[SDLTimerTarget alloc] initWithDelegate:self];
        self.timer = [NSTimer timerWithTimeInterval:self.duration target:timerTarget selector:@selector(timerElapsed) userInfo:nil repeats:_repeat];
        [runLoop addTimer:self.timer forMode:NSRunLoopCommonModes];
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

@end

NS_ASSUME_NONNULL_END
