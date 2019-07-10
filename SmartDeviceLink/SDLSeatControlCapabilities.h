//  SDLSeatControlCapabilities.h
//


#import "SDLRPCStruct.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Include information about a seat control capabilities.
 */
@interface SDLSeatControlCapabilities : SDLRPCStruct

- (instancetype)initWithName:(NSString *)moduleName;

- (instancetype)initWithName:(NSString *)moduleName heatingEnabledAvailable:(BOOL)heatingEnabledAvail
 coolingEnabledAvailable:(BOOL)coolingEnabledAvail heatingLevelAvailable:(BOOL)heatingLevelAvail coolingLevelAvailable:(BOOL)coolingLevelAvail horizontalPositionAvailable:(BOOL)horizontalPositionAvail verticalPositionAvailable:(BOOL)verticalPositionAvail frontVerticalPositionAvailable:(BOOL)frontVerticalPositionAvail backVerticalPositionAvailable:(BOOL)backVerticalPositionAvail backTiltAngleAvailable:(BOOL)backTitlAngleAvail headSupportHorizontalPositionAvailable:(BOOL)headSupportHorizontalPositionAvail headSupportVerticalPositionAvailable:(BOOL)headSupportVerticalPositionAvail massageEnabledAvailable:(BOOL)massageEnabledAvail massageModeAvailable:(BOOL)massageModeAvail massageCushionFirmnessAvailable:(BOOL)massageCushionFirmnessAvail memoryAvailable:(BOOL)memoryAvail;
/**
 * @abstract The short friendly name of the light control module.
 * It should not be used to identify a module by mobile application.
 *
 * Required, Max length 100 chars
 */
@property (strong, nonatomic) NSString *moduleName;

/**
 * @abstract Whether or not heating is Available.

 * Optional
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *heatingEnabledAvailable;

/**
 * @abstract Whether or not cooling is Available.

 * Optional
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *coolingEnabledAvailable;

/**
 * @abstract Whether or not heating level is Available.

 * Optional
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *heatingLevelAvailable;

/**
 * @abstract Whether or not cooling level is Available.

 * Optional
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *coolingLevelAvailable;

/**
 * @abstract Whether or not horizontal Position is Available.

 * Optional
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *horizontalPositionAvailable;

/**
 * @abstract Whether or not vertical Position is Available.

 * Optional
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *verticalPositionAvailable;

/**
 * @abstract Whether or not front Vertical Position is Available.

 * Optional
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *frontVerticalPositionAvailable;

/**
 * @abstract Whether or not back Vertical Position is Available.

 * Optional
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *backVerticalPositionAvailable;

/**
 * @abstract Whether or not backTilt Angle Available is Available.

 * Optional
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *backTiltAngleAvailable;

/**
 * @abstract Whether or not head Supports for Horizontal Position is Available.

 * Optional
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *headSupportHorizontalPositionAvailable;

/**
 * @abstract Whether or not head Supports for Vertical Position is Available.

 * Optional
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *headSupportVerticalPositionAvailable;

/**
 * @abstract Whether or not massage Enabled is Available.

 * Optional
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *massageEnabledAvailable;

/**
 * @abstract Whether or not massage Mode is Available.

 * Optional
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *massageModeAvailable;

/**
 * @abstract Whether or not massage Cushion Firmness is Available.

 * Optional
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *massageCushionFirmnessAvailable;

/**
 * @abstract Whether or not memory is Available.

 * Optional
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *memoryAvailable;


@end

NS_ASSUME_NONNULL_END
