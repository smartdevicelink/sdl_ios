//
//  SDLPerformAppServiceInteraction.h
//  SmartDeviceLink
//
//  Created by Nicole on 2/6/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLRPCRequest.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  App service providers will likely have different actions exposed to the module and app service consumers. It will be difficult to standardize these actions by RPC versions and can easily become stale. Therefore, we introduce a best-effort attempt to take actions on a service.
 *
 *  The `PerformAppServiceInteraction` request will be sent to the service that has the matching `appServiceId`. The `serviceUri` should be the fully qualified URI with all parameters that are necessary for the given action. The URI prefix and actions list will be contained in the app service provider's manifest. SDL takes no steps to validate an app service provider's action sheet JSON object. In the future, plug in libraries could be added to handle these sheets on a provider by provider basis.
 *
 *  An app service consumer can also request for this service to become the active service of its respective type. If the app service consumer currently has an HMI state of HMI_FULL this request can be performed without user interaction. If the app is currently not in that state, the HMI should present the user with a choice to allow this app service provider to become the active service of its specified type. If the app service provider is not allowed to become active, the request will not be sent to it and an unsuccessful response will be sent to the requester.
 *
 *  SDL should make no guarantees that:
 *      1. App service providers offer URI prefix and URI Schema
 *      2. App service providers will correctly respond to the requests
 *      3. The requested app service provider will become the active service of that type
 *      4. The `serviceUri` will be a correctly formatted URI from the app service consumer
 */
@interface SDLPerformAppServiceInteraction : SDLRPCRequest

/**
 *  Convenience init for required parameters.
 *
 *  @param serviceUri               The service URI
 *  @param serviceID                The app service ID
 *  @param originApp                The origin app
 *  @return                         A SDLPerformAppServiceInteraction object
 */
- (instancetype)initWithServiceUri:(NSString *)serviceUri serviceID:(NSString *)serviceID originApp:(NSString *)originApp;

/**
 *  Convenience init for all parameters.
 *
 *  @param serviceUri               The service URI
 *  @param serviceID                The app service ID
 *  @param originApp                The origin app
 *  @param requestServiceActive     Whether or not the service is active
 *  @return                         A SDLPerformAppServiceInteraction object
 */
- (instancetype)initWithServiceUri:(NSString *)serviceUri serviceID:(NSString *)serviceID originApp:(NSString *)originApp requestServiceActive:(BOOL)requestServiceActive;

/**
 *  Fully qualified URI based on a predetermined scheme provided by the app service. SDL makes no guarantee that this URI is correct.
 *
 *  String, Required
 */
@property (strong, nonatomic) NSString *serviceUri;

/**
 *  The service ID that the app consumer wishes to send this URI.
 *
 *  String, Required
 */
@property (strong, nonatomic) NSString *serviceID;

/**
 *  This string is the appID of the app requesting the app service provider take the specific action.
 *
 *  String, Required
 */
@property (strong, nonatomic) NSString *originApp;

/**
 *  This flag signals the requesting consumer would like this service to become the active primary service of the destination's type.
 *
 *  Boolean, Optional
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *requestServiceActive;

@end

NS_ASSUME_NONNULL_END
