//  SDLAirbagStatus.h
//

#import "SDLRPCMessage.h"

#import "SDLVehicleDataEventStatus.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLAirbagStatus : SDLRPCStruct

@property (strong) SDLVehicleDataEventStatus driverAirbagDeployed;
@property (strong) SDLVehicleDataEventStatus driverSideAirbagDeployed;
@property (strong) SDLVehicleDataEventStatus driverCurtainAirbagDeployed;
@property (strong) SDLVehicleDataEventStatus passengerAirbagDeployed;
@property (strong) SDLVehicleDataEventStatus passengerCurtainAirbagDeployed;
@property (strong) SDLVehicleDataEventStatus driverKneeAirbagDeployed;
@property (strong) SDLVehicleDataEventStatus passengerSideAirbagDeployed;
@property (strong) SDLVehicleDataEventStatus passengerKneeAirbagDeployed;

@end

NS_ASSUME_NONNULL_END
