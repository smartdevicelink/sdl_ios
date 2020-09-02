//
//  SDLGetAppServiceDataResponse.h
//  SmartDeviceLink
//
//  Created by Nicole on 2/6/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLRPCResponse.h"

@class SDLAppServiceData;

NS_ASSUME_NONNULL_BEGIN

/**
 *  This response includes the data that was requested from the specific service.
 */
@interface SDLGetAppServiceDataResponse : SDLRPCResponse

/**
 *  Convenience init.
 *
 *  @param serviceData  Contains all the current data of the app service
 *  @return             A SDLGetAppServiceDataResponse object
 */
- (instancetype)initWithAppServiceData:(SDLAppServiceData *)serviceData;

/**
 *  Contains all the current data of the app service.
 *
 *  SDLAppServiceData, Optional
 */
@property (nullable, strong, nonatomic) SDLAppServiceData *serviceData;

@end

NS_ASSUME_NONNULL_END
