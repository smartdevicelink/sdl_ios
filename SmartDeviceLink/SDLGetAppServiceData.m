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

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameGetAppServiceData]) {
    }
    return self;
}
#pragma clang diagnostic pop

- (instancetype)initWithAppServiceType:(SDLAppServiceType)serviceType {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.serviceType = serviceType;

    return self;
}

- (instancetype)initAndSubscribeToAppServiceType:(SDLAppServiceType)serviceType {
    return [self initWithServiceType:serviceType subscribe:YES];
}

- (instancetype)initAndUnsubscribeToAppServiceType:(SDLAppServiceType)serviceType {
    return [self initWithServiceType:serviceType subscribe:NO];
}

- (instancetype)initWithServiceType:(SDLAppServiceType)serviceType subscribe:(BOOL)subscribe {
    self = [self initWithAppServiceType:serviceType];
    if (!self) {
        return nil;
    }

    self.subscribe = @(subscribe);

    return self;
}

- (void)setServiceType:(NSString *)serviceType {
    [self.parameters sdl_setObject:serviceType forName:SDLRPCParameterNameServiceType];
}

- (NSString *)serviceType {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameServiceType ofClass:NSString.class error:&error];
}

- (void)setSubscribe:(nullable NSNumber<SDLBool> *)subscribe {
    [self.parameters sdl_setObject:subscribe forName:SDLRPCParameterNameSubscribe];
}

- (nullable NSNumber<SDLBool> *)subscribe {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameSubscribe ofClass:NSNumber.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
