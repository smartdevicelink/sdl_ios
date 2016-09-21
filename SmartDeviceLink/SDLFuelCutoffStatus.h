//  SDLFuelCutoffStatus.h
//


#import "SDLEnum.h"

/** 
 * Reflects the status of the Restraints Control Module fuel pump cutoff.
 * The fuel pump is cut off typically after the vehicle has had a collision.
 *
 * @since SDL 2.0
 */
typedef SDLEnum SDLFuelCutoffStatus NS_EXTENSIBLE_STRING_ENUM;

/** 
 * @abstract Fuel is cut off
 */
extern SDLFuelCutoffStatus SDLFuelCutoffStatusTerminateFuel;

/** 
 * @abstract Fuel is not cut off
 */
extern SDLFuelCutoffStatus SDLFuelCutoffStatusNormalOperation;

/** 
 * @abstract Status of the fuel pump cannot be determined
 */
extern SDLFuelCutoffStatus SDLFuelCutoffStatusFault;
