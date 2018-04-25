//  SDLBodyInformation.h
//

#import "SDLRPCMessage.h"

#import "SDLIgnitionStableStatus.h"
#import "SDLIgnitionStatus.h"


/**
 * The body information including power modes.
 */

NS_ASSUME_NONNULL_BEGIN

@interface SDLBodyInformation : SDLRPCStruct

/**
 * References signal "PrkBrkActv_B_Actl".

 Required
 */
@property (strong, nonatomic) NSNumber<SDLBool> *parkBrakeActive;

/**
 * References signal "Ignition_Switch_Stable". See IgnitionStableStatus.

 Required
 */
@property (strong, nonatomic) SDLIgnitionStableStatus ignitionStableStatus;

/**
 * References signal "Ignition_status". See IgnitionStatus.

 Required
 */
@property (strong, nonatomic) SDLIgnitionStatus ignitionStatus;

/**
 * References signal "DrStatDrv_B_Actl".

 Optional
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *driverDoorAjar;

/**
 * References signal "DrStatPsngr_B_Actl".

 Optional
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *passengerDoorAjar;

/**
 * References signal "DrStatRl_B_Actl".

 Optional
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *rearLeftDoorAjar;

/**
 * References signal "DrStatRr_B_Actl".

 Optional
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *rearRightDoorAjar;

@end

NS_ASSUME_NONNULL_END
