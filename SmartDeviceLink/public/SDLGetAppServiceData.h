//
//  SDLGetAppServiceData.h
//  SmartDeviceLink
//
//  Created by Nicole on 2/6/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLRPCRequest.h"

#import "SDLAppServiceType.h"


NS_ASSUME_NONNULL_BEGIN

/**
 *  This request asks the module for current data related to the specific service. It also includes an option to subscribe to that service for future updates.
 */
@interface SDLGetAppServiceData : SDLRPCRequest

/**
 *  Convenience init for service type.
 *
 *  @param serviceType      The app service type
 *  @return                 A SDLGetAppServiceData object
 */
- (instancetype)initWithAppServiceType:(SDLAppServiceType)serviceType;

/**
 *  Convenience init for subscribing to a service type.
 *
 *  @param serviceType      The app service type
 *  @return                 A SDLGetAppServiceData object
 */
- (instancetype)initAndSubscribeToAppServiceType:(SDLAppServiceType)serviceType;

/**
 Convenience init for unsubscribing to a service type

 @param serviceType The app service type
 @return A SDLGetAppServiceData object
 */
- (instancetype)initAndUnsubscribeToAppServiceType:(SDLAppServiceType)serviceType;

/**
 *  The type of service that is to be offered by this app. See `AppServiceType` for known enum equivalent types. Parameter is a string to allow for new service types to be used by apps on older versions of SDL Core.
 *
 *  String, See `SDLAppServiceType`, Required
 */
@property (strong, nonatomic) NSString *serviceType;

/**
 *  If true, the consumer is requesting to subscribe to all future updates from the service publisher. If false, the consumer doesn't wish to subscribe and should be unsubscribed if it was previously subscribed.
 *
 *  Boolean, Optional
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *subscribe;

@end

NS_ASSUME_NONNULL_END
