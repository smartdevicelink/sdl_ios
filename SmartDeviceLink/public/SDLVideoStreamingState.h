//
//  SDLVideoStreamingState.h
//  SmartDeviceLink
//
//  Created by Joel Fischer on 6/19/18.
//  Copyright © 2018 Livio. All rights reserved.
//

#import "SDLEnum.h"

/**
 * Enum for each type of video streaming protocol, used in VideoStreamingFormat
 */
typedef SDLEnum SDLVideoStreamingState NS_TYPED_ENUM;

/**
 * STREAMABLE, the current app is allowed to stream video
 */
extern SDLVideoStreamingState const SDLVideoStreamingStateStreamable;

/**
 * NOT_STREAMABLE, the current app is not allowed to stream video
 */
extern SDLVideoStreamingState const SDLVideoStreamingStateNotStreamable;
