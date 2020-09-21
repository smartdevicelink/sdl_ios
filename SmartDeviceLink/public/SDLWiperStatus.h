//  SDLWiperStatus.h
//


#import "SDLEnum.h"

/**
 * The status of the windshield wipers. Used in retrieving vehicle data.
 */
typedef SDLEnum SDLWiperStatus NS_TYPED_ENUM;

/**
 * Wiper is off
 */
extern SDLWiperStatus const SDLWiperStatusOff;

/**
 * Wiper is off automatically
 */
extern SDLWiperStatus const SDLWiperStatusAutomaticOff;

/**
 * Wiper is moving but off
 */
extern SDLWiperStatus const SDLWiperStatusOffMoving;

/**
 * Wiper is off due to a manual interval
 */
extern SDLWiperStatus const SDLWiperStatusManualIntervalOff;

/**
 * Wiper is on due to a manual interval
 */
extern SDLWiperStatus const SDLWiperStatusManualIntervalOn;

/**
 * Wiper is on low manually
 */
extern SDLWiperStatus const SDLWiperStatusManualLow;

/**
 * Wiper is on high manually
 */
extern SDLWiperStatus const SDLWiperStatusManualHigh;

/**
 * Wiper is on for a single wipe manually
 */
extern SDLWiperStatus const SDLWiperStatusManualFlick;

/**
 * Wiper is in wash mode
 */
extern SDLWiperStatus const SDLWiperStatusWash;

/**
 * Wiper is on low automatically
 */
extern SDLWiperStatus const SDLWiperStatusAutomaticLow;

/**
 * Wiper is on high automatically
 */
extern SDLWiperStatus const SDLWiperStatusAutomaticHigh;

/**
 * Wiper is performing a courtesy wipe
 */
extern SDLWiperStatus const SDLWiperStatusCourtesyWipe;

/**
 * Wiper is on automatic adjust
 */
extern SDLWiperStatus const SDLWiperStatusAutomaticAdjust;

/**
 * Wiper is stalled
 */
extern SDLWiperStatus const SDLWiperStatusStalled;

/**
 * Wiper data is not available
 */
extern SDLWiperStatus const SDLWiperStatusNoDataExists;
