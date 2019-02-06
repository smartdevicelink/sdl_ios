//
//  SDLPerformAppServiceInteraction.m
//  SmartDeviceLink
//
//  Created by Nicole on 2/6/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLPerformAppServiceInteraction.h"
#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"


NS_ASSUME_NONNULL_BEGIN

@implementation SDLPerformAppServiceInteraction

- (instancetype)init {
    if (self = [super initWithName:SDLNamePerformAppServiceInteraction]) {
    }
    return self;
}

- (instancetype)initWithServiceUri:(NSString *)serviceUri appServiceId:(NSString *)appServiceId originApp:(NSString *)originApp requestServiceActive:(BOOL)requestServiceActive {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.serviceUri = serviceUri;
    self.appServiceId = appServiceId;
    self.originApp = originApp;
    self.requestServiceActive = @(requestServiceActive);

    return self;
}

- (void)setServiceUri:(NSString *)serviceUri {
    [parameters sdl_setObject:serviceUri forName:SDLNameServiceUri];
}

- (NSString *)serviceUri {
    return [parameters sdl_objectForName:SDLNameServiceUri];
}

- (void)setAppServiceId:(NSString *)appServiceId {
    [parameters sdl_setObject:appServiceId forName:SDLNameAppServiceId];
}

- (NSString *)appServiceId {
    return [parameters sdl_objectForName:SDLNameAppServiceId];
}

- (void)setOriginApp:(NSString *)originApp {
    [parameters sdl_setObject:originApp forName:SDLNameOriginApp];
}

- (NSString *)originApp {
    return [parameters sdl_objectForName:SDLNameOriginApp];
}

- (void)setRequestServiceActive:(nullable NSNumber<SDLBool> *)requestServiceActive {
    [parameters sdl_setObject:requestServiceActive forName:SDLNameRequestServiceActive];
}

- (nullable NSNumber<SDLBool> *)requestServiceActive {
    return [parameters sdl_objectForName:SDLNameRequestServiceActive];
}
@end

NS_ASSUME_NONNULL_END
