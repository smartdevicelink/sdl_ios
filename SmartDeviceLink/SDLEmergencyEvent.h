//  SDLEmergencyEvent.h
//

#import "SDLRPCMessage.h"

#import "SDLEmergencyEventType.h"
#import "SDLFuelCutoffStatus.h"
#import "SDLVehicleDataEventStatus.h"

NS_ASSUME_NONNULL_BEGIN

/**
 A vehicle data struct for an emergency event
 */
@interface SDLEmergencyEvent : SDLRPCStruct

/**
 References signal "VedsEvntType_D_Ltchd". See EmergencyEventType.

 Required
 */
@property (strong, nonatomic) SDLEmergencyEventType emergencyEventType;

/**
 References signal "RCM_FuelCutoff". See FuelCutoffStatus.

 Required
 */
@property (strong, nonatomic) SDLFuelCutoffStatus fuelCutoffStatus;

/**
 References signal "VedsEvntRoll_D_Ltchd". See VehicleDataEventStatus.

 Required
 */
@property (strong, nonatomic) SDLVehicleDataEventStatus rolloverEvent;

/**
 References signal "VedsMaxDeltaV_D_Ltchd". Change in velocity in KPH.

 Additional reserved values:
 0x00 No event,
 0xFE Not supported,
 0xFF Fault

 Required
 */
@property (strong, nonatomic) NSNumber<SDLInt> *maximumChangeVelocity;

/**
 References signal "VedsMultiEvnt_D_Ltchd". See VehicleDataEventStatus.

 Required
 */
@property (strong, nonatomic) SDLVehicleDataEventStatus multipleEvents;

@end

NS_ASSUME_NONNULL_END
