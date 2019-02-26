//
//  SDLHybridAppPreference.h
//  SmartDeviceLink
//
//  Created by Nicole on 2/26/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLEnum.h"

/**
 *  Enumeration for the user's preference of which app type to use when both are available.
 */
typedef SDLEnum SDLHybridAppPreference SDL_SWIFT_ENUM;

/*
 *  App preference of mobile.
 */
extern SDLHybridAppPreference const SDLHybridAppPreferenceMobile;

/*
 *  App preference of cloud.
 */
extern SDLHybridAppPreference const SDLHybridAppPreferenceCloud;

/*
 *  App preference of both mobile and cloud.
 */
extern SDLHybridAppPreference const SDLHybridAppPreferenceBoth;
