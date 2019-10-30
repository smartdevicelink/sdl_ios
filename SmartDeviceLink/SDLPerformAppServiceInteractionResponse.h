//
//  SDLPerformAppServiceInteractionResponse.h
//  SmartDeviceLink
//
//  Created by Nicole on 2/6/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLRPCResponse.h"


NS_ASSUME_NONNULL_BEGIN

/**
 *  Response to the request to request an app service.
 */
@interface SDLPerformAppServiceInteractionResponse : SDLRPCResponse

/**
 *  Convenience init for all parameters.
 *
 *  @param serviceSpecificResult    The service can provide specific result strings to the consumer through this param.
 *  @return                         A SDLPerformAppServiceInteractionResponse object
 */
- (instancetype)initWithServiceSpecificResult:(NSString *)serviceSpecificResult;

/**
 *  The service can provide specific result strings to the consumer through this param.
 *
 *  String, Optional
 */
@property (nullable, strong, nonatomic) NSString *serviceSpecificResult;

@end

NS_ASSUME_NONNULL_END
