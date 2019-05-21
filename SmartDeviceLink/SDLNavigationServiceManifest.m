//
//  SDLNavigationServiceManifest.m
//  SmartDeviceLink
//
//  Created by Nicole on 2/25/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLNavigationServiceManifest.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLNavigationServiceManifest

- (instancetype)initWithAcceptsWayPoints:(BOOL)acceptsWayPoints {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.acceptsWayPoints = @(acceptsWayPoints);

    return self;
}

- (void)setAcceptsWayPoints:(nullable NSNumber<SDLBool> *)acceptsWayPoints {
    [self.store sdl_setObject:acceptsWayPoints forName:SDLRPCParameterNameAcceptsWayPoints];
}

- (nullable NSNumber<SDLBool> *)acceptsWayPoints {
    return [self.store sdl_objectForName:SDLRPCParameterNameAcceptsWayPoints ofClass:NSNumber.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
