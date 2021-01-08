//
//  SDLDisplayCapability+ScreenManagerExtensions.h
//  SmartDeviceLink
//
//  Created by Nicole on 1/8/21.
//  Copyright © 2021 smartdevicelink. All rights reserved.
//

#import "SDLDisplayCapability.h"

@class SDLWindowCapability;

NS_ASSUME_NONNULL_BEGIN

@interface SDLDisplayCapability (ScreenManagerExtensions)

@property (weak, nonatomic, nullable, readonly) SDLWindowCapability *currentWindowCapability;

@end

NS_ASSUME_NONNULL_END
