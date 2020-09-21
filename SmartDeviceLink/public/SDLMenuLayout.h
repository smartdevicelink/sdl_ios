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
typedef SDLEnum SDLMenuLayout NS_TYPED_ENUM;

/**
 * The menu should be laid out in a scrollable list format with one menu cell below the previous, each is stretched across the view
 */
extern SDLMenuLayout const SDLMenuLayoutList;

/**
 * The menu should be laid out in a scrollable tiles format with each menu cell laid out in a square-ish format next to each other horizontally
 */
extern SDLMenuLayout const SDLMenuLayoutTiles;

