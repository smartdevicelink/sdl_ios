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

// Extension for getting window capabilities from the `SDLDisplayCapability` object
@interface SDLDisplayCapability (ScreenManagerExtensions)

/// The window capability for the default window ID
@property (weak, nonatomic, nullable, readonly) SDLWindowCapability *currentWindowCapability;

/// Retreives the window capability for the specified window ID
/// @param windowID The window ID used to retreive the window capability
/// @return The window capability for the window ID or nil if the window ID does not exist
- (nullable SDLWindowCapability *)windowCapabilityForWindowID:(NSUInteger)windowID;

@end

NS_ASSUME_NONNULL_END
