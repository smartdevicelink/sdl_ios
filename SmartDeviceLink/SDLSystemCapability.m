//
//  SDLSystemCapability.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 7/10/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "SDLSystemCapability.h"

#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"
#import "SDLNavigationCapability.h"
#import "SDLPhoneCapability.h"
#import "SDLSystemCapabilityType.h"
#import "SDLVideoStreamingCapability.h"
#import "SDLRemoteControlCapabilities.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLSystemCapability

- (instancetype)initWithPhoneCapability:(SDLPhoneCapability *)capability {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.systemCapabilityType = SDLSystemCapabilityTypePhoneCall;
    self.phoneCapability = capability;

    return self;
}

- (instancetype)initWithNavigationCapability:(SDLNavigationCapability *)capability {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.systemCapabilityType = SDLSystemCapabilityTypeNavigation;
    self.navigationCapability = capability;

    return self;
}

- (instancetype)initWithVideoStreamingCapability:(SDLVideoStreamingCapability *)capability {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.systemCapabilityType = SDLSystemCapabilityTypeVideoStreaming;
    self.videoStreamingCapability = capability;

    return self;
}

- (instancetype)initWithRemoteControlCapability:(SDLRemoteControlCapabilities *)capability {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.systemCapabilityType = SDLSystemCapabilityTypeRemoteControl;
    self.remoteControlCapability = capability;

    return self;
}

- (void)setSystemCapabilityType:(SDLSystemCapabilityType)type {
    [store sdl_setObject:type forName:SDLNameSystemCapabilityType];
}

- (SDLSystemCapabilityType)systemCapabilityType {
    return [store sdl_objectForName:SDLNameSystemCapabilityType];
}

// TODO: Nav / Phone Capability

- (void)setNavigationCapability:(nullable SDLNavigationCapability *)navigationCapability {
    [store sdl_setObject:navigationCapability forName:SDLNameNavigationCapability];
}

- (nullable SDLNavigationCapability *)navigationCapability {
    return [store sdl_objectForName:SDLNameNavigationCapability ofClass:SDLNavigationCapability.class];
}

- (void)setPhoneCapability:(nullable SDLPhoneCapability *)phoneCapability {
    [store sdl_setObject:phoneCapability forName:SDLNamePhoneCapability];
}

- (nullable SDLPhoneCapability *)phoneCapability {
    return [store sdl_objectForName:SDLNamePhoneCapability ofClass:SDLPhoneCapability.class];
}

- (void)setVideoStreamingCapability:(nullable SDLVideoStreamingCapability *)videoStreamingCapability {
    [store sdl_setObject:videoStreamingCapability forName:SDLNameVideoStreamingCapability];
}

- (nullable SDLVideoStreamingCapability *)videoStreamingCapability {
    return [store sdl_objectForName:SDLNameVideoStreamingCapability ofClass:SDLVideoStreamingCapability.class];
}

- (void)setRemoteControlCapability:(nullable SDLRemoteControlCapabilities *)remoteControlCapability {
    [store sdl_setObject:remoteControlCapability forName:SDLNameRemoteControlCapability];
}

- (nullable SDLRemoteControlCapabilities *)remoteControlCapability {
    return [store sdl_objectForName:SDLNameRemoteControlCapability ofClass:SDLRemoteControlCapabilities.class];
}

@end

NS_ASSUME_NONNULL_END
