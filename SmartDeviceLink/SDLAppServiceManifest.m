//
//  SDLAppServiceManifest.m
//  SmartDeviceLink
//
//  Created by Nicole on 1/25/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLAppServiceManifest.h"
#import "NSMutableDictionary+Store.h"
#import "SDLFunctionID.h"
#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLAppServiceManifest

- (instancetype)initWithServiceName:(nullable NSString *)serviceName serviceType:(SDLAppServiceType)serviceType serviceIcon:(nullable NSString *)serviceIcon allowAppConsumers:(BOOL)allowAppConsumers uriPrefix:(nullable NSString *)uriPrefix rpcSpecVersion:(nullable SDLSyncMsgVersion *)rpcSpecVersion handledRPCs:(nullable NSArray<SDLFunctionID *> *)handledRPCs mediaServiceManifest:(nullable SDLMediaServiceManifest *)mediaServiceManifest weatherServiceManifest:(nullable SDLWeatherServiceManifest *)weatherServiceManifest {
    self = [self init];
    if (!self) {
        return self;
    }

    self.serviceName = serviceName;
    self.serviceType = serviceType;
    self.serviceIcon = serviceIcon;
    self.allowAppConsumers = @(allowAppConsumers);
    self.uriPrefix = uriPrefix;
    self.rpcSpecVersion = rpcSpecVersion;
    self.handledRPCs = handledRPCs;
    self.mediaServiceManifest = mediaServiceManifest;
    self.weatherServiceManifest = weatherServiceManifest;

    return self;
}

- (void)setServiceName:(nullable NSString *)serviceName {
    [store sdl_setObject:serviceName forName:SDLNameServiceName];
}

- (nullable NSString *)serviceName {
    return [store sdl_objectForName:SDLNameServiceName];
}

- (void)setServiceType:(SDLAppServiceType)serviceType {
    [store sdl_setObject:serviceType forName:SDLNameServiceType];
}

- (SDLAppServiceType)serviceType {
    return [store sdl_objectForName:SDLNameServiceType];
}

- (void)setServiceIcon:(nullable  NSString *)serviceIcon {
    [store sdl_setObject:serviceIcon forName:SDLNameServiceIcon];
}

- (nullable NSString *)serviceIcon {
    return [store sdl_objectForName:SDLNameServiceIcon];
}

- (void)setAllowAppConsumers:(nullable  NSNumber<SDLBool> *)allowAppConsumers {
    [store sdl_setObject:allowAppConsumers forName:SDLNameAllowAppConsumers];
}

- (nullable NSNumber<SDLBool> *)allowAppConsumers {
    return [store sdl_objectForName:SDLNameAllowAppConsumers];
}

- (void)setUriPrefix:(nullable NSString *)uriPrefix {
    [store sdl_setObject:uriPrefix forName:SDLNameURIPrefix];
}

- (nullable NSString *)uriPrefix {
    return [store sdl_objectForName:SDLNameURIPrefix];
}

- (void)setRpcSpecVersion:(nullable SDLSyncMsgVersion *)rpcSpecVersion {
    [store sdl_setObject:rpcSpecVersion forName:SDLNameRPCSpecVersion];
}

- (nullable SDLSyncMsgVersion *)rpcSpecVersion {
    return [store sdl_objectForName:SDLNameRPCSpecVersion ofClass:SDLSyncMsgVersion.class];
}

- (void)setHandledRPCs:(nullable NSArray<SDLFunctionID *> *)handledRPCs {
    [store sdl_setObject:handledRPCs forName:SDLNameHandledRPCs];
}

- (nullable NSArray<SDLFunctionID *> *)handledRPCs {
    return [store sdl_objectsForName:SDLNameHandledRPCs ofClass:SDLFunctionID.class];
}

- (void)setWeatherServiceManifest:(nullable SDLWeatherServiceManifest *)weatherServiceManifest {
    [store sdl_setObject:weatherServiceManifest forName:SDLNameWeatherServiceManifest];
}

- (nullable SDLWeatherServiceManifest *)weatherServiceManifest {
    return [store sdl_objectForName:SDLNameWeatherServiceManifest ofClass:SDLWeatherServiceManifest.class];
}

- (void)setMediaServiceManifest:(nullable SDLMediaServiceManifest *)mediaServiceManifest {
    [store sdl_setObject:mediaServiceManifest forName:SDLNameMediaServiceManifest];
}

- (nullable SDLMediaServiceManifest *)mediaServiceManifest {
    return [store sdl_objectForName:SDLNameMediaServiceManifest ofClass:SDLMediaServiceManifest.class];
}

@end

NS_ASSUME_NONNULL_END
