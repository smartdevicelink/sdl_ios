//  SDLAirbagStatus.h
//

#import "SDLRPCMessage.h"

#import "SDLVehicleDataEventStatus.h"

@interface SDLAirbagStatus : SDLRPCStruct

@property (strong, nonatomic) SDLVehicleDataEventStatus driverAirbagDeployed;
@property (strong, nonatomic) SDLVehicleDataEventStatus driverSideAirbagDeployed;
@property (strong, nonatomic) SDLVehicleDataEventStatus driverCurtainAirbagDeployed;
@property (strong, nonatomic) SDLVehicleDataEventStatus passengerAirbagDeployed;
@property (strong, nonatomic) SDLVehicleDataEventStatus passengerCurtainAirbagDeployed;
@property (strong, nonatomic) SDLVehicleDataEventStatus driverKneeAirbagDeployed;
@property (strong, nonatomic) SDLVehicleDataEventStatus passengerSideAirbagDeployed;
@property (strong, nonatomic) SDLVehicleDataEventStatus passengerKneeAirbagDeployed;

@end
