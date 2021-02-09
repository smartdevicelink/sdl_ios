/*
 * Copyright (c) 2021, SmartDeviceLink Consortium, Inc.
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

@class SDLKeyboardLayoutCapability;

NS_ASSUME_NONNULL_BEGIN

/**
 * @added in SmartDeviceLink 7.1.0
 */
@interface SDLKeyboardCapabilities : SDLRPCStruct

/**
 * @param maskInputCharactersSupported - maskInputCharactersSupported
 * @param supportedKeyboards - supportedKeyboards
 * @return A SDLKeyboardCapabilities object
 */
- (instancetype)initWithMaskInputCharactersSupported:(nullable NSNumber<SDLBool> *)maskInputCharactersSupported supportedKeyboards:(nullable NSArray<SDLKeyboardLayoutCapability *> *)supportedKeyboards;

/**
 * Availability of capability to mask input characters using keyboard. True: Available, False: Not Available
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *maskInputCharactersSupported;

/**
 * Capabilities of supported keyboard layouts by HMI.
 * {"array_min_size": 1, "array_max_size": 1000}
 */
@property (nullable, strong, nonatomic) NSArray<SDLKeyboardLayoutCapability *> *supportedKeyboards;

@end

NS_ASSUME_NONNULL_END