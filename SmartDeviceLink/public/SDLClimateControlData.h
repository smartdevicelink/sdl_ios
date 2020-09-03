//
//  SDLClimateControlData.h
//

#import "SDLRPCMessage.h"
#import "SDLDefrostZone.h"
#import "SDLVentilationMode.h"

NS_ASSUME_NONNULL_BEGIN

@class SDLTemperature;


/**
 The current information for the Climate Remote Control Module
 */
@interface SDLClimateControlData : SDLRPCStruct

/// Convenience init for climate control data with all properties.
/// @param fanSpeed Speed of Fan in integer
/// @param desiredTemperature Desired Temperature in SDLTemperature
/// @param acEnable Represents if AC is enabled
/// @param circulateAirEnable Represents if circulation of air is enabled
/// @param autoModeEnable Represents if auto mode is enabled
/// @param defrostZone Represents the kind of defrost zone
/// @param dualModeEnable Represents if dual mode is enabled
/// @param acMaxEnable Represents if ac max is enabled
/// @param ventilationMode Represents the kind of ventilation zone
/// @param heatedSteeringWheelEnable Represents if heated steering wheel is enabled
/// @param heatedWindshieldEnable Represents if heated windshield is enabled
/// @param heatedRearWindowEnable Represents if heated rear window is enabled
/// @param heatedMirrorsEnable Represents if heated mirrors are enabled
/// @param climateEnable Represents if climate is enabled
/// @return An SDLClimateControlData object
- (instancetype)initWithFanSpeed:(nullable NSNumber<SDLInt> *)fanSpeed desiredTemperature:(nullable SDLTemperature *)desiredTemperature acEnable:(nullable NSNumber<SDLBool> *)acEnable circulateAirEnable:(nullable NSNumber<SDLBool> *)circulateAirEnable autoModeEnable:(nullable NSNumber<SDLBool> *)autoModeEnable defrostZone:(nullable SDLDefrostZone)defrostZone dualModeEnable:(nullable NSNumber<SDLBool> *)dualModeEnable acMaxEnable:(nullable NSNumber<SDLBool> *)acMaxEnable ventilationMode:(nullable SDLVentilationMode)ventilationMode heatedSteeringWheelEnable:(nullable NSNumber<SDLBool> *)heatedSteeringWheelEnable heatedWindshieldEnable:(nullable NSNumber<SDLBool> *)heatedWindshieldEnable heatedRearWindowEnable:(nullable NSNumber<SDLBool> *)heatedRearWindowEnable heatedMirrorsEnable:(nullable NSNumber<SDLBool> *)heatedMirrorsEnable climateEnable:(nullable NSNumber<SDLBool> *)climateEnable;

/**
 * Speed of Fan in integer
 *
 * Optional, MinValue- 0 MaxValue= 100
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *fanSpeed;

/**
 * The Current Temperature in SDLTemperature
 *
 * @warning This property is readonly and cannot be set on the module.
 *
 * Optional
 */
@property (nullable, strong, nonatomic) SDLTemperature *currentTemperature;

/**
 * Desired Temperature in SDLTemperature
 *
 * Optional
 */
@property (nullable, strong, nonatomic) SDLTemperature *desiredTemperature;

/**
 * Represents if AC is enabled.
 *
 * Optional, Boolean
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *acEnable;

/**
 * Represents if circulation of air is enabled.
 *
 * Optional, Boolean
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *circulateAirEnable;

/**
 * Represents if auto mode is enabled.
 *
 * Optional, Boolean
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *autoModeEnable;

/**
 * Represents the kind of defrost zone.
 *
 * Optional, SDLDefrostZone
 */
@property (nullable, strong, nonatomic) SDLDefrostZone defrostZone;

/**
 * Represents if dual mode is enabled.
 *
 * Optional, Boolean
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *dualModeEnable;

/**
 * Represents if ac max is enabled.
 *
 * Optional, Boolean
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *acMaxEnable;

/**
 * Represents the kind of Ventilation zone.
 *
 * Optional, SDLVentilationMode
 */
@property (nullable, strong, nonatomic) SDLVentilationMode ventilationMode;

/**
 * @abstract value false means disabled/turn off, value true means enabled/turn on.
 *
 * Optional, Boolean
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *heatedSteeringWheelEnable;

/**
 * @abstract value false means disabled, value true means enabled.
 *
 * Optional, Boolean
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *heatedWindshieldEnable;

/**
 * @abstract value false means disabled, value true means enabled.
 *
 * Optional, Boolean
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *heatedRearWindowEnable;

/**
 * @abstract Value false means disabled, value true means enabled.
 *
 * Optional, Boolean
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *heatedMirrorsEnable;

/**
 * @abstract Value false means disabled, value true means enabled.
 *
 * Optional, Boolean
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *climateEnable;

@end

NS_ASSUME_NONNULL_END
