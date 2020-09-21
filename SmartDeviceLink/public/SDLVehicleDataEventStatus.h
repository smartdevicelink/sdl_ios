//  SDLVehicleDataEventStatus.h
//


#import "SDLEnum.h"

/**
 * Reflects the status of a vehicle data event; e.g. a seat belt event status. Used in retrieving vehicle data.
 *
 * @since SDL 2.0
 */
typedef SDLEnum SDLVehicleDataEventStatus NS_TYPED_ENUM;

/**
 No event
 */
extern SDLVehicleDataEventStatus const SDLVehicleDataEventStatusNoEvent;

/**
 The event is a No status
 */
extern SDLVehicleDataEventStatus const SDLVehicleDataEventStatusNo;

/**
 The event is a Yes status
 */
extern SDLVehicleDataEventStatus const SDLVehicleDataEventStatusYes;

/**
 Vehicle data event is not supported
 */
extern SDLVehicleDataEventStatus const SDLVehicleDataEventStatusNotSupported;

/**
 The event is a Fault status
 */
extern SDLVehicleDataEventStatus const SDLVehicleDataEventStatusFault;
