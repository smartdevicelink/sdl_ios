//  SDLHMISettingsControlCapabilities.h
//

#import "SDLRPCMessage.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLHMISettingsControlCapabilities : SDLRPCStruct

/**
 Constructs a newly allocated SDLHMISettingsControlCapabilities object with moduleName

 @param moduleName The short friendly name of the hmi setting module

 @return An instance of the SDLHMISettingsControlCapabilities class
 */
- (instancetype)initWithModuleName:(NSString *)moduleName;

/**
 Constructs a newly allocated SDLHMISettingsControlCapabilities object with given parameters

 @param moduleName The short friendly name of the hmi setting module
 @param distanceUnitAvailable Availability of the control of distance unit.
 @param temperatureUnitAvailable Availability of the control of temperature unit.
 @param displayModeUnitAvailable Availability of the control of displayMode unit.

 @return An instance of the SDLHMISettingsControlCapabilities class
 */
- (instancetype)initWithModuleName:(NSString *)moduleName distanceUnitAvailable:(BOOL)distanceUnitAvailable temperatureUnitAvailable:(BOOL)temperatureUnitAvailable displayModeUnitAvailable:(BOOL)displayModeUnitAvailable;

/**
 * @abstract The short friendly name of the hmi setting module.
 * It should not be used to identify a module by mobile application.
 *
 * Required, Max String length 100 chars
 */
@property (strong, nonatomic) NSString *moduleName;

/**
 * @abstract Availability of the control of distance unit.
 *
 * Optional, Boolean
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *distanceUnitAvailable;

/**
 * @abstract Availability of the control of temperature unit.
 *
 * Optional, Boolean
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *temperatureUnitAvailable;

/**
 * @abstract  Availability of the control of HMI display mode.
 *
 * Optional, Boolean
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *displayModeUnitAvailable;

@end

NS_ASSUME_NONNULL_END
