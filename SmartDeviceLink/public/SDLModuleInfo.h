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
#import "SDLGrid.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Contains information about a RC module.
 */
@interface SDLModuleInfo : SDLRPCStruct

/**
 * @param moduleId - moduleId
 * @return A SDLModuleInfo object
 */
- (instancetype)initWithModuleId:(NSString *)moduleId;

/**
 * @param moduleId - moduleId
 * @param location - location
 * @param serviceArea - serviceArea
 * @param allowMultipleAccess - allowMultipleAccess
 * @return A SDLModuleInfo object
 */
- (instancetype)initWithModuleId:(NSString *)moduleId location:(nullable SDLGrid *)location serviceArea:(nullable SDLGrid *)serviceArea allowMultipleAccess:(nullable NSNumber<SDLBool> *)allowMultipleAccess;

/**
 * UUID of a module. "moduleId + moduleType" uniquely identify a module.
 *
 * Max string length 100 chars
 
 Required
 */
@property (nullable, strong, nonatomic) NSString *moduleId;

/**
 * Location of a module.
 * Optional
 */
@property (nullable, strong, nonatomic) SDLGrid *location;

/**
 * Service area of a module.
 * Optional
 */
@property (nullable, strong, nonatomic) SDLGrid *serviceArea;

/**
 * Allow multiple users/apps to access the module or not
 *
 * Optional, Boolean
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *allowMultipleAccess;


@end

NS_ASSUME_NONNULL_END
