//
//  SDLLockScreenStatus.h
//  SmartDeviceLink
//


#import "SDLEnum.h"

typedef SDLEnum SDLLockScreenStatus NS_EXTENSIBLE_STRING_ENUM;

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
