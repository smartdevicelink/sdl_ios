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

#import "SDLRPCStruct.h"

NS_ASSUME_NONNULL_BEGIN

/**
 Extended capabilities for an onboard navigation system
 */
@interface SDLNavigationCapability : SDLRPCStruct

/**
 * @param sendLocationEnabled - sendLocationEnabled
 * @param getWayPointsEnabled - getWayPointsEnabled
 * @return A SDLNavigationCapability object
 */
- (instancetype)initWithSendLocationEnabled:(nullable NSNumber<SDLBool> *)sendLocationEnabled getWayPointsEnabled:(nullable NSNumber<SDLBool> *)getWayPointsEnabled;

/// Convenience init with all parameters
///
/// @param sendLocationEnabled Whether or not the SendLocation RPC is enabled
/// @param waypointsEnabled Whether SDLNavigationInstruction.hor not Waypoint related RPCs are enabled
/// @return An SDLNavigationCapability object
- (instancetype)initWithSendLocation:(BOOL)sendLocationEnabled waypoints:(BOOL)waypointsEnabled;

/**
 Whether or not the SendLocation RPC is enabled.

 Boolean, optional
 */
@property (nullable, copy, nonatomic) NSNumber *sendLocationEnabled;

/**
 Whether or not Waypoint related RPCs are enabled.

 Boolean, optional
 */
@property (nullable, copy, nonatomic) NSNumber *getWayPointsEnabled;

@end

NS_ASSUME_NONNULL_END
