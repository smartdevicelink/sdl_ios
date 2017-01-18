//  SDLEmergencyEvent.h
//

#import "SDLRPCMessage.h"

#import "SDLEmergencyEventType.h"
#import "SDLFuelCutoffStatus.h"
#import "SDLVehicleDataEventStatus.h"


@interface SDLEmergencyEvent : SDLRPCStruct

@property (strong, nonatomic) SDLEmergencyEventType emergencyEventType;
@property (strong, nonatomic) SDLFuelCutoffStatus fuelCutoffStatus;
@property (strong, nonatomic) SDLVehicleDataEventStatus rolloverEvent;
@property (strong, nonatomic) NSNumber<SDLInt> *maximumChangeVelocity;
@property (strong, nonatomic) SDLVehicleDataEventStatus multipleEvents;

@end
