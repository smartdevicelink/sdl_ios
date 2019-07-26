//  SDLSupportedSeat.h
//

#import "SDLEnum.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
/**
 * List possible seats that is a remote controllable seat.
 *  @warning This should not be used to supported seats, this is a deprecated parameter.
 */
typedef SDLEnum SDLSupportedSeat SDL_SWIFT_ENUM;
#pragma clang diagnostic pop

/**
 * @abstract Save current seat postions and settings to seat memory.
 */
extern SDLSupportedSeat const SDLSupportedSeatDriver;

/**
 * @abstract Restore / apply the seat memory settings to the current seat.
 */
extern SDLSupportedSeat const SDLSupportedSeatFrontPassenger;
