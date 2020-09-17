//
//  SDLAppServiceType.h
//  SmartDeviceLink
//
//  Created by Nicole on 1/25/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLEnum.h"

/**
 * Enumeration listing possible app service types.
 */
typedef SDLEnum SDLAppServiceType NS_TYPED_ENUM;

/**
 * The app will have a service type of media.
 */
extern SDLAppServiceType const SDLAppServiceTypeMedia;

/**
 * The app will have a service type of weather.
 */
extern SDLAppServiceType const SDLAppServiceTypeWeather;

/**
 * The app will have a service type of navigation.
 */
extern SDLAppServiceType const SDLAppServiceTypeNavigation;
