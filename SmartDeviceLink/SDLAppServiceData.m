//
//  SDLAppServiceData.m
//  SmartDeviceLink
//
//  Created by Nicole on 2/1/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLAppServiceData.h"
#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"

#import "SDLMediaServiceData.h"
#import "SDLWeatherServiceData.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLAppServiceData

- (instancetype)initWithServiceType:(NSString *)serviceType serviceId:(NSString *)serviceId mediaServiceData:(nullable SDLMediaServiceData *)mediaServiceData weatherServiceData:(nullable SDLWeatherServiceData *)weatherServiceData {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.serviceType = serviceType;
    self.serviceId = serviceId;
    self.mediaServiceData = mediaServiceData;
    self.weatherServiceData = weatherServiceData;

    return self;
}

- (void)setServiceType:(NSString *)serviceType {
    [store sdl_setObject:serviceType forName:SDLNameServiceType];
}

- (NSString *)serviceType {
    return [store sdl_objectForName:SDLNameServiceType];
}

- (void)setServiceId:(NSString *)serviceId {
    [store sdl_setObject:serviceId forName:SDLNameServiceID];
}

-(NSString *)serviceId {
    return [store sdl_objectForName:SDLNameServiceID];
}

- (void)setWeatherServiceData:(nullable SDLWeatherServiceData *)weatherServiceData {
    [store sdl_setObject:weatherServiceData forName:SDLNameWeatherServiceData];
}

- (nullable SDLWeatherServiceData *)weatherServiceData {
    return [store sdl_objectForName:SDLNameWeatherServiceData ofClass:SDLWeatherServiceData.class];
}

- (void)setMediaServiceData:(nullable SDLMediaServiceData *)mediaServiceData {
    [store sdl_setObject:mediaServiceData forName:SDLNameMediaServiceData];
}

- (nullable SDLMediaServiceData *)mediaServiceData {
    return [store sdl_objectForName:SDLNameMediaServiceData ofClass:SDLMediaServiceData.class];
}

@end

NS_ASSUME_NONNULL_END
