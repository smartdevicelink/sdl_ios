//  SDLSetMediaClockTimer.h
//

#import "SDLRPCRequest.h"

#import "SDLUpdateMode.h"
#import "SDLAudioStreamingIndicator.h"

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

/**
 Create a media clock timer that counts up, e.g from 0:00 to 4:18.

 This will fail if startTime is greater than endTime

 @param startTime The start time interval, e.g. (0) 0:00
 @param endTime The end time interval, e.g. (258) 4:18
 @param playPauseIndicator An optional audio indicator to change the play/pause button
 @return An object of SetMediaClockTimer
 */
+ (instancetype)countUpFromStartTimeInterval:(NSTimeInterval)startTime toEndTimeInterval:(NSTimeInterval)endTime playPauseIndicator:(nullable SDLAudioStreamingIndicator)playPauseIndicator NS_SWIFT_NAME(countUp(from:to:playPauseIndicator:));

/**
 Create a media clock timer that counts up, e.g from 0:00 to 4:18.

 This will fail if startTime is greater than endTime

 @param startTime The start time interval, e.g. 0:00
 @param endTime The end time interval, e.g. 4:18
 @param playPauseIndicator An optional audio indicator to change the play/pause button
 @return An object of SetMediaClockTimer
 */
+ (instancetype)countUpFromStartTime:(SDLStartTime *)startTime toEndTime:(SDLStartTime *)endTime playPauseIndicator:(nullable SDLAudioStreamingIndicator)playPauseIndicator NS_SWIFT_NAME(countUp(from:to:playPauseIndicator:));

/**
 Create a media clock timer that counts down, e.g. from 4:18 to 0:00

 This will fail if endTime is greater than startTime

 @param startTime The start time interval, e.g. (258) 4:18
 @param endTime The end time interval, e.g. (0) 0:00
 @param playPauseIndicator An optional audio indicator to change the play/pause button
 @return An object of SetMediaClockTimer
 */
+ (instancetype)countDownFromStartTimeInterval:(NSTimeInterval)startTime toEndTimeInterval:(NSTimeInterval)endTime playPauseIndicator:(nullable SDLAudioStreamingIndicator)playPauseIndicator NS_SWIFT_NAME(countDown(from:to:playPauseIndicator:));

/**
 Create a media clock timer that counts down, e.g. from 4:18 to 0:00

 This will fail if endTime is greater than startTime

 @param startTime The start time interval, e.g. 4:18
 @param endTime The end time interval, e.g. 0:00
 @param playPauseIndicator An optional audio indicator to change the play/pause button
 @return An object of SetMediaClockTimer
 */
+ (instancetype)countDownFromStartTime:(SDLStartTime *)startTime toEndTime:(SDLStartTime *)endTime playPauseIndicator:(nullable SDLAudioStreamingIndicator)playPauseIndicator NS_SWIFT_NAME(countDown(from:to:playPauseIndicator:));

/**
 Pause an existing (counting up / down) media clock timer

 @param playPauseIndicator An optional audio indicator to change the play/pause button
 @return An object of SetMediaClockTimer
 */
+ (instancetype)pauseWithPlayPauseIndicator:(nullable SDLAudioStreamingIndicator)playPauseIndicator NS_SWIFT_NAME(pause(playPauseIndicator:));

/**
 Update a pause time (or pause and update the time) on a media clock timer

 @param startTime The new start time interval
 @param endTime The new end time interval
 @param playPauseIndicator An optional audio indicator to change the play/pause button
 @return An object of SetMediaClockTimer
 */
+ (instancetype)updatePauseWithNewStartTimeInterval:(NSTimeInterval)startTime endTimeInterval:(NSTimeInterval)endTime playPauseIndicator:(nullable SDLAudioStreamingIndicator)playPauseIndicator NS_SWIFT_NAME(pause(newStart:newEnd:playPauseIndicator:));

/**
 Update a pause time (or pause and update the time) on a media clock timer

 @param startTime The new start time
 @param endTime The new end time
 @param playPauseIndicator An optional audio indicator to change the play/pause button
 @return An object of SetMediaClockTimer
 */
+ (instancetype)updatePauseWithNewStartTime:(SDLStartTime *)startTime endTime:(SDLStartTime *)endTime playPauseIndicator:(nullable SDLAudioStreamingIndicator)playPauseIndicator NS_SWIFT_NAME(pause(newStart:newEnd:playPauseIndicator:));

/**
 Resume a paused media clock timer. It resumes at the same time at which it was paused.

 @param playPauseIndicator An optional audio indicator to change the play/pause button
 @return An object of SetMediaClockTimer
 */
+ (instancetype)resumeWithPlayPauseIndicator:(nullable SDLAudioStreamingIndicator)playPauseIndicator NS_SWIFT_NAME(resume(playPauseIndicator:));

/**
 Remove a media clock timer from the screen

 @param playPauseIndicator An optional audio indicator to change the play/pause button
 @return An object of SetMediaClockTimer
 */
+ (instancetype)clearWithPlayPauseIndicator:(nullable SDLAudioStreamingIndicator)playPauseIndicator NS_SWIFT_NAME(clear(playPauseIndicator:));

/**
 Create a SetMediaClockTimer RPC with all available parameters. It's recommended to use the specific initializers above.

 @param updateMode The type of SetMediaClockTimer RPC
 @param startTime The start time. Only valid in some updateModes.
 @param endTime The end time. Only valid in some updateModes.
 @param playPauseIndicator The display of the play/pause button
 @return An object of SetMediaClockTimer
 */
- (instancetype)initWithUpdateMode:(SDLUpdateMode)updateMode startTime:(nullable SDLStartTime *)startTime endTime:(nullable SDLStartTime *)endTime playPauseIndicator:(nullable SDLAudioStreamingIndicator)playPauseIndicator NS_SWIFT_NAME(init(updateMode:startTime:endTime:playPauseIndicator:));

/**
 * A Start Time with specifying hour, minute, second values
 *
 * @discussion A startTime object with specifying hour, minute, second values
 *            <p>
 *            <b>Notes: </b>
 *            <ul>
 *            <li>If "updateMode" is COUNTUP or COUNTDOWN, this parameter
 *            must be provided</li>
 *            <li>Will be ignored for PAUSE/RESUME and CLEAR</li>
 *            </ul>
 */
@property (strong, nonatomic, nullable) SDLStartTime *startTime;
/**
 * An END time of type SDLStartTime, specifying hour, minute, second values
 *
 * @discussion An SDLStartTime object with specifying hour, minute, second values
 */
@property (strong, nonatomic, nullable) SDLStartTime *endTime;
/**
 * The media clock/timer update mode (COUNTUP/COUNTDOWN/PAUSE/RESUME)
 *
 * @discussion a Enumeration value (COUNTUP/COUNTDOWN/PAUSE/RESUME)
 *            <p>
 *            <b>Notes: </b>
 *            <ul>
 *            <li>When updateMode is PAUSE, RESUME or CLEAR, the start time value
 *            is ignored</li>
 *            <li>When updateMode is RESUME, the timer resumes counting from
 *            the timer's value when it was paused</li>
 *            </ul>
 */
@property (strong, nonatomic) SDLUpdateMode updateMode;

/**
 * The audio streaming indicator used for a play/pause button.
 *
 * @discussion Set the indicator icon of a play/pause button depending on the
 * current audio playback. This parameter is optional. If omitted the last indicator sent
 * will not change.
 */
@property (strong, nonatomic, nullable) SDLAudioStreamingIndicator audioStreamingIndicator;

@end

NS_ASSUME_NONNULL_END
