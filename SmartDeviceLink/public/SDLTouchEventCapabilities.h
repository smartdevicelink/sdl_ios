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
 The capabilities of touches during projection applications

 @added in SmartDeviceLink 3.0.0
 */
@interface SDLTouchEventCapabilities : SDLRPCStruct

/**
 * @param pressAvailable - @(pressAvailable)
 * @param multiTouchAvailable - @(multiTouchAvailable)
 * @param doublePressAvailable - @(doublePressAvailable)
 * @return A SDLTouchEventCapabilities object
 */
- (instancetype)initWithPressAvailable:(BOOL)pressAvailable multiTouchAvailable:(BOOL)multiTouchAvailable doublePressAvailable:(BOOL)doublePressAvailable;

/**
 Whether or not long presses are available
 */
@property (strong, nonatomic) NSNumber<SDLBool> *pressAvailable;

/**
 Whether or not multi-touch (e.g. a pinch gesture) is available
 */
@property (strong, nonatomic) NSNumber<SDLBool> *multiTouchAvailable;

/**
 Whether or not a double tap is available
 */
@property (strong, nonatomic) NSNumber<SDLBool> *doublePressAvailable;

@end

NS_ASSUME_NONNULL_END
