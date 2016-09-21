//  SDLWiperStatus.h
//


#import "SDLEnum.h"

/**
 * Wiper Status
 */
typedef SDLEnum SDLWiperStatus NS_EXTENSIBLE_STRING_ENUM;

/**
 * @abstract SDLWiperStatus: *OFF*
 */
extern SDLWiperStatus const SDLWiperStatusOff;

/**
 * @abstract SDLWiperStatus: *AUTO_OFF*
 */
extern SDLWiperStatus const SDLWiperStatusAutoOff;

/**
 * @abstract SDLWiperStatus: *OFF_MOVING*
 */
extern SDLWiperStatus const SDLWiperStatusOffMoving;

/**
 * @abstract SDLWiperStatus: *MAN_INT_OFF*
 */
extern SDLWiperStatus const SDLWiperStatusManIntOff;

/**
 * @abstract SDLWiperStatus: *MAN_INT_ON*
 */
extern SDLWiperStatus const SDLWiperStatusManIntOn;

/**
 * @abstract SDLWiperStatus: *MAN_LOW*
 */
extern SDLWiperStatus const SDLWiperStatusManLow;

/**
 * @abstract SDLWiperStatus: *MAN_HIGH*
 */
extern SDLWiperStatus const SDLWiperStatusManHigh;

/**
 * @abstract SDLWiperStatus: *MAN_FLICK*
 */
extern SDLWiperStatus const SDLWiperStatusManFlick;

/**
 * @abstract SDLWiperStatus: *WASH*
 */
extern SDLWiperStatus const SDLWiperStatusWash;

/**
 * @abstract SDLWiperStatus: *AUTO_LOW*
 */
extern SDLWiperStatus const SDLWiperStatusAutoLow;

/**
 * @abstract SDLWiperStatus: *AUTO_HIGH*
 */
extern SDLWiperStatus const SDLWiperStatusAutoHigh;

/**
 * @abstract SDLWiperStatus: *COURTESYWIPE*
 */
extern SDLWiperStatus const SDLWiperStatusCourtesyWipe;

/**
 * @abstract SDLWiperStatus: *AUTO_ADJUST*
 */
extern SDLWiperStatus const SDLWiperStatusAutoAdjust;

/**
 * @abstract SDLWiperStatus: *STALLED*
 */
extern SDLWiperStatus const SDLWiperStatusStalled;

/**
 * @abstract SDLWiperStatus: *NO_DATA_EXISTS*
 */
extern SDLWiperStatus const SDLWiperStatusNoDataExists;
