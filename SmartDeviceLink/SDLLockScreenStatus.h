//
//  SDLLockScreenStatus.h
//  SmartDeviceLink
//


#import "SDLEnum.h"

/**
 Describes what the status of the lock screen should be

 Used in OnLockScreenStatus
 */
typedef SDLEnum SDLLockScreenStatus SDL_SWIFT_ENUM __deprecated;

/**
 * LockScreen is Not Required
 */
extern SDLLockScreenStatus const SDLLockScreenStatusOff __deprecated;

/**
 * LockScreen is Optional
 */
extern SDLLockScreenStatus const SDLLockScreenStatusOptional __deprecated;

/**
 * LockScreen is Required
 */
extern SDLLockScreenStatus const SDLLockScreenStatusRequired __deprecated;
