//
//  SDLRadioControlData.h
//

#import "SDLRPCMessage.h"
#import "SDLRadioBand.h"
#import "SDLRadioState.h"

@class SDLRDSData;

/**
 * Include information (both read-only and changeable data) about a remote control radio module.
 */

NS_ASSUME_NONNULL_BEGIN

@interface SDLRadioControlData : SDLRPCStruct

- (instancetype)initWithFrequencyInteger:(nullable NSNumber<SDLInt> *)frequencyInteger frequencyFraction:(nullable NSNumber<SDLInt> *)frequencyFraction band:(nullable SDLRadioBand)band hdChannel:(nullable NSNumber<SDLInt> *)hdChannel radioEnable:(nullable NSNumber<SDLBool> *)radioEnable;

/**
 * @abstract The integer part of the frequency ie for 101.7 this value should be 101
 *
 * Integer
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *frequencyInteger;

/**
 * @abstract The fractional part of the frequency for 101.7 is 7
 *
 * Integer
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *frequencyFraction;

/**
 * @abstract Radio band value
 *
 * SDLRadioBand
 */
@property (nullable, strong, nonatomic) SDLRadioBand band;

/**
 * @abstract Read only parameter. See RDSData data type for details.
 *
 * @warning This property is readonly and cannot be set on the module.
 *
 *SDLRDSData
 */
@property (nullable, strong, nonatomic) SDLRDSData *rdsData;

/**
 * @abstract number of HD sub-channels if available
 *
 * @warning This property is readonly and cannot be set on the module.
 *
 * Integer value Min Value - 1 Max Value -3
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *availableHDs;

/**
 * @abstract Current HD sub-channel if available
 *
 * Integer value Min Value - 1 Max Value -3
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *hdChannel;

/**
 * @abstract Signal Strength Value
 *
 * @warning This property is readonly and cannot be set on the module.
 *
 * Integer value Min Value - 0 Max Value - 100
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *signalStrength;

/**
 * @abstract If the signal strength falls below the set value for this parameter, the radio will tune to an alternative frequency
 *
 * @warning This property is readonly and cannot be set on the module.
 *
 * Integer value Min Value - 0 Max Value - 100
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *signalChangeThreshold;

/**
 * @abstract  True if the radio is on, false is the radio is off
 *
 * Boolean value
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *radioEnable;

/**
 * Read only parameter. See RadioState data type for details.
 *
 * @warning This property is readonly and cannot be set on the module.
 *
 * SDLRadioState
 */
@property (nullable, strong, nonatomic) SDLRadioState state;

@end

NS_ASSUME_NONNULL_END
