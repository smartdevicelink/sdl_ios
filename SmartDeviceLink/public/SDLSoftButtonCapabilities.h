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

NS_ASSUME_NONNULL_BEGIN

/**
 * Contains information about a SoftButton's capabilities.
 *
 * @since SDL 2.0
 */
@interface SDLSoftButtonCapabilities : SDLRPCStruct

/**
 * @param shortPressAvailable - @(shortPressAvailable)
 * @param longPressAvailable - @(longPressAvailable)
 * @param upDownAvailable - @(upDownAvailable)
 * @param imageSupported - @(imageSupported)
 * @return A SDLSoftButtonCapabilities object
 */
- (instancetype)initWithShortPressAvailable:(BOOL)shortPressAvailable longPressAvailable:(BOOL)longPressAvailable upDownAvailable:(BOOL)upDownAvailable imageSupported:(BOOL)imageSupported;

/**
 * @param shortPressAvailable - @(shortPressAvailable)
 * @param longPressAvailable - @(longPressAvailable)
 * @param upDownAvailable - @(upDownAvailable)
 * @param imageSupported - @(imageSupported)
 * @param textSupported - textSupported
 * @return A SDLSoftButtonCapabilities object
 */
- (instancetype)initWithShortPressAvailable:(BOOL)shortPressAvailable longPressAvailable:(BOOL)longPressAvailable upDownAvailable:(BOOL)upDownAvailable imageSupported:(BOOL)imageSupported textSupported:(nullable NSNumber<SDLBool> *)textSupported;

/**
 * The button supports a short press.
 *
 * Whenever the button is pressed short, onButtonPressed(SHORT) will be invoked.
 *
 * Required, Boolean
 */
@property (strong, nonatomic) NSNumber<SDLBool> *shortPressAvailable;

/**
 * The button supports a LONG press.
 *
 * Whenever the button is pressed long, onButtonPressed(LONG) will be invoked.
 *
 * Required, Boolean
 */
@property (strong, nonatomic) NSNumber<SDLBool> *longPressAvailable;

/**
 * The button supports "button down" and "button up".
 *
 * Whenever the button is pressed, onButtonEvent(DOWN) will be invoked. Whenever the button is released, onButtonEvent(UP) will be invoked.
 *
 * Required, Boolean
 */
@property (strong, nonatomic) NSNumber<SDLBool> *upDownAvailable;

/**
 * The button supports referencing a static or dynamic image.
 *
 * Required, Boolean
 */
@property (strong, nonatomic) NSNumber<SDLBool> *imageSupported;

/**
 The button supports the use of text. If not included, the default value should be considered true that the button will support text.
 
 Optional, Boolean
 
 @since SDL 6.0
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *textSupported;

@end

NS_ASSUME_NONNULL_END
