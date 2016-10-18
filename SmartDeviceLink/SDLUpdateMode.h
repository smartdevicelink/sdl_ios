//  SDLUpdateMode.h
//


#import "SDLEnum.h"

/**
 * Specifies what function should be performed on the media clock/counter
 *
 * @since SDL 1.0
 */
typedef SDLEnum SDLUpdateMode SDL_SWIFT_ENUM;

/**
 * @abstract Starts the media clock timer counting upward, in increments of 1 second.
 */
extern SDLUpdateMode const SDLUpdateModeCountUp;

/**
 * @abstract Starts the media clock timer counting downward, in increments of 1 second.
 */
extern SDLUpdateMode const SDLUpdateModeCountDown;

/**
 * @abstract Pauses the media clock timer.
 */
extern SDLUpdateMode const SDLUpdateModePause;

/**
 * @abstract Resumes the media clock timer. The timer resumes counting in whatever mode was in effect before pausing (i.e. COUNTUP or COUNTDOWN).
 */
extern SDLUpdateMode const SDLUpdateModeResume;

/**
 * @abstract Clear the media clock timer.
 */
extern SDLUpdateMode const SDLUpdateModeClear;
