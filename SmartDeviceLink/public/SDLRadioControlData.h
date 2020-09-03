//
//  SDLRadioControlData.h
//

#import "SDLRPCMessage.h"
#import "SDLRadioBand.h"
#import "SDLRadioState.h"

@class SDLRDSData;
@class SDLSISData;

NS_ASSUME_NONNULL_BEGIN

/**
 * Include information (both read-only and changeable data) about a remote control radio module.
 */
@interface SDLRadioControlData : SDLRPCStruct

/**
 Constructs a newly allocated SDLRadioControlCapabilities object with given parameters.

 @param frequencyInteger integer part of the frequency
 @param frequencyFraction fractional part of the frequency
 @param band Radio band value
 @param hdChannel Current HD sub-channel
 @param radioEnable whether or not radio is enabled
 @param hdRadioEnable whether or not hdradio is enabled
 @return An instance of the SDLRadioControlData class
 */
- (instancetype)initWithFrequencyInteger:(nullable NSNumber<SDLInt> *)frequencyInteger frequencyFraction:(nullable NSNumber<SDLInt> *)frequencyFraction band:(nullable SDLRadioBand)band hdChannel:(nullable NSNumber<SDLInt> *)hdChannel radioEnable:(nullable NSNumber<SDLBool> *)radioEnable hdRadioEnable:(nullable NSNumber<SDLBool> *)hdRadioEnable;

/// Constructs a newly allocated SDLRadioControlCapabilities object with given parameters.
///
/// @param frequencyInteger Must be between 0 and 1710
/// @param frequencyFraction Must be between 0 and 9
/// @param hdChannel Must be between 0 and 7
/// @return An instance of the SDLRadioControlData class
- (instancetype)initFMWithFrequencyInteger:(nullable NSNumber<SDLInt> *)frequencyInteger frequencyFraction:(nullable NSNumber<SDLInt> *)frequencyFraction hdChannel:(nullable NSNumber<SDLInt> *)hdChannel;

/// Constructs a newly allocated SDLRadioControlCapabilities object with given parameters.
///
/// @param frequencyInteger Must be between 0 and 1710
/// @param hdChannel Must be between 0 and 7
/// @return An instance of the SDLRadioControlData class
- (instancetype)initAMWithFrequencyInteger:(nullable NSNumber<SDLInt> *)frequencyInteger hdChannel:(nullable NSNumber<SDLInt> *)hdChannel;

/// Constructs a newly allocated SDLRadioControlCapabilities object with given parameters.
///
/// @param frequencyInteger Must be between 1 and 1710
/// @return An instance of the SDLRadioControlData class
- (instancetype)initXMWithFrequencyInteger:(nullable NSNumber<SDLInt> *)frequencyInteger;

/**
 * The integer part of the frequency ie for 101.7 this value should be 101
 *
 * Integer
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *frequencyInteger;

/**
 * The fractional part of the frequency for 101.7 is 7
 *
 * Integer
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *frequencyFraction;

/**
 * Radio band value
 *
 * SDLRadioBand
 */
@property (nullable, strong, nonatomic) SDLRadioBand band;

/**
 * Read only parameter. See RDSData data type for details.
 *
 * @warning This property is readonly and cannot be set on the module.
 *
 *SDLRDSData
 */
@property (nullable, strong, nonatomic) SDLRDSData *rdsData;

/**
 * number of HD sub-channels if available
 *
 * @warning This property is readonly and cannot be set on the module.
 *
 * Integer value Min Value - 1 Max Value -7
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *availableHDs __deprecated_msg("Use availableHDChannels instead");

/**
 * the list of available hd sub-channel indexes, empty list means no Hd channel is available, read-only
 *
 * @warning This property is readonly and cannot be set on the module.
 *
 * Integer value Min Value - 0 Max Value -7
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *availableHDChannels;

/**
 * Current HD sub-channel if available
 *
 * Integer value Min Value - 0 Max Value -7
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *hdChannel;

/**
 * Signal Strength Value
 *
 * @warning This property is readonly and cannot be set on the module.
 *
 * Integer value Min Value - 0 Max Value - 100
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *signalStrength;

/**
 * If the signal strength falls below the set value for this parameter, the radio will tune to an alternative frequency
 *
 * @warning This property is readonly and cannot be set on the module.
 *
 * Integer value Min Value - 0 Max Value - 100
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *signalChangeThreshold;

/**
 * True if the radio is on, false is the radio is off. When the radio is disabled, no data other than radioEnable is included in a GetInteriorVehicleData response
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

/**
 * True if the hd radio is on, false is the radio is off
 *
 * Boolean value
 */
@property (nullable, strong, nonatomic)  NSNumber<SDLBool> *hdRadioEnable;

/**
 * Read Read-only Station Information Service (SIS) data provides basic information
 * about the station such as call sign,
 * as well as information not displayable to the consumer such as the station identification number
 *
 * Optional, SDLSISData
 */
@property (nullable, strong, nonatomic) SDLSISData *sisData;

@end

NS_ASSUME_NONNULL_END
