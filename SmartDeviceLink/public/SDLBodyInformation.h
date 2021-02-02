//  SDLBodyInformation.h
//

#import "SDLRPCMessage.h"

#import "SDLIgnitionStableStatus.h"
#import "SDLIgnitionStatus.h"
#import "SDLRPCStruct.h"

@class SDLDoorStatus;
@class SDLGateStatus;
@class SDLRoofStatus;

NS_ASSUME_NONNULL_BEGIN

@interface SDLBodyInformation : SDLRPCStruct

/**
 * @param parkBrakeActive - @(parkBrakeActive)
 * @param ignitionStableStatus - ignitionStableStatus
 * @param ignitionStatus - ignitionStatus
 * @return A SDLBodyInformation object
 */
- (instancetype)initWithParkBrakeActive:(BOOL)parkBrakeActive ignitionStableStatus:(SDLIgnitionStableStatus)ignitionStableStatus ignitionStatus:(SDLIgnitionStatus)ignitionStatus;

/**
 * @param parkBrakeActive - @(parkBrakeActive)
 * @param ignitionStableStatus - ignitionStableStatus
 * @param ignitionStatus - ignitionStatus
 * @param doorStatuses - doorStatuses
 * @param gateStatuses - gateStatuses
 * @param roofStatuses - roofStatuses
 * @return A SDLBodyInformation object
 */
- (instancetype)initWithParkBrakeActive:(BOOL)parkBrakeActive ignitionStableStatus:(SDLIgnitionStableStatus)ignitionStableStatus ignitionStatus:(SDLIgnitionStatus)ignitionStatus doorStatuses:(nullable NSArray<SDLDoorStatus *> *)doorStatuses gateStatuses:(nullable NSArray<SDLGateStatus *> *)gateStatuses roofStatuses:(nullable NSArray<SDLRoofStatus *> *)roofStatuses;

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
 * References signal "DrStatDrv_B_Actl". Deprecated starting with RPC Spec 7.1.0.
 *
 * @deprecated in SmartDeviceLink 7.1.0
 * @added in SmartDeviceLink 2.0.0
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *driverDoorAjar __deprecated_msg("use doorStatuses instead");

/**
 * References signal "DrStatPsngr_B_Actl". Deprecated starting with RPC Spec 7.1.0.
 *
 * @deprecated in SmartDeviceLink 7.1.0
 * @added in SmartDeviceLink 2.0.0
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *passengerDoorAjar __deprecated_msg("use doorStatuses instead");

/**
 * References signal "DrStatRl_B_Actl". Deprecated starting with RPC Spec 7.1.0.
 *
 * @deprecated in SmartDeviceLink 7.1.0
 * @added in SmartDeviceLink 2.0.0
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *rearLeftDoorAjar __deprecated_msg("use doorStatuses instead");

/**
 * References signal "DrStatRr_B_Actl". Deprecated starting with RPC Spec 7.1.0.
 *
 * @deprecated in SmartDeviceLink 7.1.0
 * @added in SmartDeviceLink 2.0.0
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *rearRightDoorAjar __deprecated_msg("use doorStatuses instead");

/**
 * Provides status for doors if Ajar/Closed/Locked
 * {"array_min_size": 0, "array_max_size": 100}
 *
 * @added in SmartDeviceLink 7.1.0
 */
@property (nullable, strong, nonatomic) NSArray<SDLDoorStatus *> *doorStatuses;

/**
 * Provides status for trunk/hood/etc. if Ajar/Closed/Locked
 * {"array_min_size": 0, "array_max_size": 100}
 *
 * @added in SmartDeviceLink 7.1.0
 */
@property (nullable, strong, nonatomic) NSArray<SDLGateStatus *> *gateStatuses;

/**
 * Provides status for roof/convertible roof/sunroof/moonroof etc., if Closed/Ajar/Removed etc.
 * {"array_min_size": 0, "array_max_size": 100}
 *
 * @added in SmartDeviceLink 7.1.0
 */
@property (nullable, strong, nonatomic) NSArray<SDLRoofStatus *> *roofStatuses;

@end

NS_ASSUME_NONNULL_END
