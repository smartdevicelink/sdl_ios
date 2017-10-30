//
//  SDLNavigationCapability.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 7/11/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "SDLNavigationCapability.h"

#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"

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
    [store sdl_setObject:sendLocationEnabled forName:SDLNameSendLocationEnabled];
}

- (nullable NSNumber *)sendLocationEnabled {
    return [store sdl_objectForName:SDLNameSendLocationEnabled];
}

- (void)setGetWayPointsEnabled:(nullable NSNumber *)getWayPointsEnabled {
    [store sdl_setObject:getWayPointsEnabled forName:SDLNameGetWayPointsEnabled];
}

- (nullable NSNumber *)getWayPointsEnabled {
    return [store sdl_objectForName:SDLNameGetWayPointsEnabled];
}

@end

NS_ASSUME_NONNULL_END
