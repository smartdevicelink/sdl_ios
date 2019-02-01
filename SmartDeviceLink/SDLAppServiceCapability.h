//
//  SDLAppServiceCapability.h
//  SmartDeviceLink
//
//  Created by Nicole on 1/30/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLRPCRequest.h"
#import "SDLAppServiceRecord.h"
#import "SDLServiceUpdateReason.h"

NS_ASSUME_NONNULL_BEGIN

/*
 *  A currently available service.
 */
@interface SDLAppServiceCapability : SDLRPCStruct

- (instancetype)initWithUpdateReason:(SDLServiceUpdateReason)updateReason updatedAppServiceRecord:(SDLAppServiceRecord *)updatedAppServiceRecord;

/**
 *  Only included in OnSystemCapbilityUpdated. Update reason for this service record.
 *
 *  SDLServiceUpdateReason, Optional
 */
@property (nullable, strong, nonatomic) SDLServiceUpdateReason updateReason;

/**
 *  Service record for a specific app service provider.
 *
 *  SDLServiceUpdateReason, Required
 */
@property (strong, nonatomic) SDLAppServiceRecord *updatedAppServiceRecord;

@end

NS_ASSUME_NONNULL_END
