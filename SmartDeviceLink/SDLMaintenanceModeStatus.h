//  SDLMaintenanceModeStatus.h
//


#import "SDLEnum.h"

/**
 * The SDLMaintenanceModeStatus class.
 */
SDLEnum(SDLMaintenanceModeStatus);

/**
 * @abstract Maintenance Mode Status : Normal
 */
extern SDLMaintenanceModeStatus const SDLMaintenanceModeStatusNormal;

/**
 * @abstract Maintenance Mode Status : Near
 */
extern SDLMaintenanceModeStatus const SDLMaintenanceModeStatusNear;

/**
 * @abstract Maintenance Mode Status : Active
 */
extern SDLMaintenanceModeStatus const SDLMaintenanceModeStatusActive;

/**
 * @abstract Maintenance Mode Status : Feature not present
 */
extern SDLMaintenanceModeStatus const SDLMaintenanceModeStatusFeatureNotPresent;
