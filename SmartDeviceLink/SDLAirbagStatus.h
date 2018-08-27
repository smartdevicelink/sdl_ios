//  SDLAirbagStatus.h
//

#import "SDLRPCMessage.h"

#import "SDLVehicleDataEventStatus.h"

NS_ASSUME_NONNULL_BEGIN

/**
 A vehicle data status struct for airbags
 */
@interface SDLAirbagStatus : SDLRPCStruct

/**
 References signal "VedsDrvBag_D_Ltchd". See VehicleDataEventStatus.

 Required
 */
@property (strong, nonatomic) SDLVehicleDataEventStatus driverAirbagDeployed;

/**
 References signal "VedsDrvSideBag_D_Ltchd". See VehicleDataEventStatus.

 Required
 */
@property (strong, nonatomic) SDLVehicleDataEventStatus driverSideAirbagDeployed;

/**
 References signal "VedsDrvCrtnBag_D_Ltchd". See VehicleDataEventStatus

 Required
 */
@property (strong, nonatomic) SDLVehicleDataEventStatus driverCurtainAirbagDeployed;

/**
 References signal "VedsPasBag_D_Ltchd". See VehicleDataEventStatus.

 Required
 */
@property (strong, nonatomic) SDLVehicleDataEventStatus passengerAirbagDeployed;

/**
 References signal "VedsPasCrtnBag_D_Ltchd". See VehicleDataEventStatus.

 Required
 */
@property (strong, nonatomic) SDLVehicleDataEventStatus passengerCurtainAirbagDeployed;

/**
 References signal "VedsKneeDrvBag_D_Ltchd". See VehicleDataEventStatus.

 Required
 */
@property (strong, nonatomic) SDLVehicleDataEventStatus driverKneeAirbagDeployed;

/**
 References signal "VedsPasSideBag_D_Ltchd". See VehicleDataEventStatus.

 Required
 */
@property (strong, nonatomic) SDLVehicleDataEventStatus passengerSideAirbagDeployed;

/**
 References signal "VedsKneePasBag_D_Ltchd". See VehicleDataEventStatus.

 Required
 */
@property (strong, nonatomic) SDLVehicleDataEventStatus passengerKneeAirbagDeployed;

@end

NS_ASSUME_NONNULL_END
