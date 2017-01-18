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
 * @abstract References signal "PrkBrkActv_B_Actl".
 */
@property (strong) NSNumber<SDLBool> *parkBrakeActive;

/**
 * @abstract References signal "Ignition_Switch_Stable". See IgnitionStableStatus.
 */
@property (strong) SDLIgnitionStableStatus ignitionStableStatus;

/**
 * @abstract References signal "Ignition_status". See IgnitionStatus.
 */
@property (strong) SDLIgnitionStatus ignitionStatus;

/**
 * @abstract References signal "DrStatDrv_B_Actl".
 */
@property (nullable, strong) NSNumber<SDLBool> *driverDoorAjar;

/**
 * @abstract References signal "DrStatPsngr_B_Actl".
 */
@property (nullable, strong) NSNumber<SDLBool> *passengerDoorAjar;

/**
 * @abstract References signal "DrStatRl_B_Actl".
 */
@property (nullable, strong) NSNumber<SDLBool> *rearLeftDoorAjar;

/**
 * @abstract References signal "DrStatRr_B_Actl".
 */
@property (nullable, strong) NSNumber<SDLBool> *rearRightDoorAjar;

@end

NS_ASSUME_NONNULL_END
