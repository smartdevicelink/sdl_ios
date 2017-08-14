//
//  SDLRadioState.h
//

#import "SDLEnum.h"

typedef SDLEnum SDLRadioState SDL_SWIFT_ENUM;


/**
 *  @abstract Represents Radio state as ACQUIRING
 *
 */
extern SDLRadioState const SDLRadioBandAcquiring;

/**
 *  @abstract Represents Radio state as ACQUIRED
 *
 */
extern SDLRadioState const SDLRadioStateAcquired;

/**
 *  @abstract Represents Radio state as MULTICAST
 *
 */
extern SDLRadioState const SDLRadioStateMulticast;

/**
 *  @abstract Represents Radio state as NOT_FOUND
 *
 */
extern SDLRadioState const SDLRadioStateNotFound;
