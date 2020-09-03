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
#import "SDLMsgVersion.h"
#import "SDLWeatherServiceManifest.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLAppServiceManifest

- (instancetype)initWithAppServiceType:(SDLAppServiceType)serviceType {
    self = [super init];
    if (!self) {
        return self;
    }

    self.serviceType = serviceType;

    return self;
}

- (instancetype)initWithMediaServiceName:(nullable NSString *)serviceName serviceIcon:(nullable SDLImage *)serviceIcon allowAppConsumers:(BOOL)allowAppConsumers maxRPCSpecVersion:(nullable SDLMsgVersion *)maxRPCSpecVersion handledRPCs:(nullable NSArray<NSNumber<SDLInt> *> *)handledRPCs mediaServiceManifest:(nullable SDLMediaServiceManifest *)mediaServiceManifest {
     return [self initWithServiceName:serviceName serviceType:SDLAppServiceTypeMedia serviceIcon:serviceIcon  allowAppConsumers:allowAppConsumers maxRPCSpecVersion:maxRPCSpecVersion handledRPCs:handledRPCs mediaServiceManifest:mediaServiceManifest weatherServiceManifest:nil navigationServiceManifest:nil];
}

- (instancetype)initWithWeatherServiceName:(nullable NSString *)serviceName serviceIcon:(nullable SDLImage *)serviceIcon allowAppConsumers:(BOOL)allowAppConsumers maxRPCSpecVersion:(nullable SDLMsgVersion *)maxRPCSpecVersion handledRPCs:(nullable NSArray<NSNumber<SDLInt> *> *)handledRPCs weatherServiceManifest:(nullable SDLWeatherServiceManifest *)weatherServiceManifest {
    return [self initWithServiceName:serviceName serviceType:SDLAppServiceTypeWeather serviceIcon:serviceIcon allowAppConsumers:allowAppConsumers maxRPCSpecVersion:maxRPCSpecVersion handledRPCs:handledRPCs mediaServiceManifest:nil weatherServiceManifest:weatherServiceManifest navigationServiceManifest:nil];
}

- (instancetype)initWithNavigationServiceName:(nullable NSString *)serviceName serviceIcon:(nullable SDLImage *)serviceIcon  allowAppConsumers:(BOOL)allowAppConsumers maxRPCSpecVersion:(nullable SDLMsgVersion *)maxRPCSpecVersion handledRPCs:(nullable NSArray<NSNumber<SDLInt> *> *)handledRPCs navigationServiceManifest:(nullable SDLNavigationServiceManifest *)navigationServiceManifest {
    return [self initWithServiceName:serviceName serviceType:SDLAppServiceTypeNavigation serviceIcon:serviceIcon allowAppConsumers:allowAppConsumers maxRPCSpecVersion:maxRPCSpecVersion handledRPCs:handledRPCs mediaServiceManifest:nil weatherServiceManifest:nil navigationServiceManifest:navigationServiceManifest];
}

- (instancetype)initWithServiceName:(nullable NSString *)serviceName serviceType:(SDLAppServiceType)serviceType serviceIcon:(nullable SDLImage *)serviceIcon allowAppConsumers:(BOOL)allowAppConsumers maxRPCSpecVersion:(nullable SDLMsgVersion *)maxRPCSpecVersion handledRPCs:(nullable NSArray<NSNumber<SDLInt> *> *)handledRPCs mediaServiceManifest:(nullable SDLMediaServiceManifest *)mediaServiceManifest weatherServiceManifest:(nullable SDLWeatherServiceManifest *)weatherServiceManifest navigationServiceManifest:(nullable SDLNavigationServiceManifest *)navigationServiceManifest {
    self = [self initWithAppServiceType:serviceType];
    if (!self) {
        return self;
    }

    self.serviceName = serviceName;
    self.serviceIcon = serviceIcon;
    self.allowAppConsumers = @(allowAppConsumers);
    self.maxRPCSpecVersion = maxRPCSpecVersion;
    self.handledRPCs = handledRPCs;
    self.mediaServiceManifest = mediaServiceManifest;
    self.weatherServiceManifest = weatherServiceManifest;
    self.navigationServiceManifest = navigationServiceManifest;

    return self;
}

