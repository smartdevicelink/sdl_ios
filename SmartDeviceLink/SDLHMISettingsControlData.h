//  SDLHMISettingsControlData.h
//

#import "SDLRPCMessage.h"
#import "SDLDisplayMode.h"
#import "SDLTemperatureUnit.h"
#import "SDLDistanceUnit.h"

/**
 * Corresponds to "HMI_SETTINGS" ModuleType
 */

NS_ASSUME_NONNULL_BEGIN

@interface SDLHMISettingsControlData : SDLRPCStruct

/**
 Constructs a newly allocated SDLHMISettingsControlCapabilities object with given parameters

 @param displayMode Display Mode used in HMI setting
 @param temperatureUnit temperature unit used in HMI setting
 @param distanceUnit distance unit used in HMI setting
 @return An instance of the SDLHMISettingsControlCapabilities class
 */
- (instancetype)initWithDisplaymode:(SDLDisplayMode)displayMode temperatureUnit:(SDLTemperatureUnit)temperatureUnit distanceUnit:(SDLDistanceUnit)distanceUnit;

/**
 * @abstract Display the Display Mode used HMI setting
 *
 * Optional, SDLDisplayMode
 */
@property (nullable, strong, nonatomic) SDLDisplayMode displayMode;

/**
 * @abstract Display the temperature unit used HMI setting
 *
 * Optional, SDLTemperatureUnit
 */
@property (nullable, strong, nonatomic) SDLTemperatureUnit temperatureUnit;

/**
 * @abstract Display the distance unit used HMI setting
 *
 * Optional, SDLDistanceUnit
 */
@property (nullable, strong, nonatomic) SDLDistanceUnit distanceUnit;

@end

NS_ASSUME_NONNULL_END
