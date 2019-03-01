//
//  SDLAppServiceData.h
//  SmartDeviceLink
//
//  Created by Nicole on 2/1/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLRPCRequest.h"

@class SDLMediaServiceData;
@class SDLNavigationServiceData;
@class SDLWeatherServiceData;


NS_ASSUME_NONNULL_BEGIN

/*
 *  Contains all the current data of the app service. The serviceType will link to which of the service data objects are included in this object. (eg if service type equals MEDIA, the mediaServiceData param should be included.
 */
@interface SDLAppServiceData : SDLRPCStruct

/**
 *  Convenience init for required parameters.
 *
 *  @param serviceType              The type of service that is to be offered by this app.
 *  @param serviceId                A unique ID tied to this specific service record.
 *  @return                         A SDLAppServiceData object
 */
- (instancetype)initWithServiceType:(NSString *)serviceType serviceId:(NSString *)serviceId NS_DESIGNATED_INITIALIZER;

/**
 *  Convenience init for media service data.
 *
 *  @param mediaServiceData         The media service data
 *  @param serviceId                A unique ID tied to this specific service record.
 *  @return                         A SDLAppServiceData object
 */
- (instancetype)initWithMediaServiceData:(SDLMediaServiceData *)mediaServiceData serviceId:(NSString *)serviceId;

/**
 *  Convenience init for weather service data.
 *
 *  @param weatherServiceData       The weather service data
 *  @param serviceId                A unique ID tied to this specific service record.
 *  @return                         A SDLAppServiceData object
 */
- (instancetype)initWithWeatherServiceData:(SDLWeatherServiceData *)weatherServiceData serviceId:(NSString *)serviceId;

/**
 *  Convenience init for navigation service data.
 *
 *  @param navigationServiceData    The navigation service data
 *  @param serviceId                A unique ID tied to this specific service record.
 *  @return                         A SDLAppServiceData object
 */
- (instancetype)initWithNavigationServiceData:(nullable SDLNavigationServiceData *)navigationServiceData serviceId:(NSString *)serviceId;

/**
 *  Convenience init for all parameters.
 *
 *  @param serviceType              The type of service that is to be offered by this app.
 *  @param serviceId                A unique ID tied to this specific service record.
 *  @param mediaServiceData         The media service data
 *  @param weatherServiceData       The weather service data
 *  @param navigationServiceData    The navigation service data
 *  @return                         A SDLAppServiceData object
 */
- (instancetype)initWithServiceType:(NSString *)serviceType serviceId:(NSString *)serviceId mediaServiceData:(nullable SDLMediaServiceData *)mediaServiceData weatherServiceData:(nullable SDLWeatherServiceData *)weatherServiceData navigationServiceData:(nullable SDLNavigationServiceData *)navigationServiceData;

/**
 *  The type of service that is to be offered by this app. See AppServiceType.
 *
 *  String, See `SDLAppServiceType`, Required
 */
@property (strong, nonatomic) NSString *serviceType;

/**
 *  A unique ID tied to this specific service record. The ID is supplied by the module that services publish themselves.
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

/**
 *  The navigation service data.
 *
 *  SDLNavigationServiceData, Optional
 */
@property (nullable, strong, nonatomic) SDLNavigationServiceData *navigationServiceData;

@end

NS_ASSUME_NONNULL_END
