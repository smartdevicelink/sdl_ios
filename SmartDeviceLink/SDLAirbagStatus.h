//  SDLAirbagStatus.h
//

#import "SDLRPCMessage.h"

@class SDLVehicleDataEventStatus;


@interface SDLAirbagStatus : SDLRPCStruct

@property (strong) SDLVehicleDataEventStatus *driverAirbagDeployed;
@property (strong) SDLVehicleDataEventStatus *driverSideAirbagDeployed;
@property (strong) SDLVehicleDataEventStatus *driverCurtainAirbagDeployed;
@property (strong) SDLVehicleDataEventStatus *passengerAirbagDeployed;
@property (strong) SDLVehicleDataEventStatus *passengerCurtainAirbagDeployed;
@property (strong) SDLVehicleDataEventStatus *driverKneeAirbagDeployed;
@property (strong) SDLVehicleDataEventStatus *passengerSideAirbagDeployed;
@property (strong) SDLVehicleDataEventStatus *passengerKneeAirbagDeployed;

@end
