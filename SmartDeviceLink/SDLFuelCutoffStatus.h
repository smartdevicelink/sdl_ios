//  SDLFuelCutoffStatus.h
//


#import "SDLEnum.h"

/** 
 * Reflects the status of the Restraints Control Module fuel pump cutoff.
 * The fuel pump is cut off typically after the vehicle has had a collision.
 *
 * @since SDL 2.0
 */
typedef SDLEnum SDLFuelCutoffStatus SDL_SWIFT_ENUM;

/** 
 * @abstract Fuel is cut off
 */
extern SDLFuelCutoffStatus const SDLFuelCutoffStatusTerminateFuel;

/** 
 * @abstract Fuel is not cut off
 */
extern SDLFuelCutoffStatus const SDLFuelCutoffStatusNormalOperation;

/** 
 * @abstract Status of the fuel pump cannot be determined
 */
extern SDLFuelCutoffStatus const SDLFuelCutoffStatusFault;
