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


#import "SDLRPCRequest.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Non periodic vehicle data read request. This is an RPC to get diagnostics
 * data from certain vehicle modules. DIDs of a certain module might differ from
 * vehicle type to vehicle type
 * <p>
 * Function Group: ProprietaryData
 * <p>
 * <b>HMILevel needs to be FULL, LIMITED or BACKGROUND</b>
 * <p>
 *
 * Since SmartDeviceLink 2.0
 */
@interface SDLReadDID : SDLRPCRequest

/**
 * @param ecuName - @(ecuName)
 * @param didLocation - didLocation
 * @return A SDLReadDID object
 */
- (instancetype)initWithEcuName:(UInt16)ecuName didLocation:(NSArray<NSNumber<SDLUInt> *> *)didLocation;

/// Convenience init
///
/// @param ecuNumber An ID of the vehicle module
/// @param didLocation Raw data from vehicle data DID location(s)
/// @return An SDLReadDID object
- (instancetype)initWithECUName:(UInt16)ecuNumber didLocation:(NSArray<NSNumber<SDLUInt> *> *)didLocation __deprecated_msg("Use initWithEcuName:didLocation: instead");

/**
 * An ID of the vehicle module
 *            <br/><b>Notes: </b>Minvalue:0; Maxvalue:65535
 */
@property (strong, nonatomic) NSNumber<SDLInt> *ecuName;

/**
 * Raw data from vehicle data DID location(s)
 *            <br/>a Vector<Integer> value representing raw data from vehicle
 *            data DID location(s)
 *            <p>
 *            <b>Notes: </b>
 *            <ul>
 *            <li>Minvalue:0; Maxvalue:65535</li>
 *            <li>ArrayMin:0; ArrayMax:1000</li>
 *            </ul>
 *
 * Mandatory, contains an integer
 */
@property (strong, nonatomic) NSArray<NSNumber *> *didLocation;

@end

NS_ASSUME_NONNULL_END
