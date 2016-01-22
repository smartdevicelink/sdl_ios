//
//  SDLTimer.m
//

#import "SDLTimer.h"


@interface SDLTimer ()

@property (strong, atomic) dispatch_source_t timer;
@property (assign, atomic) BOOL timerRunning;
@property (assign, nonatomic) BOOL repeat;
@end


@implementation SDLTimer

- (instancetype)init {
    return [self initWithDuration:0 repeat:NO];
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

- (void)dealloc {
    [self cancel];
}

- (void)start {
    if (self.duration > 0) {
        [self sdl_stopAndDestroyTimer];
        
        self.timer = sdl_createDispatchTimer(_duration, 0.05, [self.class sdl_timerQueue], ^{
            [self sdl_timerElapsed];
        });
        
        self.timerRunning = YES;
    }
}

- (void)cancel {
    [self sdl_stopAndDestroyTimer];
    
    if (self.timerRunning && self.canceledBlock != nil) {
        self.timerRunning = NO;
        self.canceledBlock();
    }
    
    self.timerRunning = NO;
}

- (void)sdl_timerElapsed {
    if (self.repeat == NO) {
        [self sdl_stopAndDestroyTimer];
        self.timerRunning = NO;
    }
    
    if (self.elapsedBlock != nil) {
        self.elapsedBlock();
    }
}

- (void)sdl_stopAndDestroyTimer {
    if (self.timer != nil) {
        dispatch_source_cancel(self.timer);
    }
}

// http://stackoverflow.com/a/8403743/1221798
dispatch_source_t sdl_createDispatchTimer(uint64_t interval, uint64_t leeway, dispatch_queue_t queue, dispatch_block_t block) {
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    if (timer != nil) {
        dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), interval * NSEC_PER_SEC, leeway * NSEC_PER_SEC);
        dispatch_source_set_event_handler(timer, block);
        dispatch_resume(timer);
    }
    
    return timer;
}

+ (dispatch_queue_t)sdl_timerQueue {
    static dispatch_queue_t timerQueue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        timerQueue = dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0);
    });
    
    return timerQueue;
}

@end
