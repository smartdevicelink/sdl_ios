//
//  SDLAppServiceCapability.h
//  SmartDeviceLink
//
//  Created by Nicole on 1/30/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLRPCRequest.h"
#import "SDLServiceUpdateReason.h"

@class SDLAppServiceRecord;

NS_ASSUME_NONNULL_BEGIN

/**
 *  A currently available service.
 *
 *  @since RPC 5.1
 */
@interface SDLAppServiceCapability : SDLRPCStruct

/**
 *  Convenience init for required parameters.
 *
 *  @param updatedAppServiceRecord  Service record for a specific app service provider
 *  @return                         A SDLAppServiceCapability object
 */
- (instancetype)initWithUpdatedAppServiceRecord:(SDLAppServiceRecord *)updatedAppServiceRecord NS_DESIGNATED_INITIALIZER;

/**
 *  Convenience init for all parameters.
 *
 *  @param updateReason             Update reason for this service record
 *  @param updatedAppServiceRecord  Service record for a specific app service provider
 *  @return                         A SDLAppServiceCapability object
 */
- (instancetype)initWithUpdateReason:(nullable SDLServiceUpdateReason)updateReason updatedAppServiceRecord:(SDLAppServiceRecord *)updatedAppServiceRecord;

/**
 *  Only included in `OnSystemCapbilityUpdated`. Update reason for this service record.
 *
 *  SDLServiceUpdateReason, Optional
 */
@property (nullable, strong, nonatomic) SDLServiceUpdateReason updateReason;

/**
 *  Service record for a specific app service provider.
 *
 *  SDLAppServiceRecord, Required
 */
@property (strong, nonatomic) SDLAppServiceRecord *updatedAppServiceRecord;

@end

NS_ASSUME_NONNULL_END
