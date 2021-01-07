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

@class SDLPermissionItem;

/**
 * Provides update to app of which sets of functions are available
 *
 * @since SDL 2.0
 */

NS_ASSUME_NONNULL_BEGIN

@interface SDLOnPermissionsChange : SDLRPCNotification

/**
 * @param permissionItem - permissionItem
 * @return A SDLOnPermissionsChange object
 */
- (instancetype)initWithPermissionItem:(NSArray<SDLPermissionItem *> *)permissionItem;

/**
 * @param permissionItem - permissionItem
 * @param requireEncryption - requireEncryption
 * @return A SDLOnPermissionsChange object
 */
- (instancetype)initWithPermissionItem:(NSArray<SDLPermissionItem *> *)permissionItem requireEncryption:(nullable NSNumber<SDLBool> *)requireEncryption;

/**
 Describes change in permissions for a given set of RPCs

 Required, Array of SDLPermissionItem, Array size 0 - 500
 */
@property (strong, nonatomic) NSArray<SDLPermissionItem *> *permissionItem;

/**
 Describes whether or not the app needs the encryption permission
 
 Optional, Boolean, since SDL 6.0
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *requireEncryption;

@end

NS_ASSUME_NONNULL_END
