//
//  SDLNavigationCapability.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 7/11/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "SDLNavigationCapability.h"

#import "SDLNames.h"

@implementation SDLNavigationCapability

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }

    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
    }
    return self;
}

- (instancetype)initWithSendLocation:(BOOL)sendLocationEnabled waypoints:(BOOL)waypointsEnabled {
    self = [self init];
    if (!self) {
        return self;
    }

    self.sendLocationEnabled = @(sendLocationEnabled);
    self.getWayPointsEnabled = @(waypointsEnabled);

    return self;
}

- (void)setSendLocationEnabled:(NSNumber *)sendLocationEnabled {
    if (sendLocationEnabled != nil) {
        store[NAMES_sendLocationEnabled] = sendLocationEnabled;
    } else {
        [store removeObjectForKey:NAMES_sendLocationEnabled];
    }
}

- (NSNumber *)sendLocationEnabled {
    return store[NAMES_sendLocationEnabled];
}

- (void)setGetWayPointsEnabled:(NSNumber *)getWayPointsEnabled {
    if (getWayPointsEnabled != nil) {
        store[NAMES_getWayPointsEnabled] = getWayPointsEnabled;
    } else {
        [store removeObjectForKey:NAMES_getWayPointsEnabled];
    }
}

- (NSNumber *)getWayPointsEnabled {
    return store[NAMES_getWayPointsEnabled];
}

@end
