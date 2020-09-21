//
//  SDLClimateControlCapabilities.h
//

#import "SDLRPCMessage.h"
#import "SDLDefrostZone.h"
#import "SDLVentilationMode.h"
#import "SDLModuleInfo.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Contains information about a climate control module's capabilities.
 */
@interface SDLClimateControlCapabilities : SDLRPCStruct

/// Convenience init to describe the climate control capabilities with all properities.
///
/// @param moduleName The short friendly name of the climate control module.
/// @param moduleInfo Information about a RC module, including its id
/// @param fanSpeedAvailable Availability of the control of fan speed
/// @param desiredTemperatureAvailable Availability of the control of desired temperature
/// @param acEnableAvailable Availability of the control of turn on/off AC
/// @param acMaxEnableAvailable Availability of the control of enable/disable air conditioning is ON on the maximum level
/// @param circulateAirEnableAvailable Availability of the control of enable/disable circulate Air mode.
/// @param autoModeEnableAvailable Availability of the control of enable/disable auto mode
/// @param dualModeEnableAvailable Availability of the control of enable/disable dual mode
/// @param defrostZoneAvailable Availability of the control of defrost zones
/// @param ventilationModeAvailable Availability of the control of air ventilation mode
/// @param heatedSteeringWheelAvailable Availability of the control (enable/disable) of heated Steering Wheel
/// @param heatedWindshieldAvailable Availability of the control (enable/disable) of heated Windshield
/// @param heatedRearWindowAvailable  Availability of the control (enable/disable) of heated Rear Window
/// @param heatedMirrorsAvailable Availability of the control (enable/disable) of heated Mirrors
/// @param climateEnableAvailable Availability of the control of enable/disable climate control
/// @return An SDLClimateControlCapabilities object
- (instancetype)initWithModuleName:(NSString *)moduleName moduleInfo:(nullable SDLModuleInfo *)moduleInfo fanSpeedAvailable:(BOOL)fanSpeedAvailable desiredTemperatureAvailable:(BOOL)desiredTemperatureAvailable acEnableAvailable:(BOOL)acEnableAvailable acMaxEnableAvailable:(BOOL)acMaxEnableAvailable circulateAirAvailable:(BOOL)circulateAirEnableAvailable autoModeEnableAvailable:(BOOL)autoModeEnableAvailable dualModeEnableAvailable:(BOOL)dualModeEnableAvailable defrostZoneAvailable:(BOOL)defrostZoneAvailable ventilationModeAvailable:(BOOL)ventilationModeAvailable heatedSteeringWheelAvailable:(BOOL)heatedSteeringWheelAvailable heatedWindshieldAvailable:(BOOL)heatedWindshieldAvailable heatedRearWindowAvailable:(BOOL)heatedRearWindowAvailable heatedMirrorsAvailable:(BOOL)heatedMirrorsAvailable climateEnableAvailable:(BOOL)climateEnableAvailable;

/**
 * The short friendly name of the climate control module.
 * It should not be used to identify a module by mobile application.
 *
 * Max string length 100 chars

 Required
 */
@property (strong, nonatomic) NSString *moduleName;

/**
 * Availability of the control of fan speed.
 * True: Available, False: Not Available, Not present: Not Available.
 *
 * Optional, Boolean
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *fanSpeedAvailable;

/**
 * Availability of the control of desired temperature.
 * True: Available, False: Not Available, Not present: Not Available.
 *
 * Optional, Boolean
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *desiredTemperatureAvailable;

/**
 * Availability of the control of turn on/off AC.
 * True: Available, False: Not Available, Not present: Not Available.
 *
 * Optional, Boolean
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *acEnableAvailable;

/**
 *  Availability of the control of enable/disable air conditioning is ON on the maximum level.
 * True: Available, False: Not Available, Not present: Not Available.
 *
 * Optional, Boolean
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *acMaxEnableAvailable;

/**
 * Availability of the control of enable/disable circulate Air mode.
 * True: Available, False: Not Available, Not present: Not Available.
 *
 * Optional, Boolean
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *circulateAirEnableAvailable;

/**
 * Availability of the control of enable/disable auto mode.
 * True: Available, False: Not Available, Not present: Not Available.
 *
 * Optional, Boolean
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *autoModeEnableAvailable;

/**
 * Availability of the control of enable/disable dual mode.
 * True: Available, False: Not Available, Not present: Not Available.
 *
 * Optional, Boolean
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *dualModeEnableAvailable;

/**
 * Availability of the control of defrost zones.
 * True: Available, False: Not Available, Not present: Not Available.
 *
 * Optional, Boolean
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *defrostZoneAvailable;

/**
 * A set of all defrost zones that are controllable.
 *
 * Optional, NSArray of type SDLDefrostZone minsize="1" maxsize="100"
 */
@property (nullable, strong, nonatomic) NSArray<SDLDefrostZone > *defrostZone;

/**
 * Availability of the control of air ventilation mode.
 * True: Available, False: Not Available, Not present: Not Available.
 *
 * Optional, Boolean
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *ventilationModeAvailable;

/**
 * A set of all ventilation modes that are controllable.
 * True: Available, False: Not Available, Not present: Not Available.
 *
 * Optional, NSArray of type SDLVentilationMode minsize="1" maxsize="100"
 */
@property (nullable, strong, nonatomic) NSArray<SDLVentilationMode> *ventilationMode;

/**
 * @abstract Availability of the control (enable/disable) of heated Steering Wheel.
 * True: Available, False: Not Available, Not present: Not Available.
 *
 * Optional, Boolean
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *heatedSteeringWheelAvailable;

/**
 * @abstract  Availability of the control (enable/disable) of heated Windshield.
 * True: Available, False: Not Available, Not present: Not Available.
 *
 * Optional, Boolean
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *heatedWindshieldAvailable;

/**
 * @abstract Availability of the control (enable/disable) of heated Rear Window.
 * True: Available, False: Not Available, Not present: Not Available.
 *
 * Optional, Boolean
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *heatedRearWindowAvailable;

/**
 * @abstract Availability of the control (enable/disable) of heated Mirrors.
 * True: Available, False: Not Available, Not present: Not Available.
 *
 * Optional, Boolean
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *heatedMirrorsAvailable;

/**
 * @abstract Availability of the control of enable/disable climate control.
 * True: Available, False: Not Available, Not present: Not Available.
 *
 * Optional, Boolean
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *climateEnableAvailable;

/**
 *  Information about a RC module, including its id.
 *
 *  Optional
 */
@property (nullable, strong, nonatomic) SDLModuleInfo *moduleInfo;

@end

NS_ASSUME_NONNULL_END
