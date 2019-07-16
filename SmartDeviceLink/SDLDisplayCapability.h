//
//  SDLDisplayCapability.h
//  SmartDeviceLink
//
//  Created by cssoeutest1 on 16.07.19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLRPCStruct.h"

@class SDLWindowCapability;
@class SDLWindowTypeCapabilities;

NS_ASSUME_NONNULL_BEGIN

@interface SDLDisplayCapability : SDLRPCStruct

/**
 *
 *
 */
@property (strong, nonatomic, nullable) NSString *displayName;

/**
 *
 * Informs the application how many windows the app is allowed to create per type.
 */
@property (strong, nonatomic, nullable) SDLWindowTypeCapabilities *windowTypeSupported;
/**
 *
 *
 */
@property (strong, nonatomic, nullable) SDLWindowCapability *windowCapabilities;


@end

NS_ASSUME_NONNULL_END
