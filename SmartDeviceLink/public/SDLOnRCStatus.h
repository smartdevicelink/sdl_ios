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

#import "SDLRPCNotification.h"

@class SDLModuleData;


NS_ASSUME_NONNULL_BEGIN

/**
 * Issued by SDL to notify the application about remote control status change on SDL
 *
 * @added in SmartDeviceLink 5.0.0
 */
@interface SDLOnRCStatus : SDLRPCNotification

/**
 * @param allocatedModules - allocatedModules
 * @param freeModules - freeModules
 * @return A SDLOnRCStatus object
 */
- (instancetype)initWithAllocatedModules:(NSArray<SDLModuleData *> *)allocatedModules freeModules:(NSArray<SDLModuleData *> *)freeModules;

/**
 * @param allocatedModules - allocatedModules
 * @param freeModules - freeModules
 * @param allowed - allowed
 * @return A SDLOnRCStatus object
 */
- (instancetype)initWithAllocatedModules:(NSArray<SDLModuleData *> *)allocatedModules freeModules:(NSArray<SDLModuleData *> *)freeModules allowed:(nullable NSNumber<SDLBool> *)allowed;

/**
 * @abstract Contains a list (zero or more) of module types that
 * are allocated to the application.
 *
 * Required, Array of SDLModuleData, Array size 0 - 100
 *
 * @see SDLPermissionItem
 */
@property (strong, nonatomic) NSArray<SDLModuleData *> *allocatedModules;

/**
 * @abstract Contains a list (zero or more) of module types that are free to access for the application.
 *
 * Required, Array of SDLModuleData, Array size 0 - 100
 *
 * @see SDLPermissionItem
 */
@property (strong, nonatomic) NSArray<SDLModuleData *> *freeModules;

/**
 * Issued by SDL to notify the application about remote control status change on SDL
 * If "true" - RC is allowed; if "false" - RC is disallowed.
 * 
 * optional, Boolean, default Value = false
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *allowed;

NS_ASSUME_NONNULL_END

@end
