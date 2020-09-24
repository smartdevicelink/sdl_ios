//  SDLMaintenanceModeStatus.h
//


#import "SDLEnum.h"

/**
 * Describes the maintenence mode. Used in nothing.
 */
typedef SDLEnum SDLMaintenanceModeStatus NS_TYPED_ENUM;

/**
 * Maintenance Mode Status : Normal
 */
extern SDLMaintenanceModeStatus const SDLMaintenanceModeStatusNormal;

/**
 * Maintenance Mode Status : Near
 */
extern SDLMaintenanceModeStatus const SDLMaintenanceModeStatusNear;

/**
 * Maintenance Mode Status : Active
 */
extern SDLMaintenanceModeStatus const SDLMaintenanceModeStatusActive;

/**
 * Maintenance Mode Status : Feature not present
 */
extern SDLMaintenanceModeStatus const SDLMaintenanceModeStatusFeatureNotPresent;
