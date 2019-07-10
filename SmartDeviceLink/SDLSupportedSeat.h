//  SDLSupportedSeat.h
//

#import "SDLEnum.h"

/**
 * List possible seats that is a remote controllable seat.
 *
 */
typedef SDLEnum SDLSupportedSeat SDL_SWIFT_ENUM;

/**
 * @abstract Save current seat postions and settings to seat memory.
 */
extern SDLSupportedSeat const SDLSupportedSeatDriver;

/**
 * @abstract Restore / apply the seat memory settings to the current seat.
 */
extern SDLSupportedSeat const SDLSupportedSeatFrontPassenger;
