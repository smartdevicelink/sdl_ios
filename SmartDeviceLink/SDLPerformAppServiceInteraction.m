//
//  SDLPerformAppServiceInteraction.m
//  SmartDeviceLink
//
//  Created by Nicole on 2/6/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLPerformAppServiceInteraction.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"


NS_ASSUME_NONNULL_BEGIN

@implementation SDLPerformAppServiceInteraction

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNamePerformAppServiceInteraction]) {
    }
    return self;
}
#pragma clang diagnostic pop

- (instancetype)initWithServiceUri:(NSString *)serviceUri serviceID:(NSString *)serviceID originApp:(NSString *)originApp {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.serviceUri = serviceUri;
    self.serviceID = serviceID;
    self.originApp = originApp;

    return self;
}

- (instancetype)initWithServiceUri:(NSString *)serviceUri serviceID:(NSString *)serviceID originApp:(NSString *)originApp requestServiceActive:(BOOL)requestServiceActive {
    self = [self initWithServiceUri:serviceUri serviceID:serviceID originApp:originApp];
    if (!self) {
        return nil;
    }

    self.requestServiceActive = @(requestServiceActive);

    return self;
}

- (void)setServiceUri:(NSString *)serviceUri {
    [self.parameters sdl_setObject:serviceUri forName:SDLRPCParameterNameServiceUri];
}

- (NSString *)serviceUri {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameServiceUri ofClass:NSString.class error:&error];
}

- (void)setServiceID:(NSString *)serviceID {
    [self.parameters sdl_setObject:serviceID forName:SDLRPCParameterNameServiceID];
}

- (NSString *)serviceID {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameServiceID ofClass:NSString.class error:&error];
}

- (void)setOriginApp:(NSString *)originApp {
    [self.parameters sdl_setObject:originApp forName:SDLRPCParameterNameOriginApp];
}

- (NSString *)originApp {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameOriginApp ofClass:NSString.class error:&error];
}

- (void)setRequestServiceActive:(nullable NSNumber<SDLBool> *)requestServiceActive {
    [self.parameters sdl_setObject:requestServiceActive forName:SDLRPCParameterNameRequestServiceActive];
}

- (nullable NSNumber<SDLBool> *)requestServiceActive {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameRequestServiceActive ofClass:NSNumber.class error:nil];
}
@end

NS_ASSUME_NONNULL_END
