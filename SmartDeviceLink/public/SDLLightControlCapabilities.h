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
#import "SDLModuleInfo.h"

@class SDLLightCapabilities;

NS_ASSUME_NONNULL_BEGIN

/// Current light control capabilities.
///
/// @since RPC 5.0
@interface SDLLightControlCapabilities : SDLRPCStruct

/**
 * @param moduleName - moduleName
 * @param supportedLights - supportedLights
 * @return A SDLLightControlCapabilities object
 */
- (instancetype)initWithModuleName:(NSString *)moduleName supportedLights:(NSArray<SDLLightCapabilities *> *)supportedLights;

/**
 * @param moduleName - moduleName
 * @param supportedLights - supportedLights
 * @param moduleInfo - moduleInfo
 * @return A SDLLightControlCapabilities object
 */
- (instancetype)initWithModuleName:(NSString *)moduleName supportedLights:(NSArray<SDLLightCapabilities *> *)supportedLights moduleInfo:(nullable SDLModuleInfo *)moduleInfo;

/**
 Constructs a newly allocated SDLLightControlCapabilities object with given parameters
 
 
 @param moduleName friendly name of the light control module
 @param moduleInfo information about a RC module, including its id
 @param supportedLights array of available LightCapabilities
 @return An instance of the SDLLightControlCapabilities class
 */
- (instancetype)initWithModuleName:(NSString *)moduleName moduleInfo:(nullable SDLModuleInfo *)moduleInfo supportedLights:(NSArray<SDLLightCapabilities *> *)supportedLights __deprecated_msg("Use initWithModuleName:supportedLights:moduleInfo: instead");

/**
 * @abstract  The short friendly name of the light control module.
 * It should not be used to identify a module by mobile application.
 *
 * Required, Max String length 100 chars
 */
@property (strong, nonatomic) NSString *moduleName;

/**
 * @abstract  An array of available LightCapabilities that are controllable.
 *
 * Required, NSArray of type SDLLightCapabilities minsize="1" maxsize="100"
 */
@property (strong, nonatomic) NSArray<SDLLightCapabilities *> *supportedLights;

/**
 *  Information about a RC module, including its id.
 *
 *  Optional
 */
@property (nullable, strong, nonatomic) SDLModuleInfo *moduleInfo;

@end

NS_ASSUME_NONNULL_END
