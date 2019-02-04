//
//  SDLAppServiceData.h
//  SmartDeviceLink
//
//  Created by Nicole on 2/1/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLAppServiceType.h"
#import "SDLRPCRequest.h"

NS_ASSUME_NONNULL_BEGIN

/*
 *  Contains all the current data of the app service. The serviceType will link to which of the service data objects are included in this object. (eg if service type equals MEDIA, the mediaServiceData param should be included.
 */
@interface SDLAppServiceData : SDLRPCStruct

/**
 *  The type of service that is to be offered by this app.
 *
 *  String, Required
 */
@property (strong, nonatomic) SDLAppServiceType serviceType;

/**
 *   A unique ID tied to this specific service record. The ID is supplied by the module that services publish themselves.
 *
 *  String, Required
 */
@property (strong, nonatomic) NSString *serviceId;

// TODO: Add when created
/*
 <param name="mediaServiceData" type="MediaServiceData" mandatory="false"/>
 <param name="weatherServiceData" type="WeatherServiceData" mandatory="false"/>
 <param name="navigationServiceData" type="NavigationServiceData" mandatory="false"/>
 <param name="voiceAssistantServiceData" type="MediaServiceData" mandatory="false"/>
*/

@end

NS_ASSUME_NONNULL_END
