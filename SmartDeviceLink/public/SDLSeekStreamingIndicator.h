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
#import "SDLSeekIndicatorType.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * The seek next / skip previous subscription buttons' content
 *
 * @added in SmartDeviceLink 7.1.0
 */
@interface SDLSeekStreamingIndicator : SDLRPCStruct

/**
 * @param type - type
 * @return A SDLSeekStreamingIndicator object
 */
- (instancetype)initWithType:(SDLSeekIndicatorType)type;

/**
 * @param type - type
 * @param seekTime - seekTime
 * @return A SDLSeekStreamingIndicator object
 */
- (instancetype)initWithType:(SDLSeekIndicatorType)type seekTime:(nullable NSNumber<SDLUInt> *)seekTime;

/**
 * @param seekTime - seekTime
 * @return A SDLSeekStreamingIndicator object
 */
+ (instancetype)seekIndicatorWithSeekTime:(NSUInteger)seekTime;

/// The type of seek indicator to be displayed on the module UI
@property (strong, nonatomic) SDLSeekIndicatorType type;

/**
 * If the type is TIME, this number of seconds may be present alongside the skip indicator. It will indicate the number of seconds that the currently playing media will skip forward or backward.
 * {"num_min_value": 1, "num_max_value": 99}
 */
@property (nullable, strong, nonatomic) NSNumber<SDLUInt> *seekTime;

@end

NS_ASSUME_NONNULL_END
