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
typedef SDLEnum SDLHybridAppPreference NS_TYPED_ENUM;

/**
 *  App preference of mobile.
 */
extern SDLHybridAppPreference const SDLHybridAppPreferenceMobile;

/**
 *  App preference of cloud.
 */
extern SDLHybridAppPreference const SDLHybridAppPreferenceCloud;

/**
 *  App preference of both. Allows both the mobile and the cloud versions of the app to attempt to connect at the same time, however the first app that is registered is the one that is allowed to stay registered.
 */
extern SDLHybridAppPreference const SDLHybridAppPreferenceBoth;
