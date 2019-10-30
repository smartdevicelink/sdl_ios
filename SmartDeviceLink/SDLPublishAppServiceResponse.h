//
//  SDLPublishAppServiceResponse.h
//  SmartDeviceLink
//
//  Created by Nicole on 2/5/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLRPCResponse.h"

@class SDLAppServiceRecord;

NS_ASSUME_NONNULL_BEGIN

/**
 *  Response to the request to register a service offered by this app on the module.
 */
@interface SDLPublishAppServiceResponse : SDLRPCResponse

/**
 *  Convenience init.
 *
 *  @param appServiceRecord     If the request was successful, this object will be the current status of the service record for the published service. This will include the Core supplied service ID.
 *  @return                     A SDLPublishAppServiceResponse object
 */
- (instancetype)initWithAppServiceRecord:(SDLAppServiceRecord *)appServiceRecord;

/**
 *  If the request was successful, this object will be the current status of the service record for the published service. This will include the Core supplied service ID.
 *
 *  SDLAppServiceRecord, Optional
 */
@property (nullable, strong, nonatomic) SDLAppServiceRecord *appServiceRecord;


@end

NS_ASSUME_NONNULL_END
