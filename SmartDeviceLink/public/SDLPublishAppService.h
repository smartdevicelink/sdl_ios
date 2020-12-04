//
//  SDLPublishAppService.h
//  SmartDeviceLink
//
//  Created by Nicole on 1/25/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLRPCRequest.h"

@class SDLAppServiceManifest;


NS_ASSUME_NONNULL_BEGIN

/**
 *  Registers a service offered by this app on the module.
 *  Subsequent calls with the same service type will update the manifest for that service.
 */
@interface SDLPublishAppService : SDLRPCRequest

/**
 *  Convenience init.
 *
 *  @param appServiceManifest   The app service manifest
 *  @return                     A SDLPublishAppService object
 */
- (instancetype)initWithAppServiceManifest:(SDLAppServiceManifest *)appServiceManifest;

/**
 *  The manifest of the service that wishes to be published.
 *  If already published, the updated manifest for this service.
 *
 *  SDLAppServiceManifest, Required
 */
@property (strong, nonatomic) SDLAppServiceManifest *appServiceManifest;

@end

NS_ASSUME_NONNULL_END
