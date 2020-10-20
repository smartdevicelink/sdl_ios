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
 * Defines the each Equalizer channel settings.
 */

@interface SDLEqualizerSettings : SDLRPCStruct

/// Convenience init
///
/// @param channelId Read-only channel / frequency name
/// @param channelSetting Reflects the setting, from 0%-100%.
- (instancetype)initWithChannelId:(UInt8)channelId channelSetting:(UInt8)channelSetting;

/**
 * @param channelId - @(channelId)
 * @param channelSetting - @(channelSetting)
 * @param channelName - channelName
 * @return A SDLEqualizerSettings object
 */
- (instancetype)initWithChannelId:(UInt8)channelId channelSetting:(UInt8)channelSetting channelName:(nullable NSString *)channelName;

/**
 * @abstract Read-only channel / frequency name
 * (e.i. "Treble, Midrange, Bass" or "125 Hz")
 *
 * Optional, Max String length 50 chars
 */
@property (nullable, strong, nonatomic) NSString *channelName;


/**
 * @abstract Reflects the setting, from 0%-100%.
 *
 * Required, Integer 1 - 100
 */
@property (strong, nonatomic) NSNumber<SDLInt> *channelSetting;

/**
 * @abstract id of the channel.
 *
 * Required, Integer 1 - 100
 */
@property (strong, nonatomic) NSNumber<SDLInt> *channelId;

@end

NS_ASSUME_NONNULL_END
