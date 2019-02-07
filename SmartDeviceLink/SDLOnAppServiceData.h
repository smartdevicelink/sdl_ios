//
//  SDLOnAppServiceData.h
//  SmartDeviceLink
//
//  Created by Nicole on 2/7/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLRPCNotification.h"
#import "SDLAppServiceData.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *   This notification includes the data that is updated from the specific service.
 */
@interface SDLOnAppServiceData : SDLRPCNotification

/**
 *  The updated app service data.
 *
 *  SDLAppServiceData, Required
 */
@property (strong, nonatomic) SDLAppServiceData *serviceData;

@end

NS_ASSUME_NONNULL_END
