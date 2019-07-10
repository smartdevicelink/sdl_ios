//
//  SDLGetCloudAppPropertiesResponse.h
//  SmartDeviceLink
//
//  Created by Nicole on 2/26/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLRPCResponse.h"

@class SDLCloudAppProperties;


NS_ASSUME_NONNULL_BEGIN

/**
 *  The response to GetCloudAppProperties
 */
@interface SDLGetCloudAppPropertiesResponse : SDLRPCResponse

/**
 *  Convenience init.
 *
 *  @param properties   The requested cloud application properties
 *  @return             A SDLGetCloudAppPropertiesResponse object
 */
- (instancetype)initWithProperties:(SDLCloudAppProperties *)properties;

/**
 *  The requested cloud application properties.
 *
 *  SDLCloudAppProperties, Optional
 */
@property (nullable, strong, nonatomic) SDLCloudAppProperties *properties;

@end

NS_ASSUME_NONNULL_END
