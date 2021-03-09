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
 * Neither the name of the SmartDeviceLink Consort`ium Inc. nor the names of
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

#import "SDLAppCapabilityType.h"
#import "SDLRPCStruct.h"

@class SDLVideoStreamingCapability;

NS_ASSUME_NONNULL_BEGIN

/**
 * @added in SmartDeviceLink 7.1.0
 */
@interface SDLAppCapability : SDLRPCStruct

/**
 * @param appCapabilityType - appCapabilityType
 * @return A SDLAppCapability object
 */
- (instancetype)initWithAppCapabilityType:(SDLAppCapabilityType)appCapabilityType;

/**
 * @param appCapabilityType - appCapabilityType
 * @param videoStreamingCapability - videoStreamingCapability
 * @return A SDLAppCapability object
 */
- (instancetype)initWithAppCapabilityType:(SDLAppCapabilityType)appCapabilityType videoStreamingCapability:(nullable SDLVideoStreamingCapability *)videoStreamingCapability;

/**
 * Used as a descriptor of what data to expect in this struct. The corresponding param to this enum should be included and the only other param included.
 */
@property (strong, nonatomic) SDLAppCapabilityType appCapabilityType;

/**
 * Describes supported capabilities for video streaming
 */
@property (nullable, strong, nonatomic) SDLVideoStreamingCapability *videoStreamingCapability;

@end

NS_ASSUME_NONNULL_END
