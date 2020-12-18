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

#import "SDLKeyboardLayout.h"
#import "SDLRPCStruct.h"

@class SDLConfigurableKeyboards;

NS_ASSUME_NONNULL_BEGIN

/**
 * @added in SmartDeviceLink 7.1.0
 */
@interface SDLKeyboardCapabilities : SDLRPCStruct

/**
 * @param maskInputCharactersSupported - maskInputCharactersSupported
 * @param supportedKeyboardLayouts - supportedKeyboardLayouts
 * @param configurableKeys - configurableKeys
 * @return A SDLKeyboardCapabilities object
 */
- (instancetype)initWithMaskInputCharactersSupported:(nullable NSNumber<SDLBool> *)maskInputCharactersSupported supportedKeyboardLayouts:(nullable NSArray<SDLKeyboardLayout> *)supportedKeyboardLayouts configurableKeys:(nullable NSArray<SDLConfigurableKeyboards *> *)configurableKeys;

/**
 * Availability of capability to mask input characters using keyboard. True: Available, False: Not Available
 *
 * @added in SmartDeviceLink 7.1.0
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *maskInputCharactersSupported;

/**
 * Supported keyboard layouts by HMI.
 * {"array_min_size": 1, "array_max_size": 1000}
 *
 * @added in SmartDeviceLink 7.1.0
 */
@property (nullable, strong, nonatomic) NSArray<SDLKeyboardLayout> *supportedKeyboardLayouts;

/**
 * Get Number of Keys for Special characters, App can customize as per their needs.
 * {"array_min_size": 1, "array_max_size": 1000}
 *
 * @added in SmartDeviceLink 7.1.0
 */
@property (nullable, strong, nonatomic) NSArray<SDLConfigurableKeyboards *> *configurableKeys;

@end

NS_ASSUME_NONNULL_END
