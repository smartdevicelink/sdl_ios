//
//  SDLTimer.h
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SDLTimer : NSObject

/// A block called when the timer elapses
@property (copy, nonatomic, nullable) void (^elapsedBlock)(void);

/// A block called when the timer is cancelled
@property (copy, nonatomic, nullable) void (^canceledBlock)(void);

/// The time between calling `start` and when the elapsed block will be called
@property (assign, nonatomic) NSTimeInterval duration;

/// Whether or not the timer is currently running
@property (assign, nonatomic) BOOL timerRunning;

/// Whether or not the timer will repeat after it completes
@property (assign, nonatomic) BOOL repeat;

- (instancetype)init NS_UNAVAILABLE;

/// Initialize a timer with a specified duration on the main run loop without repeating
/// @param duration The duration of the timer. Must not be 0.
- (instancetype)initWithDuration:(NSTimeInterval)duration;

/// Initialize a timer with a specified duration on the passed run loop and optionally repeating
/// @param duration The duration of the timer
/// @param repeat Whether or not the timer should autorepeat
- (instancetype)initWithDuration:(NSTimeInterval)duration repeat:(BOOL)repeat;

/// Starts the timer on the main run loop. When the timer has elapsed, the elapsed block will be called.
- (void)start;

/// Starts the timer on the specified run loop. When the timer has elapsed, the elapsed block will be called.
/// @param runLoop The run loop to start the timer on
- (void)startOnRunLoop:(NSRunLoop *)runLoop;

/// Cancels and invalidates the timer. The canceled block will be called.
- (void)cancel;

@end

NS_ASSUME_NONNULL_END
