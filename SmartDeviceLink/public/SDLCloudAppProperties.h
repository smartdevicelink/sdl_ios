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

#import "SDLHybridAppPreference.h"


NS_ASSUME_NONNULL_BEGIN

/**
 *  The cloud application properties.
 */
@interface SDLCloudAppProperties : SDLRPCStruct

/**
 *  Convenience init for required parameters.
 *
 *  @param appID    The id of the cloud app
 *  @return         A SDLCloudAppProperties object
 */
- (instancetype)initWithAppID:(NSString *)appID;

/**
 * @param appID - appID
 * @param nicknames - nicknames
 * @param enabled - enabled
 * @param authToken - authToken
 * @param cloudTransportType - cloudTransportType
 * @param hybridAppPreference - hybridAppPreference
 * @param endpoint - endpoint
 * @return A SDLCloudAppProperties object
 */
- (instancetype)initWithAppIDParam:(NSString *)appID nicknames:(nullable NSArray<NSString *> *)nicknames enabled:(nullable NSNumber<SDLBool> *)enabled authToken:(nullable NSString *)authToken cloudTransportType:(nullable NSString *)cloudTransportType hybridAppPreference:(nullable SDLHybridAppPreference)hybridAppPreference endpoint:(nullable NSString *)endpoint __deprecated_msg("Eventually this will be replaced with an initializer without param");

/**
 *  Convenience init for all parameters.
 *
 *  @param appID                The id of the cloud app
 *  @param nicknames            An array of app names a cloud app is allowed to register with
 *  @param enabled              If true, the cloud app will appear in the HMI's app list; if false, the cloud app will not appear in the HMI's app list
 *  @param authToken            Used to authenticate websocket connection on app activation
 *  @param cloudTransportType   Specifies the connection type Core should use
 *  @param hybridAppPreference  Specifies the user preference to use the cloud app version or mobile app version when both are available
 *  @param endpoint             The websocket endpoint
 *  @return                     A SDLCloudAppProperties object
 */
- (instancetype)initWithAppID:(NSString *)appID nicknames:(nullable NSArray<NSString *> *)nicknames enabled:(BOOL)enabled authToken:(nullable NSString *)authToken cloudTransportType:(nullable NSString *)cloudTransportType hybridAppPreference:(nullable SDLHybridAppPreference)hybridAppPreference endpoint:(nullable NSString *)endpoint __deprecated_msg("Eventually this will be replaced by an initializer with different parameter types");

/**
 *  An array of app names a cloud app is allowed to register with. If included in a `SetCloudAppProperties` request, this value will overwrite the existing "nicknames" field in the app policies section of the policy table.
 *
 *  Array of Strings, Optional, String length: minlength="0" maxlength="100", Array size: minsize="0" maxsize="100"
 */
@property (nullable, strong, nonatomic) NSArray<NSString *> *nicknames;

/**
 *  The id of the cloud app.
 *
 *  String, Required, maxlength="100"
 */
@property (strong, nonatomic) NSString *appID;

/**
 *  If true, the cloud app will appear in the HMI's app list; if false, the cloud app will not appear in the HMI's app list.
 *
 *  Boolean, Optional
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *enabled;

/**
 *  Used to authenticate websocket connection on app activation.
 *
 *  String, Optional, maxlength="65535"
 */
@property (nullable, strong, nonatomic) NSString *authToken;

/**
 *  Specifies the connection type Core should use. Currently the ones that work in SDL Core are `WS` or `WSS`, but an OEM can implement their own transport adapter to handle different values.
 *
 *  String, Optional, maxlength="100"
 */
@property (nullable, strong, nonatomic) NSString *cloudTransportType;

/**
 *  Specifies the user preference to use the cloud app version or mobile app version when both are available.
 *
 *  SDLHybridAppPreference, Optional
 */
@property (nullable, strong, nonatomic) SDLHybridAppPreference hybridAppPreference;

/**
 *  The websocket endpoint.
 *
 *  String, Optional, maxlength="65535"
 */
@property (nullable, strong, nonatomic) NSString *endpoint;

@end

NS_ASSUME_NONNULL_END
