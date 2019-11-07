//  SDLSupportedSeat.h
//

#import "SDLEnum.h"

/**
 * List possible seats that is a remote controllable seat.
 *  @warning This should not be used to supported seats, this is a deprecated parameter.
 */
typedef SDLEnum SDLSupportedSeat SDL_SWIFT_ENUM __deprecated;

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
/**
* Save current seat positions and settings to seat memory.
*/
extern SDLSupportedSeat const SDLSupportedSeatDriver;
#pragma clang diagnostic pop

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
/**
* Restore / apply the seat memory settings to the current seat.
*/
extern SDLSupportedSeat const SDLSupportedSeatFrontPassenger;
#pragma clang diagnostic pop
