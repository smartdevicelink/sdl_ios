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
 *
 *  @since SDL 5.x
 */
@interface SDLCloudAppProperties : SDLRPCStruct

/**
 *  Convenience init.
 *
 *  @param appName  The name of the cloud app
 *  @param appID    The id of the cloud app
 *  @return         A SDLCloudAppProperties object
 */
- (instancetype)initWithAppName:(NSString *)appName appID:(NSString *)appID NS_DESIGNATED_INITIALIZER;

/**
 *  Convenience init.
 *
 *  @param appName              The name of the cloud app
 *  @param appID                The id of the cloud app
 *  @param enabled              If true, cloud app will be included in HMI RPC UpdateAppList
 *  @param authToken            Used to authenticate websocket connection on app activation
 *  @param cloudTransportType   Specifies the connection type Core should use
 *  @param hybridAppPreference  Specifies the user preference to use the cloud app version or mobile app version when both are available
 *  @param endpoint             The websocket endpoint
 *  @return                     A SDLCloudAppProperties object
 */
- (instancetype)initWithAppName:(NSString *)appName appID:(NSString *)appID enabled:(BOOL)enabled authToken:(nullable NSString *)authToken cloudTransportType:(nullable NSString *)cloudTransportType hybridAppPreference:(nullable SDLHybridAppPreference)hybridAppPreference endpoint:(nullable NSString *)endpoint;

/**
 *  The name of the cloud app.
 *
 *  String, Required, maxlength="100"
 */
@property (strong, nonatomic) NSString *appName;

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
