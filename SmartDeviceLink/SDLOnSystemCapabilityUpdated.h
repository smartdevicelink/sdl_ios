//
//  SDLOnSystemCapabilityUpdated.h
//  SmartDeviceLink
//
//  Created by Nicole on 2/6/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLRPCNotification.h"
#import "SDLSystemCapability.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  A notification to inform the connected device that a specific system capability has changed.
 */
@interface SDLOnSystemCapabilityUpdated : SDLRPCNotification

/**
 *  The system capability that has been updated.
 *
 *  SDLSystemCapability, Required
 */
@property (strong, nonatomic) SDLSystemCapability *systemCapability;

@end

NS_ASSUME_NONNULL_END
