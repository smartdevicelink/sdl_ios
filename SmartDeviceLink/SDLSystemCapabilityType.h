//
//  SDLSystemCapabilityType.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 7/10/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "SDLEnum.h"

/**
 The type of system capability to get more information on
 */
typedef SDLEnum SDLSystemCapabilityType SDL_SWIFT_ENUM;

/**
 @abstract NAVIGATION
 */
extern SDLSystemCapabilityType const SDLSystemCapabilityTypeNavigation;

/**
 @abstract PHONE_CALL
 */
extern SDLSystemCapabilityType const SDLSystemCapabilityTypePhoneCall;

/**
 @abstract VIDEO_STREAMING
 
 */
extern SDLSystemCapabilityType const SDLSystemCapabilityTypeVideoStreaming;

/**
 @abstract AUDIO_STREAMING
 REMOTE_CONTROL
 */
extern SDLSystemCapabilityType const SDLSystemCapabilityTypeAudioStreaming;

/**
 @abstract REMOTE_CONTROL
 */
extern SDLSystemCapabilityType const SDLSystemCapabilityTypeRemoteControl;
