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

#import "SDLButtonName.h"
#import "SDLModuleInfo.h"


/**
 * Provides information about the capabilities of a SDL HMI button.
 * 
 * @since SDL 1.0
 */

NS_ASSUME_NONNULL_BEGIN

@interface SDLButtonCapabilities : SDLRPCStruct

/**
 * @param nameParam - nameParam
 * @param shortPressAvailable - @(shortPressAvailable)
 * @param longPressAvailable - @(longPressAvailable)
 * @param upDownAvailable - @(upDownAvailable)
 * @return A SDLButtonCapabilities object
 */
- (instancetype)initWithNameParam:(SDLButtonName)nameParam shortPressAvailable:(BOOL)shortPressAvailable longPressAvailable:(BOOL)longPressAvailable upDownAvailable:(BOOL)upDownAvailable;

/**
 * @param nameParam - nameParam
 * @param shortPressAvailable - @(shortPressAvailable)
 * @param longPressAvailable - @(longPressAvailable)
 * @param upDownAvailable - @(upDownAvailable)
 * @param moduleInfo - moduleInfo
 * @return A SDLButtonCapabilities object
 */
- (instancetype)initWithNameParam:(SDLButtonName)nameParam shortPressAvailable:(BOOL)shortPressAvailable longPressAvailable:(BOOL)longPressAvailable upDownAvailable:(BOOL)upDownAvailable moduleInfo:(nullable SDLModuleInfo *)moduleInfo;

/**
 * The name of the button. See ButtonName.
 */
@property (strong, nonatomic) SDLButtonName nameParam;

/**
 * The name of the SDL HMI button.

 Required
 */
@property (strong, nonatomic) SDLButtonName name __deprecated_msg("Use nameParam instead");

/**
 * A NSNumber value indicates whether the button supports a SHORT press
 *
 * Required, Boolean
 */
@property (strong, nonatomic) NSNumber<SDLBool> *shortPressAvailable;

/**
 * A NSNumber value indicates whether the button supports a LONG press
 *
 * Required, Boolean
 */
@property (strong, nonatomic) NSNumber<SDLBool> *longPressAvailable;

/**
 * A NSNumber value indicates whether the button supports "button down" and "button up"
 *
 * Required, Boolean
 */
@property (strong, nonatomic) NSNumber<SDLBool> *upDownAvailable;

/**
 *  Information about a RC module, including its id.
 *
 *  Optional
 */
@property (nullable, strong, nonatomic) SDLModuleInfo *moduleInfo;

@end

NS_ASSUME_NONNULL_END
