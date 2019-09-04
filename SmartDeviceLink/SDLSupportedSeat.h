//  SDLSupportedSeat.h
//

#import "SDLEnum.h"

/**
 * List possible seats that is a remote controllable seat.
 *  @warning This should not be used to supported seats, this is a deprecated parameter.
 */
typedef SDLEnum SDLSupportedSeat SDL_SWIFT_ENUM __deprecated;

/**
 * @abstract Save current seat postions and settings to seat memory.
 */
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
extern SDLSupportedSeat const SDLSupportedSeatDriver;
#pragma clang diagnostic pop

/**
 * @abstract Restore / apply the seat memory settings to the current seat.
 */
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
extern SDLSupportedSeat const SDLSupportedSeatFrontPassenger;
#pragma clang diagnostic pop
