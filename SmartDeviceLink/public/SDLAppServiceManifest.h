//
//  SDLAppServiceManifest.h
//  SmartDeviceLink
//
//  Created by Nicole on 1/25/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLRPCRequest.h"

#import "SDLAppServiceType.h"

@class SDLFunctionID;
@class SDLImage;
@class SDLMediaServiceManifest;
@class SDLNavigationServiceManifest;
@class SDLMsgVersion;
@class SDLWeatherServiceManifest;


NS_ASSUME_NONNULL_BEGIN

/**
 *  This manifest contains all the information necessary for the service to be published, activated, and allow consumers to interact with it
 */
@interface SDLAppServiceManifest : SDLRPCStruct

/**
 *  Convenience init for serviceType.
 *
 *  @param serviceType The type of service that is to be offered by this app
 *  @return            A SDLAppServiceManifest object
 */
- (instancetype)initWithAppServiceType:(SDLAppServiceType)serviceType NS_DESIGNATED_INITIALIZER;

/**
 *  Convenience init for a media service manifest.
 *
 *  @param serviceName              Unique name of this service
 *  @param serviceIcon              The file name of the icon to be associated with this service
 *  @param allowAppConsumers        If true, app service consumers beyond the IVI system will be able to access this service. If false, only the IVI system will be able consume the service. If not provided, it is assumed to be false
 *  @param maxRPCSpecVersion        This is the max RPC Spec version the app service understands
 *  @param handledRPCs              This field contains the Function IDs for the RPCs that this service intends to handle correctly
 *  @param mediaServiceManifest     A media service manifest
 *  @return                         A SDLAppServiceManifest object
 */
- (instancetype)initWithMediaServiceName:(nullable NSString *)serviceName serviceIcon:(nullable SDLImage *)serviceIcon allowAppConsumers:(BOOL)allowAppConsumers maxRPCSpecVersion:(nullable SDLMsgVersion *)maxRPCSpecVersion handledRPCs:(nullable NSArray<NSNumber<SDLInt> *> *)handledRPCs mediaServiceManifest:(nullable SDLMediaServiceManifest *)mediaServiceManifest;

/**
 *  Convenience init for a weather service manifest.
 *
 *  @param serviceName              Unique name of this service
 *  @param serviceIcon              The file name of the icon to be associated with this service
 *  @param allowAppConsumers        If true, app service consumers beyond the IVI system will be able to access this service. If false, only the IVI system will be able consume the service. If not provided, it is assumed to be false
 *  @param maxRPCSpecVersion        This is the max RPC Spec version the app service understands
 *  @param handledRPCs              This field contains the Function IDs for the RPCs that this service intends to handle correctly
 *  @param weatherServiceManifest   A weather service manifest
 *  @return                         A SDLAppServiceManifest object
 */
- (instancetype)initWithWeatherServiceName:(nullable NSString *)serviceName serviceIcon:(nullable SDLImage *)serviceIcon allowAppConsumers:(BOOL)allowAppConsumers maxRPCSpecVersion:(nullable SDLMsgVersion *)maxRPCSpecVersion handledRPCs:(nullable NSArray<NSNumber<SDLInt> *> *)handledRPCs weatherServiceManifest:(nullable SDLWeatherServiceManifest *)weatherServiceManifest;

/**
 *  Convenience init for a navigation service manifest.
 *
 *  @param serviceName                  Unique name of this service
 *  @param serviceIcon                  The file name of the icon to be associated with this service
 *  @param allowAppConsumers            If true, app service consumers beyond the IVI system will be able to access this service. If false, only the IVI system will be able consume the service. If not provided, it is assumed to be false
 *  @param maxRPCSpecVersion            This is the max RPC Spec version the app service understands
 *  @param handledRPCs                  This field contains the Function IDs for the RPCs that this service intends to handle correctly
 *  @param navigationServiceManifest    A navigation service manifest
 *  @return                             A SDLAppServiceManifest object
 */
