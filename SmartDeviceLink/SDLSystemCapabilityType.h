//
//  SDLSystemCapabilityType.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 7/10/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "SDLEnum.h"

/**
 The type of system capability to get more information on. Used in GetSystemCapability.
 */
typedef SDLEnum SDLSystemCapabilityType SDL_SWIFT_ENUM;

/**
 The navigation capability
 */
extern SDLSystemCapabilityType const SDLSystemCapabilityTypeNavigation;

/**
 The phone call capability
 */
extern SDLSystemCapabilityType const SDLSystemCapabilityTypePhoneCall;

/**
 The video streaming capability
 */
extern SDLSystemCapabilityType const SDLSystemCapabilityTypeVideoStreaming;

/**
 The remote control capability
 */
extern SDLSystemCapabilityType const SDLSystemCapabilityTypeRemoteControl;
