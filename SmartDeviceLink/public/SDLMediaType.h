//
//  SDLMediaType.h
//  SmartDeviceLink
//
//  Created by Nicole on 2/8/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLEnum.h"

/**
 *  Enumeration listing possible media types.
 */
typedef SDLEnum SDLMediaType NS_TYPED_ENUM;

/**
 *  The app will have a media type of music.
 */
extern SDLMediaType const SDLMediaTypeMusic;

/**
 *  The app will have a media type of podcast.
 */
extern SDLMediaType const SDLMediaTypePodcast;

/**
 *  The app will have a media type of audiobook.
 */
extern SDLMediaType const SDLMediaTypeAudiobook;

/**
 *  The app will have a media type of other.
 */
extern SDLMediaType const SDLMediaTypeOther;

