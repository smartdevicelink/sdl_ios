//
//  SDLClimateControlData.h
//

#import "SDLRPCMessage.h"
#import "SDLDefrostZone.h"
#import "SDLVentilationMode.h"

NS_ASSUME_NONNULL_BEGIN

@class SDLTemperature;


@interface SDLClimateControlData : SDLRPCStruct

/**
 * @abstract Speed of Fan in integer
 *
 * Optional, MinValue- 0 MaxValue= 100
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *fanSpeed;

/**
 * @abstractThe Current Temperature in SDLTemperature
 *
 * Optional
 */
@property (nullable, strong, nonatomic) SDLTemperature *currentTemperature;

/**
 * @abstract Desired Temperature in SDLTemperature
 *
 * Optional
 */
@property (nullable, strong, nonatomic) SDLTemperature *desiredTemperature;

/**
 * @abstract Represents if AC is enabled.
 *
 * Optional, Boolean
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *acEnable;

/**
 * @abstract Represents if circulation of air is enabled.
 *
 * Optional, Boolean
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *circulateAirEnable;

/**
 * @abstract Represents if auto mode is enabled.
 *
 * Optional, Boolean
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *autoModeEnable;

/**
 * @abstract Represents the kind of defrost zone
 *
 * Optional, SDLDefrostZone
 */
@property (nullable, strong, nonatomic) SDLDefrostZone defrostZone;

/**
 * @abstract Represents if dual mode is enabled.
 *
 * Optional, Boolean
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *dualModeEnable;

/**
 * @abstract Represents if ac max is enabled.
 *
 * Optional, Boolean
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *acMaxEnable;

/**
 * @abstract Represents the kind of Ventilation zone
 *
 * Optional, SDLVentilationMode
 */
@property (nullable, strong, nonatomic) SDLVentilationMode ventilationMode;

@end

NS_ASSUME_NONNULL_END
