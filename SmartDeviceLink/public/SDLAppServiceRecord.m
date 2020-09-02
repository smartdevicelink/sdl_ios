//
//  SDLAppServiceRecord.m
//  SmartDeviceLink
//
//  Created by Nicole on 1/25/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLAppServiceRecord.h"

#import "NSMutableDictionary+Store.h"
#import "SDLAppServiceManifest.h"
#import "SDLRPCParameterNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLAppServiceRecord

- (instancetype)initWithServiceID:(NSString *)serviceID serviceManifest:(SDLAppServiceManifest *)serviceManifest servicePublished:(BOOL)servicePublished serviceActive:(BOOL)serviceActive {
    self = [self init];
    if (!self) {
        return self;
    }

    self.serviceID = serviceID;
    self.serviceManifest = serviceManifest;
    self.servicePublished = @(servicePublished);
    self.serviceActive = @(serviceActive);

    return self;
}

- (void)setServiceID:(NSString *)serviceID {
    [self.store sdl_setObject:serviceID forName:SDLRPCParameterNameServiceID];
}

- (NSString *)serviceID {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNameServiceID ofClass:NSString.class error:&error];
}

- (void)setServiceManifest:(SDLAppServiceManifest *)serviceManifest {
    [self.store sdl_setObject:serviceManifest forName:SDLRPCParameterNameServiceManifest];
}

- (SDLAppServiceManifest *)serviceManifest {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNameServiceManifest ofClass:SDLAppServiceManifest.class error:&error];
}

- (void)setServicePublished:(NSNumber<SDLBool> *)servicePublished {
    [self.store sdl_setObject:servicePublished forName:SDLRPCParameterNameServicePublished];
}

- (NSNumber<SDLBool> *)servicePublished {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNameServicePublished ofClass:NSNumber.class error:&error];
}

- (void)setServiceActive:(NSNumber<SDLBool> *)serviceActive {
    [self.store sdl_setObject:serviceActive forName:SDLRPCParameterNameServiceActive];
}

- (NSNumber<SDLBool> *)serviceActive {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNameServiceActive ofClass:NSNumber.class error:&error];
}

@end

NS_ASSUME_NONNULL_END
