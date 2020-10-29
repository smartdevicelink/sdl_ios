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

@class SDLHMIPermissions;
@class SDLParameterPermissions;

NS_ASSUME_NONNULL_BEGIN

/// Permissions for a given set of RPCs
///
/// @since RPC 2.0
@interface SDLPermissionItem : SDLRPCStruct

/**
 * @param rpcName - rpcName
 * @param hmiPermissions - hmiPermissions
 * @param parameterPermissions - parameterPermissions
 * @return A SDLPermissionItem object
 */
- (instancetype)initWithRpcName:(NSString *)rpcName hmiPermissions:(SDLHMIPermissions *)hmiPermissions parameterPermissions:(SDLParameterPermissions *)parameterPermissions;

/**
 * @param rpcName - rpcName
 * @param hmiPermissions - hmiPermissions
 * @param parameterPermissions - parameterPermissions
 * @param requireEncryption - requireEncryption
 * @return A SDLPermissionItem object
 */
- (instancetype)initWithRpcName:(NSString *)rpcName hmiPermissions:(SDLHMIPermissions *)hmiPermissions parameterPermissions:(SDLParameterPermissions *)parameterPermissions requireEncryption:(nullable NSNumber<SDLBool> *)requireEncryption;

/**
 Name of the individual RPC in the policy table.

 Required
 */
@property (strong, nonatomic) NSString *rpcName;

/**
 HMI Permissions for the individual RPC; i.e. which HMI levels may it be used in

 Required
 */
@property (strong, nonatomic) SDLHMIPermissions *hmiPermissions;

/**
 RPC parameters for the individual RPC

 Required
 */
@property (strong, nonatomic) SDLParameterPermissions *parameterPermissions;

/**
 Describes whether or not the RPC needs encryption
 
 Optional, Boolean, since SDL 6.0
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *requireEncryption;

@end

NS_ASSUME_NONNULL_END