- (void)setServiceName:(nullable NSString *)serviceName {
    [self.store sdl_setObject:serviceName forName:SDLRPCParameterNameServiceName];
}

- (nullable NSString *)serviceName {
    return [self.store sdl_objectForName:SDLRPCParameterNameServiceName ofClass:NSString.class error:nil];
}

- (void)setServiceType:(NSString *)serviceType {
    [self.store sdl_setObject:serviceType forName:SDLRPCParameterNameServiceType];
}

- (NSString *)serviceType {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNameServiceType ofClass:NSString.class error:&error];
}

- (void)setServiceIcon:(nullable SDLImage *)serviceIcon {
    [self.store sdl_setObject:serviceIcon forName:SDLRPCParameterNameServiceIcon];
}

- (nullable SDLImage *)serviceIcon {
    return [self.store sdl_objectForName:SDLRPCParameterNameServiceIcon ofClass:SDLImage.class error:nil];
}

- (void)setAllowAppConsumers:(nullable  NSNumber<SDLBool> *)allowAppConsumers {
    [self.store sdl_setObject:allowAppConsumers forName:SDLRPCParameterNameAllowAppConsumers];
}

- (nullable NSNumber<SDLBool> *)allowAppConsumers {
    return [self.store sdl_objectForName:SDLRPCParameterNameAllowAppConsumers ofClass:NSNumber.class error:nil];
}

- (void)setMaxRPCSpecVersion:(nullable SDLMsgVersion *)maxRPCSpecVersion {
    [self.store sdl_setObject:maxRPCSpecVersion forName:SDLRPCParameterNameRPCSpecVersion];
}

- (nullable SDLMsgVersion *)maxRPCSpecVersion {
  return [self.store sdl_objectForName:SDLRPCParameterNameRPCSpecVersion ofClass:SDLMsgVersion.class error:nil];
}

- (void)setHandledRPCs:(nullable NSArray<NSNumber *> *)handledRPCs {
    [self.store sdl_setObject:handledRPCs forName:SDLRPCParameterNameHandledRPCs];
}

- (nullable NSArray<NSNumber *> *)handledRPCs {
    return [self.store sdl_objectsForName:SDLRPCParameterNameHandledRPCs ofClass:NSNumber.class error:nil];
}

- (void)setWeatherServiceManifest:(nullable SDLWeatherServiceManifest *)weatherServiceManifest {
    [self.store sdl_setObject:weatherServiceManifest forName:SDLRPCParameterNameWeatherServiceManifest];
}

- (nullable SDLWeatherServiceManifest *)weatherServiceManifest {
    return [self.store sdl_objectForName:SDLRPCParameterNameWeatherServiceManifest ofClass:SDLWeatherServiceManifest.class error:nil];
}

- (void)setMediaServiceManifest:(nullable SDLMediaServiceManifest *)mediaServiceManifest {
    [self.store sdl_setObject:mediaServiceManifest forName:SDLRPCParameterNameMediaServiceManifest];
}

- (nullable SDLMediaServiceManifest *)mediaServiceManifest {
    return [self.store sdl_objectForName:SDLRPCParameterNameMediaServiceManifest ofClass:SDLMediaServiceManifest.class error:nil];
}

- (void)setNavigationServiceManifest:(nullable SDLNavigationServiceManifest *)navigationServiceManifest {
    [self.store sdl_setObject:navigationServiceManifest forName:SDLRPCParameterNameNavigationServiceManifest];
}

- (nullable SDLNavigationServiceManifest *)navigationServiceManifest {
    return [self.store sdl_objectForName:SDLRPCParameterNameNavigationServiceManifest ofClass:SDLNavigationServiceManifest.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
