//
//  SDLOnAppServiceData.h
//  SmartDeviceLink
//
//  Created by Nicole on 2/7/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLRPCNotification.h"

@class SDLAppServiceData;


NS_ASSUME_NONNULL_BEGIN

/**
 *   This notification includes the data that is updated from the specific service.
 */
@interface SDLOnAppServiceData : SDLRPCNotification

/**
 *  Convenience init for all parameters.
 *
 *  @param serviceData  The updated app service data
 *  @return             A SDLOnAppServiceData object
 */
- (instancetype)initWithServiceData:(SDLAppServiceData *)serviceData;

/**
 *  The updated app service data.
 *
 *  SDLAppServiceData, Required
 */
@property (strong, nonatomic) SDLAppServiceData *serviceData;

@end

NS_ASSUME_NONNULL_END
