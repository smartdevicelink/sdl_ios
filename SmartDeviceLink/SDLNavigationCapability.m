//
//  SDLNavigationCapability.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 7/11/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "SDLNavigationCapability.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLNavigationCapability

- (instancetype)initWithSendLocation:(BOOL)sendLocationEnabled waypoints:(BOOL)waypointsEnabled {
    self = [self init];
    if (!self) {
        return self;
    }

    self.sendLocationEnabled = @(sendLocationEnabled);
    self.getWayPointsEnabled = @(waypointsEnabled);

    return self;
}

- (void)setSendLocationEnabled:(nullable NSNumber *)sendLocationEnabled {
    [self.store sdl_setObject:sendLocationEnabled forName:SDLRPCParameterNameSendLocationEnabled];
}

- (nullable NSNumber *)sendLocationEnabled {
    return [self.store sdl_objectForName:SDLRPCParameterNameSendLocationEnabled ofClass:NSNumber.class error:nil];
}

- (void)setGetWayPointsEnabled:(nullable NSNumber *)getWayPointsEnabled {
    [self.store sdl_setObject:getWayPointsEnabled forName:SDLRPCParameterNameGetWayPointsEnabled];
}

- (nullable NSNumber *)getWayPointsEnabled {
    return [self.store sdl_objectForName:SDLRPCParameterNameGetWayPointsEnabled ofClass:NSNumber.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
