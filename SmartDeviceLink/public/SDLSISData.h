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

@class SDLStationIDNumber;
@class SDLGPSData;

NS_ASSUME_NONNULL_BEGIN

/**
 * HD radio Station Information Service (SIS) data.
 *
 * @added in SmartDeviceLink 5.0.0
 */
@interface SDLSISData : SDLRPCStruct

/// Convenience init to SISData
///
/// @param stationShortName Identifies the 4-alpha-character station call sign
/// @param id A SDLStationIDNumber
/// @param stationLongName Identifies the station call sign or other identifying
/// @param stationLocation Provides the 3-dimensional geographic station location
/// @param stationMessage May be used to convey textual information of general interest
/// @return An SDLSISData object
- (instancetype)initWithStationShortName:(nullable NSString *)stationShortName stationIDNumber:(nullable SDLStationIDNumber *)id stationLongName:(nullable NSString *)stationLongName stationLocation:(nullable SDLGPSData *)stationLocation stationMessage:(nullable NSString *)stationMessage;

/**
 * @abstract Identifies the 4-alpha-character station call sign
 * plus an optional (-FM) extension
 *
 * Optional, String, minLength: 4characters maxlength: 7characters
 */
@property (nullable, strong, nonatomic) NSString *stationShortName;

/**
 * @abstract Used for network Application.
 * Consists of Country Code and FCC Facility ID.
 *
 * Optional, SDLStationIDNumber type
 */
@property (nullable, strong, nonatomic) SDLStationIDNumber *stationIDNumber;

/**
 * @abstract Identifies the station call sign or other identifying
 * information in the long format.
 *
 * Optional, String, minLength: 0characters maxlength: 56characters
 */
@property (nullable, strong, nonatomic) NSString *stationLongName;

/**
 * @abstract Provides the 3-dimensional geographic station location
 *
 * Optional, SDLGPSData type
 */
@property (nullable, strong, nonatomic) SDLGPSData *stationLocation;

/**
 * @abstract May be used to convey textual information of general interest
 * to the consumer such as weather forecasts or public service announcements.
 *
 * Optional, String, minLength: 0characters maxlength: 56characters
 */
@property (nullable, strong, nonatomic) NSString *stationMessage;

@end

NS_ASSUME_NONNULL_END
