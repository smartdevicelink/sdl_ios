//
//  SDLOnSystemCapabilityUpdated.h
//  SmartDeviceLink
//
//  Created by Nicole on 2/6/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLRPCNotification.h"

@class SDLSystemCapability;

NS_ASSUME_NONNULL_BEGIN

/**
 *  A notification to inform the connected device that a specific system capability has changed.
 */
@interface SDLOnSystemCapabilityUpdated : SDLRPCNotification

/**
 * Convenience init for required parameters
 *
 *  @param systemCapability    The system capability that has been updated
 *  @return                    A SDLOnSystemCapabilityUpdated object
 */
- (instancetype)initWithSystemCapability:(SDLSystemCapability *)systemCapability;

/**
 *  The system capability that has been updated.
 *
 *  SDLSystemCapability, Required
 */
@property (strong, nonatomic) SDLSystemCapability *systemCapability;

@end

NS_ASSUME_NONNULL_END
