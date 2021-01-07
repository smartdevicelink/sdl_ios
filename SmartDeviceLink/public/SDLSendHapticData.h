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

#import <Foundation/Foundation.h>
#import "SDLRPCRequest.h"

@class SDLHapticRect;

NS_ASSUME_NONNULL_BEGIN

/**
 * Send the spatial data gathered from SDLCarWindow or VirtualDisplayEncoder to the HMI. This data will be utilized by the HMI to determine how and when haptic events should occur
 *
 * @added in SmartDeviceLink 4.5.0
 */
@interface SDLSendHapticData : SDLRPCRequest

/**
 *  Constructs a new SDLSendHapticData object indicated by the hapticSpatialData parameter
 *
 *  @param hapticRectData Array of spatial data structures
 */
- (instancetype)initWithHapticRectData:(nullable NSArray<SDLHapticRect *> *)hapticRectData;

/**
 *  Array of spatial data structures that represent the locations of all user controls present on the HMI. This data should be updated if/when the application presents a new screen. When a request is sent, if successful, it will replace all spatial data previously sent through RPC. If an empty array is sent, the existing spatial data will be cleared
 *
 *  Optional, Array of SDLHapticRect, Array size 0 - 1,000
 */
@property (strong, nonatomic, nullable) NSArray<SDLHapticRect *> *hapticRectData;

@end

NS_ASSUME_NONNULL_END
