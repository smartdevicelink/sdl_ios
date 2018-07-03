//  SDLSetMediaClockTimer.h
//

#import "SDLRPCRequest.h"

#import "SDLUpdateMode.h"

@class SDLStartTime;

/**
 * Sets the media clock/timer value and the update method (e.g.count-up,
 * count-down, etc.)
 * <p>
 * Function Group: Base <p>
 * <b>HMILevel needs to be FULL, LIMITIED or BACKGROUND</b>
 * </p>
 *
 * Since SmartDeviceLink 1.0
 */

NS_ASSUME_NONNULL_BEGIN

@interface SDLSetMediaClockTimer : SDLRPCRequest

- (instancetype)initWithUpdateMode:(SDLUpdateMode)updateMode hours:(UInt8)hours minutes:(UInt8)minutes seconds:(UInt8)seconds __deprecated_msg(("Use a more specific initializer instead"));

- (instancetype)initWithUpdateMode:(SDLUpdateMode)updateMode __deprecated_msg(("Use a more specific initializer instead"));

/**
 Initializer for SetMediaClockTimer with all available parameters

 @param updateMode The type of update to the clock timer
 @param startTime The starting time of the countdown or countup.
 @param endTime The ending time of the countdown or countup
 @param enableSeek Whether or not to enable seeking on the timer bar
 @return The request
 */
- (instancetype)initWithUpdateMode:(SDLUpdateMode)updateMode startTime:(nullable SDLStartTime *)startTime endTime:(nullable SDLStartTime *)endTime enableSeek:(nullable NSNumber<SDLBool> *)enableSeek;

/**
 Start a count up (e.g. a song time bar) with a start time (e.g. 0:00) and an end time (e.g. 3:50)

 @param startTime The bottom of the counter. Must be less than endTime.
 @param endTime The top of the counter. Must be greater than startTime.
 @param enableSeek Whether or not to enable a seek handle on the progress bar.
 @return The request
 */
- (instancetype)initWithCountUpFromStartTime:(SDLStartTime *)startTime toEndTime:(SDLStartTime *)endTime enableSeekHandle:(BOOL)enableSeek;

/**
 Start a count down (e.g. a timer) with a start time (e.g. 30:00) and an end time (e.g. 0:00)

 @param startTime The starting time of the countdown. Must be greater than endTime.
 @param endTime The ending time of the countdown. Must be less than startTime.
 @param enableSeek Whether or not to enable a seek handle on the progress bar.
 @return The request
 */
- (instancetype)initWithCountDownFromStartTime:(SDLStartTime *)startTime toEndTime:(SDLStartTime *)endTime enableSeekHandle:(BOOL)enableSeek;

/**
 Resume a previously paused clock timer

 @return The request
 */
- (instancetype)initWithResume;

/**
 Clear a previously enabled clock timer

 @return The request
 */
- (instancetype)initWithClear;

/**
 Pause a previously started clock timer

 @return The request
 */
- (instancetype)initWithPause;

/**
 Pause and update a running timer, or update a paused timer.

 @param startTime The new start time
 @param endTime The new end time
 @param enableSeek Whether or not to enable the seek bar
 @return The request
 */
- (instancetype)initWithPauseAndUpdateStartTime:(nullable SDLStartTime *)startTime endTime:(nullable SDLStartTime *)endTime enableSeekHandle:(BOOL)enableSeek;

/**
 Start Time with specifying hour, minute, second values

 startTime must be provided for "COUNTUP" and "COUNTDOWN"

 startTime will be ignored for "RESUME", and "CLEAR"

 startTime can be sent for "PAUSE", in which case it will update the paused startTime
 */
@property (strong, nonatomic, nullable) SDLStartTime *startTime;

/**
 An END time of type SDLStartTime, specifying hour, minute, second values

 endTime can be provided for "COUNTUP" and "COUNTDOWN"

 To be used to calculate a visual progress bar (if not provided, this feature is ignored)

 If endTime is greater then startTime for COUNTDOWN or less than startTime for COUNTUP, then the request will return an INVALID_DATA

 endTime will be ignored for "RESUME", and "CLEAR" endTime can be sent for "PAUSE", in which case it will update the paused endTime
 */
@property (strong, nonatomic, nullable) SDLStartTime *endTime;

/**
 Defines if seek media clock timer functionality will be available. If omitted, the value is set to false. The value is retained until the next SetMediaClockTimer is sent.
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *enableSeek;

/**
 The media clock/timer update mode (COUNTUP/COUNTDOWN/PAUSE/RESUME)

 When updateMode is PAUSE, RESUME or CLEAR, the start time value is ignored

 When updateMode is RESUME, the timer resumes counting from the timer's value when it was paused
 */
@property (strong, nonatomic) SDLUpdateMode updateMode;

@end

NS_ASSUME_NONNULL_END
