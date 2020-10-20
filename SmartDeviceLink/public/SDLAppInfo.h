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

NS_ASSUME_NONNULL_BEGIN

/**
 A struct used in register app interface. Contains detailed information about the registered application.
 */
@interface SDLAppInfo : SDLRPCStruct

/**
 * @param appDisplayName - appDisplayName
 * @param appBundleID - appBundleID
 * @param appVersion - appVersion
 * @return A SDLAppInfo object
 */
- (instancetype)initWithAppDisplayName:(NSString *)appDisplayName appBundleID:(NSString *)appBundleID appVersion:(NSString *)appVersion;

/**
 * @param appDisplayName - appDisplayName
 * @param appBundleID - appBundleID
 * @param appVersion - appVersion
 * @param appIcon - appIcon
 * @return A SDLAppInfo object
 */
- (instancetype)initWithAppDisplayName:(NSString *)appDisplayName appBundleID:(NSString *)appBundleID appVersion:(NSString *)appVersion appIcon:(nullable NSString *)appIcon;

/// Convenience init with no parameters
///
/// @return An SDLAppInfo object
+ (instancetype)currentAppInfo;

/**
 The name displayed for the mobile application on the mobile device (can differ from the app name set in the initial RAI request).

 Required
 */
@property (strong, nonatomic) NSString *appDisplayName;

/**
 The AppBundleID of an iOS application or package name of the Android application. This supports App Launch strategies for each platform.

 Required
 */
@property (strong, nonatomic) NSString *appBundleID;

/**
 Represents the build version number of this particular mobile app.

 Required
 */
@property (strong, nonatomic) NSString *appVersion;

@end

NS_ASSUME_NONNULL_END
