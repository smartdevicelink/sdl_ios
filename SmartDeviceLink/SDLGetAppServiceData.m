//
//  SDLGetAppServiceData.m
//  SmartDeviceLink
//
//  Created by Nicole on 2/6/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLGetAppServiceData.h"

#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLGetAppServiceData

- (instancetype)init {
    if (self = [super initWithName:SDLNameGetAppServiceData]) {
    }
    return self;
}

- (instancetype)initWithServiceType:(NSString *)serviceType {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.serviceType = serviceType;

    return self;
}

- (instancetype)initWithServiceType:(NSString *)serviceType subscribe:(BOOL)subscribe {
    self = [self initWithServiceType:serviceType];
    if (!self) {
        return nil;
    }

    self.subscribe = @(subscribe);

    return self;
}

- (void)setServiceType:(NSString *)serviceType {
    [parameters sdl_setObject:serviceType forName:SDLNameServiceType];
}

- (NSString *)serviceType {
    return [parameters sdl_objectForName:SDLNameServiceType];
}

- (void)setSubscribe:(nullable NSNumber<SDLBool> *)subscribe {
    [parameters sdl_setObject:subscribe forName:SDLNameSubscribe];
}

- (nullable NSNumber<SDLBool> *)subscribe {
    return [parameters sdl_objectForName:SDLNameSubscribe];
}

@end

NS_ASSUME_NONNULL_END
