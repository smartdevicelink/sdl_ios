//
//  SDLAppServicesCapabilities.h
//  SmartDeviceLink
//
//  Created by Nicole on 1/30/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLRPCRequest.h"

@class SDLAppServiceCapability;

NS_ASSUME_NONNULL_BEGIN

/**
 *  Capabilities of app services including what service types are supported and the current state of services.
 *
 *  @since RPC 5.1
 */
@interface SDLAppServicesCapabilities : SDLRPCStruct

/**
 *  Convenience init.
 *
 *  @param appServices          An array of currently available services.
 *  @return                     A SDLAppServicesCapabilities object
 */
- (instancetype)initWithAppServices:(nullable NSArray<SDLAppServiceCapability *> *)appServices;

/**
 *  An array of currently available services. If this is an update to the capability the affected services will include an update reason in that item.
 *
 *  Array of SDLAppServiceCapability, Optional
 */
@property (nullable, strong, nonatomic) NSArray<SDLAppServiceCapability *> *appServices;

@end

NS_ASSUME_NONNULL_END
