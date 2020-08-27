//
//  SDLLockScreenStatus.h
//  SmartDeviceLink
//


#import "SDLEnum.h"

/**
 Describes the status of the lock screen
 */
typedef SDLEnum SDLLockScreenStatus;

/**
 * LockScreen is Not Required
 */
extern SDLLockScreenStatus const SDLLockScreenStatusOff;

/**
 * LockScreen is Optional
 */
extern SDLLockScreenStatus const SDLLockScreenStatusOptional;

/**
 * LockScreen is Required
 */
extern SDLLockScreenStatus const SDLLockScreenStatusRequired;
