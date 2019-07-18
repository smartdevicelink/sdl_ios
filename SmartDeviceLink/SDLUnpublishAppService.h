//
//  SDLUnpublishAppService.h
//  SmartDeviceLink
//
//  Created by Bretty White on 7/15/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLRPCRequest.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Unpublish an existing service published by this application.
 */
@interface SDLUnpublishAppService : SDLRPCRequest

/**
 * Create an instance of UnpublishAppService with the serviceID that corresponds with the service to be unpublished
 *
 * @param serviceID     The ID of the service to be unpublished.
 */
- (instancetype)initWithServiceID:(NSString*)serviceID;

/**
 * The ID of the service to be unpublished.
 *
 * Required, String
 */
@property (strong, nonatomic) NSString *serviceID;

@end

NS_ASSUME_NONNULL_END
