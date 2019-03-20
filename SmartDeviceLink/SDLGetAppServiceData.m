//
//  SDLGetAppServiceData.m
//  SmartDeviceLink
//
//  Created by Nicole on 2/6/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLGetAppServiceData.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLGetAppServiceData

- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameGetAppServiceData]) {
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

- (instancetype)initWithAppServiceType:(SDLAppServiceType)serviceType {
    return [self initWithServiceType:serviceType];
}

- (instancetype)initAndSubscribeToAppServiceType:(SDLAppServiceType)serviceType {
    return [self initWithServiceType:serviceType subscribe:YES];
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
    [parameters sdl_setObject:serviceType forName:SDLRPCParameterNameServiceType];
}

- (NSString *)serviceType {
    return [parameters sdl_objectForName:SDLRPCParameterNameServiceType ofClass:NSString.class];
}

- (void)setSubscribe:(nullable NSNumber<SDLBool> *)subscribe {
    [parameters sdl_setObject:subscribe forName:SDLRPCParameterNameSubscribe];
}

- (nullable NSNumber<SDLBool> *)subscribe {
    return [parameters sdl_objectForName:SDLRPCParameterNameSubscribe ofClass:NSNumber.class];
}

@end

NS_ASSUME_NONNULL_END
