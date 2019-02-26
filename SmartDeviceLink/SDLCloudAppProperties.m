//
//  SDLCloudAppProperties.m
//  SmartDeviceLink
//
//  Created by Nicole on 2/26/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLCloudAppProperties.h"

#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"


NS_ASSUME_NONNULL_BEGIN

@implementation SDLCloudAppProperties

- (instancetype)initWithAppName:(NSString *)appName appID:(NSString *)appID {
    self = [super init];
    if (!self) {
        return nil;
    }

    self.appName = appName;
    self.appID = appID;

    return self;
}

- (instancetype)initWithAppName:(NSString *)appName appID:(NSString *)appID enabled:(BOOL)enabled authToken:(nullable NSString *)authToken cloudTransportType:(nullable NSString *)cloudTransportType hybridAppPreference:(nullable SDLHybridAppPreference)hybridAppPreference endpoint:(nullable NSString *)endpoint {
    self = [self initWithAppName:appName appID:appID];
    if (!self) {
        return nil;
    }

    self.enabled = @(enabled);
    self.authToken = authToken;
    self.cloudTransportType = cloudTransportType;
    self.hybridAppPreference = hybridAppPreference;
    self.endpoint = endpoint;

    return self;
}

- (void)setAppName:(NSString *)appName {
    [store sdl_setObject:appName forName:SDLNameAppName];
}

- (NSString *)appName {
    return [store sdl_objectForName:SDLNameAppName];
}

- (void)setAppID:(NSString *)appID {
    [store sdl_setObject:appID forName:SDLNameAppId];
}

- (NSString *)appID {
    return [store sdl_objectForName:SDLNameAppId];
}

- (void)setEnabled:(nullable NSNumber<SDLBool> *)enabled {
    [store sdl_setObject:enabled forName:SDLNameEnabled];
}

- (nullable NSNumber<SDLBool> *)enabled {
    return [store sdl_objectForName:SDLNameEnabled];
}

- (void)setAuthToken:(nullable NSString *)authToken {
    [store sdl_setObject:authToken forName:SDLNameAuthToken];
}

- (nullable NSString *)authToken {
    return [store sdl_objectForName:SDLNameAuthToken];
}

- (void)setCloudTransportType:(nullable NSString *)cloudTransportType {
    [store sdl_setObject:cloudTransportType forName:SDLNameCloudTransportType];
}

- (nullable NSString *)cloudTransportType {
    return [store sdl_objectForName:SDLNameCloudTransportType];
}

- (void)setHybridAppPreference:(nullable SDLHybridAppPreference)hybridAppPreference {
    [store sdl_setObject:hybridAppPreference forName:SDLNameHybridAppPreference];
}

- (nullable SDLHybridAppPreference)hybridAppPreference {
    return [store sdl_objectForName:SDLNameHybridAppPreference];
}

- (void)setEndpoint:(nullable NSString *)endpoint {
    [store sdl_setObject:endpoint forName:SDLNameEndpoint];
}

- (nullable NSString *)endpoint {
    return [store sdl_objectForName:SDLNameEndpoint];
}

@end

NS_ASSUME_NONNULL_END
