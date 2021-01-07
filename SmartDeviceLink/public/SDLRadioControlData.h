/*
 * Copyright (c) 2020, SmartDeviceLink Consortium, Inc.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * Redistributions of source code must retain the above copyright notice, this
 * list of conditions and the following disclaimer.
 *
 * Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following
 * disclaimer in the documentation and/or other materials provided with the
 * distribution.
 *
 * Neither the name of the SmartDeviceLink Consortium Inc. nor the names of
 * its contributors may be used to endorse or promote products derived
 * from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */

#import "SDLRPCMessage.h"
#import "SDLRadioBand.h"
#import "SDLRadioState.h"

@class SDLRDSData;
@class SDLSISData;

NS_ASSUME_NONNULL_BEGIN

/**
 * Include information (both read-only and changeable data) about a remote control radio module.
 *
 * @added in SmartDeviceLink 4.5.0
 */
@interface SDLRadioControlData : SDLRPCStruct

/**
 * @param frequencyInteger - frequencyInteger
 * @param frequencyFraction - frequencyFraction
 * @param band - band
 * @param rdsData - rdsData
 * @param hdRadioEnable - hdRadioEnable
 * @param availableHdChannels - availableHdChannels
 * @param hdChannel - hdChannel
 * @param signalStrength - signalStrength
 * @param signalChangeThreshold - signalChangeThreshold
 * @param radioEnable - radioEnable
 * @param state - state
 * @param sisData - sisData
 * @return A SDLRadioControlData object
 */
- (instancetype)initWithFrequencyInteger:(nullable NSNumber<SDLUInt> *)frequencyInteger frequencyFraction:(nullable NSNumber<SDLUInt> *)frequencyFraction band:(nullable SDLRadioBand)band rdsData:(nullable SDLRDSData *)rdsData hdRadioEnable:(nullable NSNumber<SDLBool> *)hdRadioEnable availableHdChannels:(nullable NSArray<NSNumber<SDLUInt> *> *)availableHdChannels hdChannel:(nullable NSNumber<SDLUInt> *)hdChannel signalStrength:(nullable NSNumber<SDLUInt> *)signalStrength signalChangeThreshold:(nullable NSNumber<SDLUInt> *)signalChangeThreshold radioEnable:(nullable NSNumber<SDLBool> *)radioEnable state:(nullable SDLRadioState)state sisData:(nullable SDLSISData *)sisData;

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
- (instancetype)initWithFrequencyInteger:(nullable NSNumber<SDLInt> *)frequencyInteger frequencyFraction:(nullable NSNumber<SDLInt> *)frequencyFraction band:(nullable SDLRadioBand)band hdChannel:(nullable NSNumber<SDLInt> *)hdChannel radioEnable:(nullable NSNumber<SDLBool> *)radioEnable hdRadioEnable:(nullable NSNumber<SDLBool> *)hdRadioEnable __deprecated_msg("Use another initializer");

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
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *availableHDs __deprecated_msg("Use availableHdChannels instead");

/**
 * The list of available HD sub-channel indexes. Empty list means no Hd channel is available. Read-only.
 * {"array_min_size": 0, "array_max_size": 8, "num_min_value": 0, "num_max_value": 7}
 *
 * @added in SmartDeviceLink 6.0.0
 */
@property (nullable, strong, nonatomic) NSArray<NSNumber<SDLUInt> *> *availableHdChannels;

/**
 * the list of available hd sub-channel indexes, empty list means no Hd channel is available, read-only
 *
 * @warning This property is readonly and cannot be set on the module.
 *
 * Integer value Min Value - 0 Max Value -7
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *availableHDChannels __deprecated_msg("Use availableHdChannels instead");

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
