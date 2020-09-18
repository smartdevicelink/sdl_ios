//  SDLFuelCutoffStatus.h
//


#import "SDLEnum.h"

/** 
 * Reflects the status of the Restraints Control Module fuel pump cutoff. The fuel pump is cut off typically after the vehicle has had a collision. Used in EmergencyEvent.
 *
 * @since SDL 2.0
 */
typedef SDLEnum SDLFuelCutoffStatus NS_TYPED_ENUM;

/** 
 * Fuel is cut off
 */
extern SDLFuelCutoffStatus const SDLFuelCutoffStatusTerminateFuel;

/** 
 * Fuel is not cut off
 */
extern SDLFuelCutoffStatus const SDLFuelCutoffStatusNormalOperation;

/** 
 * Status of the fuel pump cannot be determined
 */
extern SDLFuelCutoffStatus const SDLFuelCutoffStatusFault;
