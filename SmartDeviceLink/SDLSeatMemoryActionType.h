//  SDLSeatMemoryActionType.h
//

#import "SDLEnum.h"

/**
 * List of possible actions on Seat Meomry
 *
 * @since SDL 2.0
 */
typedef SDLEnum SDLSeatMemoryActionType SDL_SWIFT_ENUM;

/**
 * @abstract Save current seat postions and settings to seat memory.
 */
extern SDLSeatMemoryActionType const SDLSeatMemoryActionTypeSave;

/**
 * @abstract Restore / apply the seat memory settings to the current seat.
 */
extern SDLSeatMemoryActionType const SDLSeatMemoryActionTypeRestore;

/**
 * @abstract No action to be performed.
 */
extern SDLSeatMemoryActionType const SDLSeatMemoryActionTypeNone;

