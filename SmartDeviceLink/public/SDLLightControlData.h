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

@class SDLLightState;

NS_ASSUME_NONNULL_BEGIN

/// Data about the current light controls
///
/// @since SDL 5.0
@interface SDLLightControlData : SDLRPCStruct

/**
 * @param lightState - lightState
 * @return A SDLLightControlData object
 */
- (instancetype)initWithLightState:(NSArray<SDLLightState *> *)lightState;

/**
 Constructs a newly allocated SDLLightControlData object with lightState

 @param lightState An array of LightNames and their current or desired status
 @return An instance of the SDLLightControlData class
 */
- (instancetype)initWithLightStates:(NSArray<SDLLightState *> *)lightState __deprecated_msg("Use initWithLightState: instead");

/**
 * @abstract An array of LightNames and their current or desired status.
 * Status of the LightNames that are not listed in the array shall remain unchanged.
 *
 * Required, NSArray of type SDLLightState minsize="1" maxsize="100"
 */
@property (strong, nonatomic) NSArray<SDLLightState *> *lightState;

@end

NS_ASSUME_NONNULL_END
