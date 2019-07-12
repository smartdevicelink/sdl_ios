//
//  SDLMenuLayout.h
//  SmartDeviceLink
//
//  Created by Joel Fischer on 7/12/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLEnum.h"

/**
 * Enum for each type of video streaming protocol, used in VideoStreamingFormat
 */
typedef SDLEnum SDLMenuLayout SDL_SWIFT_ENUM;

/**
 * STREAMABLE, the current app is allowed to stream video
 */
extern SDLMenuLayout const SDLMenuLayoutList;

/**
 * NOT_STREAMABLE, the current app is not allowed to stream video
 */
extern SDLMenuLayout const SDLMenuLayoutTiles;

