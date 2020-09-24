//  SDLVehicleDataStatus.h
//


#import "SDLEnum.h"

/**
 * Reflects the status of a binary vehicle data item. Used in MyKey.
 *
 * @since SDL 2.0
 */
typedef SDLEnum SDLVehicleDataStatus NS_TYPED_ENUM;

/**
 No data avaliable
 */
extern SDLVehicleDataStatus const SDLVehicleDataStatusNoDataExists;

/**
 The status is Off
 */
extern SDLVehicleDataStatus const SDLVehicleDataStatusOff;

/**
 The status is On
 */
extern SDLVehicleDataStatus const SDLVehicleDataStatusOn;
