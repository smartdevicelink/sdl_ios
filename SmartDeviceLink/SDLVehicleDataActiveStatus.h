//  SDLVehicleDataActiveStatus.h
//


#import "SDLEnum.h"

/**
 Vehicle Data Activity Status
 */
typedef SDLEnum SDLVehicleDataActiveStatus NS_EXTENSIBLE_STRING_ENUM;

/**
 @abstract SDLVehicleDataActiveStatus : Inactive not confirmed
 */
extern SDLVehicleDataActiveStatus const SDLVehicleDataActiveStatusInactiveNotConfirmed;

/**
 @abstract SDLVehicleDataActiveStatus : Inactive confirmed
 */
extern SDLVehicleDataActiveStatus const SDLVehicleDataActiveStatusInactiveConfirmed;

/**
 @abstract SDLVehicleDataActiveStatus : Active not confirmed
 */
extern SDLVehicleDataActiveStatus const SDLVehicleDataActiveStatusActiveNotConfirmed;

/**
 @abstract SDLVehicleDataActiveStatus : Active confirmed
 */
extern SDLVehicleDataActiveStatus const SDLVehicleDataActiveStatusActiveConfirmed;

/**
 @abstract SDLVehicleDataActiveStatus : Fault
 */
extern SDLVehicleDataActiveStatus const SDLVehicleDataActiveStatusFault;
