//  SDLSetMediaClockTimer.h
//

#import "SDLRPCRequest.h"

@class SDLStartTime;
@class SDLUpdateMode;


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
@interface SDLSetMediaClockTimer : SDLRPCRequest {
}

/**
 * @abstract Constructs a new SDLSetMediaClockTimer object
 */
- (instancetype)init;
/**
 * @abstract Constructs a new SDLSetMediaClockTimer object indicated by the NSMutableDictionary
 * parameter
 * @param dict The dictionary to use
 */
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

- (instancetype)initWithUpdateMode:(SDLUpdateMode *)updateMode hours:(NSInteger)hours minutes:(NSInteger)minutes seconds:(NSInteger)seconds;

- (instancetype)initWithUpdateMode:(SDLUpdateMode *)updateMode;

/**
 * @abstract A Start Time with specifying hour, minute, second values
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
@property (strong) SDLStartTime *startTime;
/**
 * @abstract An END time of type SDLStartTime, specifying hour, minute, second values
 *
 * @discussion An SDLStartTime object with specifying hour, minute, second values
 */
@property (strong) SDLStartTime *endTime;
/**
 * @abstract The media clock/timer update mode (COUNTUP/COUNTDOWN/PAUSE/RESUME)
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
@property (strong) SDLUpdateMode *updateMode;

@end
