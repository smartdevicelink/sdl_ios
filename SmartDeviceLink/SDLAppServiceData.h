//
//  SDLAppServiceData.h
//  SmartDeviceLink
//
//  Created by Nicole on 2/1/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLAppServiceType.h"
#import "SDLMediaServiceData.h"
#import "SDLRPCRequest.h"
#import "SDLWeatherServiceData.h"

NS_ASSUME_NONNULL_BEGIN

/*
 *  Contains all the current data of the app service. The serviceType will link to which of the service data objects are included in this object. (eg if service type equals MEDIA, the mediaServiceData param should be included.
 */
@interface SDLAppServiceData : SDLRPCStruct

/**
 *  The type of service that is to be offered by this app.
 *
 *  SDLAppServiceType, Required
 */
@property (strong, nonatomic) SDLAppServiceType serviceType;

/**
 *   A unique ID tied to this specific service record. The ID is supplied by the module that services publish themselves.
 *
 *  String, Required
 */
@property (strong, nonatomic) NSString *serviceId;

/**
 *  The media service data.
 *
 *  SDLMediaServiceData, Optional
 */
@property (nullable, strong, nonatomic) SDLMediaServiceData *mediaServiceData;

/**
 *  The weather service data.
 *
 *  SDLWeatherServiceData, Optional
 */
@property (nullable, strong, nonatomic) SDLWeatherServiceData *weatherServiceData;

@end

NS_ASSUME_NONNULL_END
