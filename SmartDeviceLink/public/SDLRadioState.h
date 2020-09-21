//
//  SDLRadioState.h
//

#import "SDLEnum.h"

/**
 * List possible states of a remote control radio module. Used in RadioControlData.
 */
typedef SDLEnum SDLRadioState NS_TYPED_ENUM;

/**
 * Represents Radio state as ACQUIRING
 */
extern SDLRadioState const SDLRadioStateAcquiring;

/**
 * Represents Radio state as ACQUIRED
 */
extern SDLRadioState const SDLRadioStateAcquired;

/**
 * Represents Radio state as MULTICAST
 */
extern SDLRadioState const SDLRadioStateMulticast;

/**
 * Represents Radio state as NOT_FOUND
 */
extern SDLRadioState const SDLRadioStateNotFound;
