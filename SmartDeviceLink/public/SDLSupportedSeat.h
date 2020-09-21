//  SDLSupportedSeat.h
//

#import "SDLEnum.h"

/**
 * List possible seats that is a remote controllable seat.
 *
 * @deprecated
 * @history SDL 5.0.0
 * @since SDL 6.0.0
 */
typedef SDLEnum SDLSupportedSeat NS_TYPED_ENUM __deprecated;

/**
* Save current seat positions and settings to seat memory.
*/
extern SDLSupportedSeat const SDLSupportedSeatDriver __deprecated;

/**
* Restore / apply the seat memory settings to the current seat.
*/
extern SDLSupportedSeat const SDLSupportedSeatFrontPassenger __deprecated;
