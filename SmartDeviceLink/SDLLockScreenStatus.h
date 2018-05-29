//
//  SDLLockScreenStatus.h
//  SmartDeviceLink
//


#import "SDLEnum.h"

/**
 Describes what the status of the lock screen should be

 Used in OnLockScreenStatus
 */
typedef SDLEnum SDLLockScreenStatus SDL_SWIFT_ENUM;

/**
 * LockScreen is Not Required
 */
extern SDLLockScreenStatus const SDLLockScreenStatusOff;

/**
 * LockScreen is Optional
 */
extern SDLLockScreenStatus const SDLLockScreenStatusOptional;

/**
 * LockScreen is Not Required
 */
extern SDLLockScreenStatus const SDLLockScreenStatusRequired;