- (instancetype)initWithNavigationServiceName:(nullable NSString *)serviceName serviceIcon:(nullable SDLImage *)serviceIcon allowAppConsumers:(BOOL)allowAppConsumers maxRPCSpecVersion:(nullable SDLMsgVersion *)maxRPCSpecVersion handledRPCs:(nullable NSArray<NSNumber<SDLInt> *> *)handledRPCs navigationServiceManifest:(nullable SDLNavigationServiceManifest *)navigationServiceManifest;

/**
 *  Convenience init for all parameters.
 *
 *  @param serviceName                  Unique name of this service
 *  @param serviceType                  The type of service that is to be offered by this app
 *  @param serviceIcon                  The file name of the icon to be associated with this service
 *  @param allowAppConsumers            If true, app service consumers beyond the IVI system will be able to access this service. If false, only the IVI system will be able consume the service. If not provided, it is assumed to be false
 *  @param maxRPCSpecVersion            This is the max RPC Spec version the app service understands
 *  @param handledRPCs                  This field contains the Function IDs for the RPCs that this service intends to handle correctly
 *  @param mediaServiceManifest         A media service manifest
 *  @param weatherServiceManifest       A weather service manifest
 *  @param navigationServiceManifest    A navigation service manifest
 *  @return                             A SDLAppServiceManifest object
 */
- (instancetype)initWithServiceName:(nullable NSString *)serviceName serviceType:(SDLAppServiceType)serviceType serviceIcon:(nullable SDLImage *)serviceIcon allowAppConsumers:(BOOL)allowAppConsumers maxRPCSpecVersion:(nullable SDLMsgVersion *)maxRPCSpecVersion handledRPCs:(nullable NSArray<NSNumber<SDLInt> *> *)handledRPCs mediaServiceManifest:(nullable SDLMediaServiceManifest *)mediaServiceManifest weatherServiceManifest:(nullable SDLWeatherServiceManifest *)weatherServiceManifest navigationServiceManifest:(nullable SDLNavigationServiceManifest *)navigationServiceManifest;

/**
 *  Unique name of this service.
 *
 *  String, Optional
 */
@property (nullable, strong, nonatomic) NSString *serviceName;

/**
 *  The type of service that is to be offered by this app. See AppServiceType for known enum equivalent types. Parameter is a string to allow for new service types to be used by apps on older versions of SDL Core.
 *
 *  String, See `SDLAppServiceType`, Required
 */
@property (strong, nonatomic) NSString *serviceType;

/**
 *  The file name of the icon to be associated with this service. Most likely the same as the appIcon.
 *
 *  String, Optional
 */
@property (nullable, strong, nonatomic) SDLImage *serviceIcon;

/**
 *  If true, app service consumers beyond the IVI system will be able to access this service. If false, only the IVI system will be able consume the service. If not provided, it is assumed to be false.
 *
 *  Boolean, Optional, default = NO
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *allowAppConsumers;

/**
 *  This is the max RPC Spec version the app service understands. This is important during the RPC passthrough functionality. If not included, it is assumed the max version of the module is acceptable.
 *
 *  SDLMsgVersion, Optional
 */
@property (nullable, strong, nonatomic) SDLMsgVersion *maxRPCSpecVersion;

/**
 *  This field contains the Function IDs for the RPCs that this service intends to handle correctly. This means the service will provide meaningful responses. See FunctionID for enum equivalent values. This parameter is an integer to allow for new function IDs to be used by apps on older versions of SDL Core.
 *
 *  Array of Integers, See `SDLFunctionID`, Optional
 */
@property (nullable, strong, nonatomic) NSArray<NSNumber *> *handledRPCs;

/**
 *  A media service manifest.
 *
 *  SDLMediaServiceManifest, Optional
 */
@property (nullable, strong, nonatomic) SDLMediaServiceManifest *mediaServiceManifest;

/**
 *  A weather service manifest.
 *
 *  SDLWeatherServiceManifest, Optional
 */
@property (nullable, strong, nonatomic) SDLWeatherServiceManifest *weatherServiceManifest;

/**
 *  A navigation service manifest.
 *
 *  SDLNavigationServiceManifest, Optional
 */
@property (nullable, strong, nonatomic) SDLNavigationServiceManifest *navigationServiceManifest;

@end

NS_ASSUME_NONNULL_END
