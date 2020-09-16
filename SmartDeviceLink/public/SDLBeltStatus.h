//  SDLBeltStatus.h
//

#import "SDLRPCMessage.h"

#import "SDLVehicleDataEventStatus.h"

NS_ASSUME_NONNULL_BEGIN

/**
 Vehicle data struct for the seat belt status
 */
@interface SDLBeltStatus : SDLRPCStruct

/**
 References signal "VedsDrvBelt_D_Ltchd". See VehicleDataEventStatus.

 Required
 */
@property (strong, nonatomic) SDLVehicleDataEventStatus driverBeltDeployed;

/**
 References signal "VedsPasBelt_D_Ltchd". See VehicleDataEventStatus.

 Required
 */
@property (strong, nonatomic) SDLVehicleDataEventStatus passengerBeltDeployed;

/**
 References signal "VedsRw1PasBckl_D_Ltchd". See VehicleDataEventStatus.

 Required
 */
@property (strong, nonatomic) SDLVehicleDataEventStatus passengerBuckleBelted;

/**
 References signal "VedsRw1DrvBckl_D_Ltchd". See VehicleDataEventStatus

 Required
 */
@property (strong, nonatomic) SDLVehicleDataEventStatus driverBuckleBelted;

/**
 References signal "VedsRw2lBckl_D_Ltchd". See VehicleDataEventStatus.

 Required
 */
@property (strong, nonatomic) SDLVehicleDataEventStatus leftRow2BuckleBelted;

/**
 References signal "VedsRw1PasChld_D_Ltchd". See VehicleDataEventStatus.

 Required
 */
@property (strong, nonatomic) SDLVehicleDataEventStatus passengerChildDetected;

/**
 References signal "VedsRw2rBckl_D_Ltchd". See VehicleDataEventStatus.

 Required
 */
@property (strong, nonatomic) SDLVehicleDataEventStatus rightRow2BuckleBelted;

/**
 References signal "VedsRw2mBckl_D_Ltchd". See VehicleDataEventStatus.

 Required
 */
@property (strong, nonatomic) SDLVehicleDataEventStatus middleRow2BuckleBelted;

/**
 References signal "VedsRw3mBckl_D_Ltchd". See VehicleDataEventStatus.

 Required
 */
@property (strong, nonatomic) SDLVehicleDataEventStatus middleRow3BuckleBelted;

/**
 References signal "VedsRw3lBckl_D_Ltchd". See VehicleDataEventStatus.

 Required
 */
@property (strong, nonatomic) SDLVehicleDataEventStatus leftRow3BuckleBelted;

/**
 References signal "VedsRw3rBckl_D_Ltchd". See VehicleDataEventStatus.

 Required
 */
@property (strong, nonatomic) SDLVehicleDataEventStatus rightRow3BuckleBelted;

/**
 References signal "VedsRw2lRib_D_Ltchd". See VehicleDataEventStatus.

 Required
 */
@property (strong, nonatomic) SDLVehicleDataEventStatus leftRearInflatableBelted;

/**
 References signal "VedsRw2rRib_D_Ltchd". See VehicleDataEventStatus.

 Required
 */
@property (strong, nonatomic) SDLVehicleDataEventStatus rightRearInflatableBelted;

/**
 References signal "VedsRw1mBelt_D_Ltchd". See VehicleDataEventStatus.

 Required
 */
@property (strong, nonatomic) SDLVehicleDataEventStatus middleRow1BeltDeployed;

/**
 References signal "VedsRw1mBckl_D_Ltchd". See VehicleDataEventStatus.

 Required
 */
@property (strong, nonatomic) SDLVehicleDataEventStatus middleRow1BuckleBelted;

@end

NS_ASSUME_NONNULL_END
