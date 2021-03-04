//
//  SDLWindowCapability+ScreenManagerExtensions.h
//  SmartDeviceLink
//
//  Created by Joel Fischer on 2/28/18.
//  Updated by Kujtim Shala (Ford) on 13.09.19.
//    - Renamed and adapted for WindowCapability
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLImageFieldName.h"
#import "SDLTextFieldName.h"
#import "SDLWindowCapability.h"

@class SDLKeyboardProperties;

NS_ASSUME_NONNULL_BEGIN

static const int MaxMainFieldLineCount = 4;
static const int MaxAlertTextFieldLineCount = 3;

@interface SDLWindowCapability (ScreenManagerExtensions)

@property (assign, nonatomic, readonly) NSUInteger maxNumberOfMainFieldLines;
@property (assign, nonatomic, readonly) NSUInteger maxNumberOfAlertFieldLines;

- (BOOL)hasTextFieldOfName:(SDLTextFieldName)name;
- (BOOL)hasImageFieldOfName:(SDLImageFieldName)name;

/// Takes a keyboard configuration (SDLKeyboardProperties) and creates a valid version of it, if possible, based on this object's internal keyboardCapabilities (SDLKeyboardCapabilities).
/// If there is no internal keyboardCapabilities, it will just return the passed configuration as-is.
/// If no valid configuration can be determined based on the internal keyboard capabilities, it will return nil.
/// @param keyboardConfiguration The configuration to use to determine a valid configuration
/// @return The passed keyboardConfiguration if there are no changes needed or possible, a modified keyboardConfiguration if a valid version of the configuration could be determined, or nil if a valid configuration could not be created
- (nullable SDLKeyboardProperties *)createValidKeyboardConfigurationBasedOnKeyboardCapabilitiesFromConfiguration:(nullable SDLKeyboardProperties *)keyboardConfiguration;

@end

NS_ASSUME_NONNULL_END
