//
//  SDLGetCloudAppProperties.h
//  SmartDeviceLink
//
//  Created by Nicole on 2/26/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLRPCRequest.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  RPC used to get the current properties of a cloud application.
 */
@interface SDLGetCloudAppProperties : SDLRPCRequest

/**
 *  Convenience init.
 *
 *  @param appID    The id of the cloud app
 *  @return         A SDLGetCloudAppProperties object
 */
- (instancetype)initWithAppID:(NSString *)appID;

/**
 *  The id of the cloud app.
 *
 *  String, Required, maxlength="100"
 */
@property (strong, nonatomic) NSString *appID;

@end

NS_ASSUME_NONNULL_END
