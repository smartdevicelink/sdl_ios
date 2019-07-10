//
//  SDLSetCloudAppProperties.h
//  SmartDeviceLink
//
//  Created by Nicole on 2/26/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLRPCRequest.h"

@class SDLCloudAppProperties;


NS_ASSUME_NONNULL_BEGIN

/**
 *  RPC used to enable/disable a cloud application and set authentication data
 */
@interface SDLSetCloudAppProperties : SDLRPCRequest

/**
 *  Convenience init.
 *
 *  @param properties   The new cloud application properties
 *  @return             A SDLSetCloudAppProperties object
 */
- (instancetype)initWithProperties:(SDLCloudAppProperties *)properties;

/**
 *  The new cloud application properties.
 *
 *  SDLCloudAppProperties, Required
 */
@property (strong, nonatomic) SDLCloudAppProperties *properties;

@end

NS_ASSUME_NONNULL_END
