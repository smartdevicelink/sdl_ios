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
#import "SDLSystemCapabilityType.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  SDL RPC Request for expanded information about a supported system/HMI capability
 *
 *  @since SDL 4.5
 */
@interface SDLGetSystemCapability : SDLRPCRequest

/**
 * @param systemCapabilityType - systemCapabilityType
 * @return A SDLGetSystemCapability object
 */
- (instancetype)initWithSystemCapabilityType:(SDLSystemCapabilityType)systemCapabilityType;

/**
 * @param systemCapabilityType - systemCapabilityType
 * @param subscribe - subscribe
 * @return A SDLGetSystemCapability object
 */
- (instancetype)initWithSystemCapabilityType:(SDLSystemCapabilityType)systemCapabilityType subscribe:(nullable NSNumber<SDLBool> *)subscribe;

/**
 *  Convenience init
 *
 *  @param type The type of system capability
 *  @return     A SDLSystemCapabilityType object
 */
- (instancetype)initWithType:(SDLSystemCapabilityType)type __deprecated_msg("Use initWithSystemCapabilityType: instead");

/**
 *  Convenience init
 *
 *  @param type         The type of system capability
 *  @param subscribe    Whether or not to subscribe to updates of the supplied service capability type
 *  @return             A SDLSystemCapabilityType object
 */
- (instancetype)initWithType:(SDLSystemCapabilityType)type subscribe:(BOOL)subscribe __deprecated_msg("Use initWithSystemCapabilityType:subscribe: instead");

/**
 *  The type of system capability to get more information on
 *
 *  SDLSystemCapabilityType, Required
 */
@property (strong, nonatomic) SDLSystemCapabilityType systemCapabilityType;

/**
 *  Flag to subscribe to updates of the supplied service capability type. If true, the requester will be subscribed. If false, the requester will not be subscribed and be removed as a subscriber if it was previously subscribed.
 *
 *  Boolean, Optional
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *subscribe;

@end

NS_ASSUME_NONNULL_END
