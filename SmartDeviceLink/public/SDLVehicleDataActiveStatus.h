//  SDLVehicleDataActiveStatus.h
//


#import "SDLEnum.h"

/**
 Vehicle Data Activity Status. Used in nothing.
 */
typedef SDLEnum SDLVehicleDataActiveStatus NS_TYPED_ENUM;

/**
 Inactive not confirmed
 */
extern SDLVehicleDataActiveStatus const SDLVehicleDataActiveStatusInactiveNotConfirmed;

/**
 Inactive confirmed
 */
extern SDLVehicleDataActiveStatus const SDLVehicleDataActiveStatusInactiveConfirmed;

/**
 Active not confirmed
 */
extern SDLVehicleDataActiveStatus const SDLVehicleDataActiveStatusActiveNotConfirmed;

/**
 Active confirmed
 */
extern SDLVehicleDataActiveStatus const SDLVehicleDataActiveStatusActiveConfirmed;

/**
 Fault
 */
extern SDLVehicleDataActiveStatus const SDLVehicleDataActiveStatusFault;
