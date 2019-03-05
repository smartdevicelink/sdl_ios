//
//  SDLAppServiceManifest.m
//  SmartDeviceLink
//
//  Created by Nicole on 1/25/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLAppServiceManifest.h"
#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"

#import "SDLFunctionID.h"
#import "SDLImage.h"
#import "SDLMediaServiceManifest.h"
#import "SDLNavigationServiceManifest.h"
#import "SDLSyncMsgVersion.h"
#import "SDLWeatherServiceManifest.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLAppServiceManifest

- (instancetype)initWithServiceType:(NSString *)serviceType {
    self = [super init];
    if (!self) {
        return self;
    }

    self.serviceType = serviceType;

    return self;
}

- (instancetype)initWithServiceName:(nullable NSString *)serviceName serviceType:(NSString *)serviceType serviceIcon:(nullable SDLImage *)serviceIcon allowAppConsumers:(BOOL)allowAppConsumers rpcSpecVersion:(nullable SDLSyncMsgVersion *)rpcSpecVersion handledRPCs:(nullable NSArray<NSNumber<SDLInt> *> *)handledRPCs mediaServiceManifest:(nullable SDLMediaServiceManifest *)mediaServiceManifest {
    return [self initWithServiceName:serviceName serviceType:serviceType serviceIcon:serviceIcon allowAppConsumers:allowAppConsumers rpcSpecVersion:rpcSpecVersion handledRPCs:handledRPCs mediaServiceManifest:mediaServiceManifest weatherServiceManifest:nil navigationServiceManifest:nil];
}

- (instancetype)initWithServiceName:(nullable NSString *)serviceName serviceType:(NSString *)serviceType serviceIcon:(nullable SDLImage *)serviceIcon allowAppConsumers:(BOOL)allowAppConsumers rpcSpecVersion:(nullable SDLSyncMsgVersion *)rpcSpecVersion handledRPCs:(nullable NSArray<NSNumber<SDLInt> *> *)handledRPCs weatherServiceManifest:(nullable SDLWeatherServiceManifest *)weatherServiceManifest {
    return [self initWithServiceName:serviceName serviceType:serviceType serviceIcon:serviceIcon allowAppConsumers:allowAppConsumers rpcSpecVersion:rpcSpecVersion handledRPCs:handledRPCs mediaServiceManifest:nil weatherServiceManifest:weatherServiceManifest navigationServiceManifest:nil];
}

- (instancetype)initWithServiceName:(nullable NSString *)serviceName serviceType:(NSString *)serviceType serviceIcon:(nullable SDLImage *)serviceIcon allowAppConsumers:(BOOL)allowAppConsumers rpcSpecVersion:(nullable SDLSyncMsgVersion *)rpcSpecVersion handledRPCs:(nullable NSArray<NSNumber<SDLInt> *> *)handledRPCs navigationServiceManifest:(nullable SDLNavigationServiceManifest *)navigationServiceManifest {
    return [self initWithServiceName:serviceName serviceType:serviceType serviceIcon:serviceIcon allowAppConsumers:allowAppConsumers rpcSpecVersion:rpcSpecVersion handledRPCs:handledRPCs mediaServiceManifest:nil weatherServiceManifest:nil navigationServiceManifest:navigationServiceManifest];
}

- (instancetype)initWithServiceName:(nullable NSString *)serviceName serviceType:(NSString *)serviceType serviceIcon:(nullable SDLImage *)serviceIcon allowAppConsumers:(BOOL)allowAppConsumers rpcSpecVersion:(nullable SDLSyncMsgVersion *)rpcSpecVersion handledRPCs:(nullable NSArray<NSNumber<SDLInt> *> *)handledRPCs mediaServiceManifest:(nullable SDLMediaServiceManifest *)mediaServiceManifest weatherServiceManifest:(nullable SDLWeatherServiceManifest *)weatherServiceManifest navigationServiceManifest:(nullable SDLNavigationServiceManifest *)navigationServiceManifest {
    self = [self initWithServiceType:serviceType];
    if (!self) {
        return self;
    }

    self.serviceName = serviceName;
    self.serviceIcon = serviceIcon;
    self.allowAppConsumers = @(allowAppConsumers);
    self.rpcSpecVersion = rpcSpecVersion;
    self.handledRPCs = handledRPCs;
    self.mediaServiceManifest = mediaServiceManifest;
    self.weatherServiceManifest = weatherServiceManifest;
    self.navigationServiceManifest = navigationServiceManifest;

    return self;
}

