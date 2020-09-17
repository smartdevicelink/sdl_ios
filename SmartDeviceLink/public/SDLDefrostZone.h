//
//  SDLDefrostZone.h
//

#import "SDLEnum.h"

/**
 * Enumeration listing possible defrost zones. Used in ClimateControlCapabilities and Data.
 *
 * @since SDL 2.0
 */
typedef SDLEnum SDLDefrostZone NS_TYPED_ENUM;

/**
 * A SDLDefrostZone with the value of *FRONT*
 */
extern SDLDefrostZone const SDLDefrostZoneFront;

/**
 * A SDLDefrostZone with the value of *REAR*
 */
extern SDLDefrostZone const SDLDefrostZoneRear;

/**
 * A SDLDefrostZone with the value of *All*
 */
extern SDLDefrostZone const SDLDefrostZoneAll;

/**
 * A SDLDefrostZone with the value of *None*
 */
extern SDLDefrostZone const SDLDefrostZoneNone;
