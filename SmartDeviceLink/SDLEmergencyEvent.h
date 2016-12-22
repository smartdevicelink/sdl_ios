//  SDLEmergencyEvent.h
//

#import "SDLRPCMessage.h"

#import "SDLEmergencyEventType.h"
#import "SDLFuelCutoffStatus.h"
#import "SDLVehicleDataEventStatus.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLEmergencyEvent : SDLRPCStruct

@property (strong) SDLEmergencyEventType emergencyEventType;
@property (strong) SDLFuelCutoffStatus fuelCutoffStatus;
@property (strong) SDLVehicleDataEventStatus rolloverEvent;
@property (strong) NSNumber<SDLInt> *maximumChangeVelocity;
@property (strong) SDLVehicleDataEventStatus multipleEvents;

@end

NS_ASSUME_NONNULL_END