- (void)setServiceName:(nullable NSString *)serviceName {
    [store sdl_setObject:serviceName forName:SDLRPCParameterNameServiceName];
}

- (nullable NSString *)serviceName {
    return [store sdl_objectForName:SDLRPCParameterNameServiceName];
}

- (void)setServiceType:(NSString *)serviceType {
    [store sdl_setObject:serviceType forName:SDLRPCParameterNameServiceType];
}

- (NSString *)serviceType {
    return [store sdl_objectForName:SDLRPCParameterNameServiceType];
}

- (void)setServiceIcon:(nullable SDLImage *)serviceIcon {
    [store sdl_setObject:serviceIcon forName:SDLRPCParameterNameServiceIcon];
}

- (nullable SDLImage *)serviceIcon {
    return [store sdl_objectForName:SDLRPCParameterNameServiceIcon ofClass:SDLImage.class];
}

- (void)setAllowAppConsumers:(nullable  NSNumber<SDLBool> *)allowAppConsumers {
    [store sdl_setObject:allowAppConsumers forName:SDLRPCParameterNameAllowAppConsumers];
}

- (nullable NSNumber<SDLBool> *)allowAppConsumers {
    return [store sdl_objectForName:SDLRPCParameterNameAllowAppConsumers];
}

- (void)setRpcSpecVersion:(nullable SDLSyncMsgVersion *)rpcSpecVersion {
    [store sdl_setObject:rpcSpecVersion forName:SDLRPCParameterNameRPCSpecVersion];
}

- (nullable SDLSyncMsgVersion *)rpcSpecVersion {
    return [store sdl_objectForName:SDLRPCParameterNameRPCSpecVersion ofClass:SDLSyncMsgVersion.class];
}

- (void)setHandledRPCs:(nullable NSArray<NSNumber<SDLInt> *> *)handledRPCs {
    [store sdl_setObject:handledRPCs forName:SDLRPCParameterNameHandledRPCs];
}

- (nullable NSArray<NSNumber<SDLInt> *> *)handledRPCs {
    return [store sdl_objectForName:SDLRPCParameterNameHandledRPCs];
}

- (void)setWeatherServiceManifest:(nullable SDLWeatherServiceManifest *)weatherServiceManifest {
    [store sdl_setObject:weatherServiceManifest forName:SDLRPCParameterNameWeatherServiceManifest];
}

- (nullable SDLWeatherServiceManifest *)weatherServiceManifest {
    return [store sdl_objectForName:SDLRPCParameterNameWeatherServiceManifest ofClass:SDLWeatherServiceManifest.class];
}

- (void)setMediaServiceManifest:(nullable SDLMediaServiceManifest *)mediaServiceManifest {
    [store sdl_setObject:mediaServiceManifest forName:SDLRPCParameterNameMediaServiceManifest];
}

- (nullable SDLMediaServiceManifest *)mediaServiceManifest {
    return [store sdl_objectForName:SDLRPCParameterNameMediaServiceManifest ofClass:SDLMediaServiceManifest.class];
}

- (void)setNavigationServiceManifest:(nullable SDLNavigationServiceManifest *)navigationServiceManifest {
    [store sdl_setObject:navigationServiceManifest forName:SDLRPCParameterNameNavigationServiceManifest];
}

- (nullable SDLNavigationServiceManifest *)navigationServiceManifest {
    return [store sdl_objectForName:SDLRPCParameterNameNavigationServiceManifest ofClass:SDLNavigationServiceManifest.class];
}

@end

NS_ASSUME_NONNULL_END
