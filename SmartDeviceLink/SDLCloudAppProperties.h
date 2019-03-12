//
//  SDLCloudAppProperties.h
//  SmartDeviceLink
//
//  Created by Nicole on 2/26/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLRPCStruct.h"

#import "SDLHybridAppPreference.h"


NS_ASSUME_NONNULL_BEGIN

/*
 *  The cloud application properties.
 */
@interface SDLCloudAppProperties : SDLRPCStruct

/**
 *  Convenience init for required parameters.
 *
 *  @param appID    The id of the cloud app
 *  @return         A SDLCloudAppProperties object
 */
- (instancetype)initWithAppID:(NSString *)appID NS_DESIGNATED_INITIALIZER;

/**
 *  Convenience init for all parameters.
 *
 *  @param nicknames            An array of app names a cloud app is allowed to register with
 *  @param appID                The id of the cloud app
 *  @param enabled              If true, cloud app will be included in HMI RPC UpdateAppList
 *  @param authToken            Used to authenticate websocket connection on app activation
 *  @param cloudTransportType   Specifies the connection type Core should use
 *  @param hybridAppPreference  Specifies the user preference to use the cloud app version or mobile app version when both are available
 *  @param endpoint             The websocket endpoint
 *  @return                     A SDLCloudAppProperties object
 */
- (instancetype)initWithAppID:(NSString *)appID nicknames:(nullable NSArray<NSString *> *)nicknames enabled:(BOOL)enabled authToken:(nullable NSString *)authToken cloudTransportType:(nullable NSString *)cloudTransportType hybridAppPreference:(nullable SDLHybridAppPreference)hybridAppPreference endpoint:(nullable NSString *)endpoint;

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
 *  If true, cloud app will be included in HMI RPC UpdateAppList.
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
 *  Specifies the connection type Core should use.
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
